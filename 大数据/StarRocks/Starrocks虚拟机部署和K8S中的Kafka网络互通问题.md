### 部署问题

先前为了解决Kafka集群重启后，客户端断连的问题，需要在Kafka服务器端中，配置Kafka的域名而不是Pod_IP。修改配置如下：

```json
# 先前
INTERNAL://$(POD_IP):9092
# 修改后
INTERNAL://$(POD_NAME).kafka-headless.ydata.svc:9092
```



Kafka客户端在2.8的SDK版本中，会从配置的bootstrap-servers中，找到对应的kafka集群，再从集群中获取整个kafka集群中的节点信息。这些节点信息包括地址端口等，按上述配置，客户端获取到的集群信息就为（以3节点的kafka为例）：

```
kafka-0.kafka-headless.ydata.svc:9092,kafka-1.kafka-headless.ydata.svc:9092,kafka-2.kafka-headless.ydata.svc:9092
```



bootstrap-servers的含义是启动地址，而不是真实的集群所有节点的地址，所以**可以配置kafka的代理，能让客户端在启动时连上任意一台可用的kafka节点即可**。



该方案配置的kafka-0.kafka-headless.ydata.svc等，均为k8s内部访问的域名，在k8s内部可以正常使用。但是对于部署在虚拟机上的starrocks来说，就无法直接访问k8s内部的域名了。



由于一些网络问题，dev环境的虚拟机，不能访问到k8s中的pod_ip，而预生产和生产环境，虚拟机能够直接访问到k8s中的pod_ip。



### 解决方案

为了保证k8s内部的flink 、ydata-ingestion、ydap等服务能够正常访问kafka，并且重启后不会断连，kafka应该尽量按照之前的建议进行配置。

- 使用fip绑定kafka节点

当前dev、预生产和生产的k8s，在pod启动时，可以绑定一个fip。非k8s外网的服务，可以通过fip进行访问。当前dev的部署模式。

![image-20220107103253860](images/image-20220107103253860.png)



缺点：流量走fip服务器，在压测时，可能会占用fip服务器的比较多的带宽；fip带宽费用较高；kafka节点需要绑定固定的fip；

优点：解决了dev环境，starrocks无法访问kafka的问题，原k8s的pod无需改动。



- 修改hosts文件指向pod_ip

在预生产和生产中，虚拟机和k8s都是部署在阿里云上，虚拟机可以访问到k8s中的pod_ip。当starrocks客户端获取到kafka的地址时，如kafka-0.kafka-headless.ydata.svc:9092，无法解析到对应的ip。需要手动将对应的pod_ip和kafka-headless的域名在hosts文件进行关联。

![image-20220107105204723](images/image-20220107105204723.png)





缺点：kafka集群重启时，pod_ip发生变更，需要编写一个刷新hosts文件的脚本；脚本不大好写；虚拟机必须能够访问到k8s中的pod_ip（预生产和生产可以）；

优点：解决上述问题，并兼容原有部署方案。



- Kafka虚拟机部署

将K8S中的Kafka转移到虚拟机中进行部署，配置中直接使用虚拟机的IP地址。该地址在K8S中的pod和在虚拟机中Starrocks都能进行访问。

缺点：需要进行数据迁移；kafka监控、kafka-manager、kafka-eagle等需要重新适配；kafka集群依赖zookeeper，zookeeper可能也需要虚拟机部署；失去了K8S扩展性等方面的支持。

优点：解决上述问题。



- Starrocks新版本支持

目前已提issue给Starrocks团队，他们正在开发中raft和元数据管理的功能，期待后续版本的更新（目前版本不支持k8s部署）。



缺点：难以明确版本时间；难以评估官方初版的代码质量；v23上线后，部分数据存在虚拟机中，若进行k8s部署，则需要迁移数据。

优点：无需开发成本，k8s部署本来就是官方应支持的；部署逻辑统一，虚拟机可以回收掉；扩缩容更简单方便。



- Kafka-Client增强

flink、ydap、ydata-ingestion、druid都是使用的kafka官方SDK，但使官方从bootstrap-servers中拿到服务器的地址并请求后，但是从服务器拿回来的pod_ip的地址，全部失效后，**不会用配置的地址去重新连一遍，缺少一个看门狗机制**。

需要开发人员手动扩展其功能，并替换掉相关组件中的依赖。 



缺点：kafka的生产者消费者需要替换组件，并进行测试发版；**Raft算法中，没有明确要求客户端在断连集群所有节点后，需要去拿配置中的服务器节点进行重试，是否符合算法思想存疑**；需要较多的的开发和测试成本，安全性下降；

优点：解决上述问题。
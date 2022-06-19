

### 启动

初始化

```text
./bin/kafka-storage.sh random-uuid
```

期待结果

> OpenJDK 64-Bit Server VM warning: If the number of processors is expected to increase from one, then you should configure the number of parallel GC threads appropriately using -XX:ParallelGCThreads=N
> znYd_X83QR2U0aHfW1JVKA



格式化原先kafka的数据

```text
./bin/kafka-storage.sh format -t znYd_X83QR2U0aHfW1JVKA -c ./config/kraft/server.properties
```

期待结果

> OpenJDK 64-Bit Server VM warning: If the number of processors is expected to increase from one, then you should configure the number of parallel GC threads appropriately using -XX:ParallelGCThreads=N
> Log directory /tmp/kraft-combined-logs is already formatted. Use --ignore-formatted to ignore this directory and format the others.



启动

```text
./bin/kafka-server-start.sh ./config/kraft/server.properties
```



### 配置

原先需要在server.properties配置zk的集群如

```
zookeeper.connect=zookeeper:2181
```



现在只需要改成

```
bootstrap.servers=broker:9092
```



### 优点

1、去除了zk，系统复杂性减半，运维难度减半

2、topic和partition不在依赖于低效的zk，不会再因为topic和partition出现瓶颈





### 隐患

1、raft选举，轻量级的测试无法模拟实际出现问题的情况，可能的情况有leader宕机、follower宕机、topic负载过高、partition负载过高等，如leader宕机，网络正常的情况下，很容易把leader选举出来，但是不确定网络剧烈波动的情况下，raft选举的适应情况。

2、命令行工具不完善，kafka原先的大部分工具都是从zk获取数据，去掉zk之后，新的命令行工具需要重新适应，且这些工具的稳定性有待验证。

3、kafka的管理客户端，如kafka-manager，是从zk中获取数据的。如果使用去除zk的版本，那么kafka-manager等客户端工具，将无法使用。



### 升级过程

目前使用的kafka版本是2.8，2.8的版本之后，raft相关的功能，可能会在后几个版本中稳定下来，届时，相关的客户端工具等，也会更完善。

2.8已经有了raft版本，那么kafka对底层依赖于zk的数据结构，势必进行了修改，如果后续稳定版本的数据结构，与2.8版本没有太大变动的话，那么很有可能能够直接升级。

但是也有可能数据结构不兼容，导致不能直接升级。在新版本之间，kafka将会提供一个特殊的搭桥版本（bridge release），在这个版本中，Quorum Controller 会和老版本的基于 ZooKeeper 的 Controller 共存，而在之后的版本才会去掉旧的 Controller 模块。

2.8 版本以下升级到 3.0 以后的某一个版本，比如说 3.1，则需要借由 3.0 版本实现两次“跳跃”，也就是说先在线平滑升级到 3.0，然后再一次在线平滑升级到 3.1。从而去除zk。
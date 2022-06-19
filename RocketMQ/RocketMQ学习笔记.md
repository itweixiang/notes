### 集群架构



### NameServer

RocketMQ早期的的版本，参考了很多Kafka的设计，Kafka便依赖了Zookeeper。

在MetaQ 3.0时，RocketMQ去掉了ZK的依赖，自行开发了NameServer



为什么要有NameServer？

主要有以下的考量：

在用户层面，依赖了一个第三方的系统，增加了运维的复杂性和开发成本，也提高了系统的复杂度。

在集群层面，依赖外部组件，失去了一定的独立性。并且ZK的watcher的性能不算优秀，当Topic数量较多是，存储在ZK中的元数据将会产生瓶颈。

在系统设计上，RocketMQ的设计理念为最终一次性，不需要ZK的强一致性，所以只需要一个轻量级的元数据服务即可。



NameServer主要有两个功能，即：

Broker管理：接收Broker的注册信息，并保存作为路由的基础数据。进行心跳检测，检查Broker是否存活。

路由管理：生产者和消费者，可以通过NameServer获取整个Broker集群的信息，从而进行消息的发送和拉取。



NameServer号称是无状态节点，官方和很多资料都描述成几乎无状态的服务，但实际上还是有状态服务。有状态服务在K8S中，需要配置唯一的网络标识或者唯一的存储。Broker得知道每个NameServer节点，才能轮询注册，所以NameServer需要唯一的网络标识，符合有状态服务的特征。我们在实际的K8S部署过程中，也是把NameServer当成有状态节点进行部署的。

所以NameServer不能随便扩容，否则新增的NameServer在Broker中没有地址，Broker不会向新增的NameServer进行注册。



#### 路由注册

在Broker启动时，会轮训配置中的NameServer列表，与每个NameServer建立长连接，发送注册的请求。而在NameServer内部，也会维护一个Broker列表，用来动态存储Broker的信息。

Broker为了证明自己还活着，会每隔30秒发送一次心跳，心跳中包含BrokerId、Broker地址、Broker名称和所属集群名称。NameServer在收到心跳后，会更新Broker的心跳时间戳，记录这个Broker最新的存活时间。



#### 路由剔除

NameServer中会跑一个定时任务，每10S运行一次，查看每隔Broker最新的心跳时间是否距离当前时间超过120秒，如果超过，则会判定Broker失效，将该Broker从列表中剔除。



#### 路由发现

客户端在启动时，需要配置NameServer的集群地址。客户端会先生成一个随机数，然后与NameServer的节点进行取模，得到连接的NameServer节点，进行连接。当连接失败时，会轮训列表中的其它NameServer，尝试进行连接。即首次随机策略进行连接，失败后采用轮询策略进行连接。

当Topic发生变化时，NameServer不会主动向客户端推送信息，而是客户端定时拉取topic的最新路由信息，默认30秒拉取一次



### Broker

Broker作为数据节点，承担着消息中转的角色，负责存储从生产者发送过来的消息，并为消费者拉取消费做准备。Broker也存储着消息相关的元数据，包括消费者的topic、offset、队列等。





Remoting Module：整个Broker的实体，负责处理来自clients端的请求。

Client Manager：客户端管理器。负责接收、解析客户端(Producer/Consumer)请求，管理客户端。例如，维护Consumer的Topic订阅信息

Store Service：存储服务。提供方便简单的API接口，处理消息存储到物理硬盘和消息查询功能。

HA Service：高可用服务，提供Master Broker 和 Slave Broker之间的数据同步功能。

Index Service：索引服务。根据特定的Message key，对投递到Broker的消息进行索引服务，同时也提供根据Message Key对消息进行快速查询的功能。





### 零散



- Topic的创建

  集群模式，每个Broker存有的Topic的队列数量相同

  Broker模式，默认，每个Broker存有的Topic的队列数量可以不同


- kafka的作用

  削峰、服务解耦



- Kafka有哪几种分区策略？区别是什么？
  
  生产者有轮询和Stricky两种分区策略，消费者还有Range，共三种分区策略。
  
  轮询，遍历分区进行数据发送或者分区分配。Stricky，使用一个Murmur2的哈希算法，将分区打散，murmur的特点是高效低碰撞。Range，仅存在于消费者，通过分区数整除消费者数，得到消费者平均的分区数，再将分区数对消费者数进行取余，得到不能平均的分区数，Range会将不能平均的分区，顺序分配给消费者。
  
  
  
- 生产者的参数
  
  - ack，默认1，0 无需等leader落库 ，1 等leader落库，-1\all 等所有leader和所有副本落库
  
  - retries，发送消息重试的次数，默认不重试
  
  - buffer.memory，默认32M，生产者缓冲池的总大小
  
  - batch.size，单个分区的缓存，默认16384字节。linger.ms，发送数据的等待时间，默认0。满足其中一个即发送。
  
  - max.request.size，单次请求的最大数据大小，默认1M。如果单条消息比batch.size大，生产者会重新开辟一个比batch.size大的ProducerBatch进行存放，但不能大于max.request.size。
  
  - compression.type，默认不开启压缩，支持gzip、snappy和lz4，其中snappy需要引入依赖。综合lz4最优。
  
  - transactional.id，事务id，默认为null，当开启事务时，enable.idempotence也要设置为true
  
    

- 消费者参数
  - group.id，消费者组id
  - enable.auto.commit，是否开启自动提交，默认开启
  - auto.commit.interval.ms，自动提交的间隔，默认5s
  - max.poll.interval.ms，消费者最长的休息时间，默认300s。超过该时间消费者会向coordinator，发送一条LeaveGroup请求，触发rebalance。之后消费者需要重新发送JoinGroup请求。
  - max.poll.records，一次拉取的数据大小，默认500条。
  - fetch.min.bytes，默认1字节。fetch.max.wait.ms，默认0.5s。没有达成fetch.min.bytes条件时，则阻塞fetch.max.wait.ms的时间返回。
  - isolation.level，默认read_uncommitted。read_committed消费者只消费已提交事务的消息



- 命令行工具

  在kafka的bin目录下，以下工具比较常用。

  - kafka-server-start.sh，启动 kafka 服务
  - kafka-server-stop.sh，停止 kafka 服务
  - kafka-topics.sh，topic 管理脚本
  - kafka-console-consumer.sh，kafka 消费者控制台
  - kafka-console-producer.sh，kafka 生产者控制台
  - kafka-consumer-groups.sh，kafka 消费者组相关信息

  

- Zookeeper的作用

  - Broker 注册选举：Broker 是分布式部署并且之间相互独立，Zookeeper 用来管理注册到集群的所有 Broker 节点。**先注册到zk的broker节点成为leader，leader挂掉之后，抢先注册的follower成为leader。**

  - Topic 注册： 在 Kafka 中，同一个 Topic 的消息会被分成多个分区并将其分布在多个 Broker 上，这些分区信息及与 Broker 的对应关系也都是由 Zookeeper 在维护

  - 消费者负载均衡：Kafka的GroupCoordinator组件在Zookeeper存储了消费者的信息。高版本的Kafka，具体的Rebalance由消费者负责。

  

- Kafka节点存活的条件

  - 保持和ZK的心跳
  - 如果是follower，必须保持和leader的数据同步

  

- 活锁问题

  消费者出现故障，持续的发送心跳，但是没有向broker拉取消息。设置max.poll.interval.ms，默认300秒，超过该时间，没有拉取消息，消费者会向coordinator发送LeaveRequest请求，触发rebalance。之后消费者需要重新发送JoinGroup请求。



- 什么情况下会发生rebalance？

  消费者组成员变更，有新的消费者加入或者消费者宕机。

  消费者出现活锁，在配置时间内无法消费完消息。

  消费者组订阅的topic发生变化。订阅的topic的partition发生变化。

  

- 事务语义
  
  - 最少一次，生产者确保消息被Broker接收，若Broker异常则进行重试。ack=1。
  - 最多一次，生产者不管消息有没有被Broker接收，都只发一次，如ack=0。
  - 精准一次，最少一次+幂等，生产者确保消息被Broker接收，Broker确保消息被正确同步，ack=-1，并且根据事务Id进行幂等。局限性：生产者重启后，事务Id将重置。



- 事务实现
  - 生产者，初始化transactional.id，并且开启幂等性
  - 消费者，将isolation.level设置为read_committed，只消费已经提交的事务，并且自行记录log的消费位置，手动提交offset的偏移量。




- Kafka与其它消息系统的区别
  - 持久化日志，日志可以被重复读取和无限期保留
  - 以集群的方式运行，可以灵活伸缩，在内部通过复制数据提升容错能力和高可用性
  - 支持实时的流式处理



- 数据不丢失

  生产者发送消息失败时，进行重试。设置ack=-1，Kafka阻塞客户端请求，直到leader和所有的follower都落库后才返回。



- broker故障处理和水位线同步

  - follower故障，①leader将其踢出ISR；②待follower恢复后，将log高于水位线的部分截掉（此时follower存储的水位线不一定是leader的水位线），并向leader请求同步数据新的水位线和水位线后的数据，直到follower的LEO大于水位线，就可以重新加入ISR。
  - leader故障，①follower向zk争抢注册成新leader；②其余follower将各自log中，高于水位线的数据截掉，然后从新leader同步数据。
  - 新broker加入，①作为follower向leader拉取数据，直到LEO大于水位线，才会加入ISR；②原先负载搞得follower会删掉已经同步的数据，直到与配置的副本数相同。

  

- 数据不重复消费

  消费者自行记住消费的位置，在处理完成后再提交偏移量。功能设计时，尽可能的考虑幂等性。



- Kafka性能
  - 批处理，将多条消息组成一个ProducerBatch，一起发送到服务端，减少网络IO
  - ACK，当ACK=0时，无需阻塞等待Broker落库
  - 顺序读写，消息的读写方式偏向于顺序读写，可以充分利用磁盘的性能。
  - 零拷贝，接收数据使用mmap，发送数据使用sendfile。操作系统不支持上述函数时，使用直接内存。sendfile只支持从磁盘到网卡，不支持从网卡到磁盘，所以接收数据无法使用sendfile



- 消息在服务端查找流程？
  - 先从对应的分区中，通过二分查找，找到对应的索引文件
  - 再通过二分查找，读取index中的索引，直到找到对应offset的区间
  - 从offset的区间开始，顺序读取log中的数据，直到找到对应的消息




- Kafka的文件结构是怎样的？

  一个topic分为多个Partition，partition的日志文件，对应多个Segment，Segment是一个逻辑概念，Segment又可分为log文件、index文件和timeindex，log文件存储具体的消息，index文件存储稀疏索引。这些文件位于一个文件夹下，文件夹命名为，topic名称+分区序号。而log和index文件，以当前segment的第一条消息的offset命名。



- 异常
  - 磁盘满了，根据日志保留策略，计算磁盘大小；开启数据压缩。目前我们是32个topic，12个分区，保留4小时的日志，保留最多4个日志文件。消息比较大的Topic，目前可以保留3000W条。消息比较小的，可以保留几亿条。目前磁盘大小为1T的PL2硬盘，使用空间大约80%。
  - 运维的外网端口，没关闭，受到网络攻击；K8S的Node节点扫描到Kafka的端口，Kafka私有协议，无法识别Node的连接请求，日志报错但不重要。
  - 消费者负载不均匀，根据消费者的数量，设置分区的数量，目前12个分区，消费者数量在1、2、3、4、6时可以负载均匀，弹性较好。

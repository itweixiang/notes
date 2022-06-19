- 引入消息系统有什么缺点？

  增加系统复杂性，对运维和开发人员的技术水平有更高的要求。

  功能开发时需要考虑到消息丢失、消息重复、数据一致性等问题。

  功能依赖了消息系统，消息挂了，会导致功能不可用。

  

- 消息系统如何选型？

  RocketMQ的消息种类比较多，并且吞吐量比较大，数据安全也有保障，比较适合业务系统。在大数据方面，因为生态等问题，只能用Kafka没得选。

  

- 有哪些常见的消息系统？有什么区别？

  目前比较常用的就是Kafka和RocketMQ了

  - Kafka在topic和partition比较少的情况下，性能优于RocketMQ，在topic和partition比较多时，RocketMQ的表现更为均衡。二者都支持10W以上的吞吐量。
  - Kafka和RocketMQ都支持集群部署，Kafka当前版本使用ZK进行元数据管理，未来将使用raft算法去除ZK依赖，RocketMQ早期版本也依赖于ZK，后续自己开发了NameServer用于元数据惯例。二者可用性都比较高。
  - Kafka使用Scala进行开发，二次开发成本稍微高一点。RocketMQ使用Java进行开发，对大多数Java程序员更友好。
  - RocketMQ支持的消息种类比较多，功能更丰富，比较适合业务系统。Kafka则比较适合大数据开发、日志采集等。

  

- RocketMQ支持哪些消息？

  同步消息、异步消息、单向消息、事务消息、延时消息

  

- 延时消息需要延时3小时怎么办？

  生产者在发送消息时，给消息设置一个delayTimeLevel，delayTimeLevel有18个级别，间隔从1秒到2小时

  

- push和pull有什么优缺点？

  push实时性比较好，服务端有消息时即可推送，但服务端无法知道消费者的消费能力，无法根据消费者的能力进行push

  pull实时性比较差，但是可以根据自身的消费能力去拉取消息

  

- RocketMQ消费消息是Push还是Pull？

  RocketMQ有Push类，但实际上还是长轮训的Pull模式

  

- 如何跟踪消息的轨迹？

  服务端需要启用traceTopicEnable的配置，生产者则在创建实例时也需要在构造器中开启消息轨迹

  

- RocketMQ有哪些角色？

  - NameServer，管理节点，作为注册中心，官方和很多资料都描述成无状态的的，但实际上是有状态服务。有状态服务在K8S中，需要配置唯一的网络标识或者唯一的存储。Broker得知道每个NameServer节点，才能轮询注册，所以NameServer需要唯一的网络标识，符合有状态服务的特征。
  - Broker，数据节点，收发、存储消息。
  - Producer，生产者，负责将消息发送到Broker。
  - Consumer，消费者，从Broker拉取消息，并进行消费。

  

- 为什么要开发NameServer

  早期版本的RocketMQ（MetaQ）依赖的是ZK，ZK的watcher性能不足， 在topic和分区数量过多时，会出现瓶颈。

  RocketMQ的设计理念为最终一次性，不需要ZK的强一致性，所以只需要一个轻量级的元数据服务即可。

  

- NameServer如何保证CAP？

  - 一致性，NameServer节点彼此互不通信，依靠Broker上报的数据，维护元数据。所以，不同NameServer实例，存储的元数据，可能会出现不一致，客户端获取的数据也可能出现不一致。

  - 可用性，只要不是所有NameServer节点都挂掉，有个节点可以正常响应客户端即可

    todo

  - 分区容错性，

  

- RocketMQ存储的消息被消费后会立即删除吗？

  不会，其他消费者组可能还会重复消费，所以也不能删除。在4.6版本，会默认存48小时，然后在凌晨4点删除过时数据。

  

- 消息堆积如何处理？超时会删除吗？

  超出了保留时间、磁盘满了随机删除10个，满足两种情况时，堆积的消息可能会被删除

  

- 堆积消息会不会进死信队列？

  不会，消息消费18次失败后才会进入死信队列

  

- RocketMQ如何保证消息的顺序性？

  生产者将消息顺序发送到同一个Queue上，消费者单线程对消息进行消费。

  

- 如何将消息发送到同一个队列上？

  生产者实现MessageQueueSelector接口，选择一个queue进行发送。

  

- RocketMQ如何保证消息不重复？

  所有的消息队列的消息重复问题，都需要生产者自行记住消费的偏移量，在处理完成后再提交offset。功能设计时，尽可能的考虑幂等性。

  

- RocketMQ如何保证消息不丢失？

  - 生产者，做好发送失败时的重试，使用同步阻塞的方式发送消息。使用异步发送消息时，重写回调方法，检查发送结果。
  - broker，开启同步刷盘，集群模式下开启同步复制，等待复制完成再返回ACK。
  
  
  
- 读写队列是怎么回事？

  一般在读写队列动态扩缩容时才会使用。扩容时，先扩写队列，此时消费者还不能读取写队列的数据，等写队列有数据后，扩容成功，再扩读队列供消费者消费。缩容时，先缩写队列，等消费者把写队列的数据消费完，再缩读队列，避免写队列的数据丢失。

  

- 消费者和Queue不对等，扩容消费者后任然堆积，短时间内无法处理怎么办？

  直接在控制台上扩容Queue，先扩写队列，再扩读队列。或者新建一个临时topic，queue是原来堆积topic的几倍。启动若干个生产者，将堆积topic的数据，转发到临时topic中，不做业务处理。原消费再消费临时topic。

  

- RocketMQ如何实现事务？

  生产者需要自行实现事务监听器，通过监听器的executeLocalTransation方法，执行本地事务。在发送消息时，通过事务消息的方法进行发送。生产者会向broker查询事务消息，成功接收后，会执行checkLocalTransation的方法，此时便可以对本地事务进行提交。

  

- 高吞吐量下如何优化生产者和消费者的性能？

  网络IO多了，性能肯定上不来，要求高吞吐量时，需要舍弃一部分数据的可靠性。生产可以批量向broker发消息，消费者可以使用多线程消费消息。

  

- RocketMQ消费模型有几种？

  集群消费，一条消息只会被同一个group中的一个消费者消费。多个Group同时消费一个Topic时，每个Group都会有一个消费者消费到数据。

  广播消费，每个消费者都重复消费相同的消息。

  

- Broker如何进行负载均衡？

  客户端读写数据时，broker都是操作的队列，所以可以队列的数量，分散到更多的broker上。

  

- 生产者如何进行负载均衡？

  生产者发送消息时，默认随机选择broker进行发送，发送失败时，则变为轮训。也可以通过实现Hash的Selector，进行负载。也可以实现自定义的Selector。

  

- 消费者如何进行负载均衡？

  消费者默认是平均分配，也有环形分配、机房分配等

  

- Broker宕机时，NameServer是如何感知的？

  NameServer通过Broker的心跳进行感知，Broker会定时30秒向NameServer发送心跳，NameServer定时10秒检查每个Broker的状态，若报心跳时间超过120秒，则认为Broker宕机。

  

- 如何知道有哪些Broker？如何知道要连哪个Broker？

  Broker会想NameServer进行注册，客户端通过NameServer，可以获取对应的Broker路由信息

  

- 一台Broker宕机该怎么办？Slave宕机和Master宕机有什么区别？

  如果是Master宕机，在4.5以前，需要手动进行主从切换，此时会有一段时间的不可用。4.5以后，通过Dledger机制，在多个Slave中选举出新的Master，继续对外提供服务。

  Slave宕机有一点影响，写数据都是通过Master写，Slave仅可以负担一部分数据的读取，Slave宕机会增大Master的读取压力。

  

- Master Broker如何将消息同步给Slave Broker?

  Slave会启动一个定时任务，10秒轮训一次，向Master拉取数据topic信息、消费者offset和订阅组信息等。再通过一个HA组件，不停的向Master拉取数据，然后添加到自身的commitLog中。

  

- 消费消息是从Master拉取还是从Slave拉取？

  都有可能。消费者在获取消息的时候会先发送请求到Master上，请求获取一批消息，此时Master会返回一批消息给消费者。Master在返回消息给消费者的时候，会根据当时Master的 负载情况和Slave的同步情况，向消费者系统建议下一次拉取消息的时候是从Master拉取还是从Slav拉取。

  

- RocketMQ如何进行权限控制？

  修改服务端的acl文件，配置accessKey、secretKey、权限级别、IP限制、所属topic等

  

- RocketMQ有哪些控制台工具？

  在服务端的bin目录下，有个mqadmin的工具，也可以使用官方的网页管理工具





面试题，https://cloud.tencent.com/developer/article/1973687

RocketMQ主从同步，https://www.cnblogs.com/yougewe/p/14198675.html
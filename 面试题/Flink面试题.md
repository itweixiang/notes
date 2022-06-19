- 什么是元组？

  就是字段的占位符，一共26个。

  

- flink有哪些常用的算子？

  source算子

  - fromCollection从集合类中读取数据
  - readTextFile从文件中读取数据
  - kafka消费者算子，从kafka中消费数据

  transfrom算子

  - map，元素一比一转换
  - flatmap，元素一比多转换
  - filter，元素过滤
  - reduce，对元素进行聚合计算
  - distinct，对元素进行去重

  sink算子

  - collect，将数据输出到本地集合
  - writeAsText，将数据输出到本地文件
  - kafka生产者算子，将数据写入到kafka中

  

- 算子状态和键控状态有什么区别？

  作用范围不一样，算子状态保存的数据，流中所有的元素都能进行访问。监控状态保存的数据，只能由对应的key访问

  

- on k8s session和application的区别？

  

- flink有哪几种时间语义？

  由三种时间语义，EventTime事件时间，由数据携带的时间戳决定。IngestionTime摄取时间，数据进入Flink的时间。ProccessingTime，系统时间，Linux当前时间戳。

  

- flink如何提交kafka的偏移量？

  - 默认禁用checkpoint，依赖kafka消费者内部的commit interval进行处理，默认5s提交一次偏移量
  - 启用checkpoint，会将kafka分区的偏移量存储到检查点中，由flink根据checkpoint的数据提交offset




- checkpoint未持久化但发生宕机怎么办？

  checkpoint默认存储在job-manager的内存中，也可以使用rocksdb和file system进行存储。若发生宕机等，则可能会发生丢失。丢失时，从上一个checkpoint开始恢复，从上个checkpoint存储的offset消费者开始恢复，重新计算一遍数据。



- checkpoint 和 savepoint的区别？
  - Checkpoint自动容错，自动触发。Savepoint程序全局状态镜像，由用户控制
  - Checkpoint常用于自动容错。Savepoint常用于程序升级手动保存数据等
  - Checkpoint默认程序停掉后删除。Savepoint默认会一直保存。
  - savepoint底层其实也是checkpoint



- checkpoint 具体实现流程？

  - 达到checkpoint的时间时，source stream会发送barrier到数据流中，对数据流进行分段，一个分段对应一个快照，每个barrier都会携带一个快照Id
  - 当算子接收到barrier时，会生成该算子的状态快照，然后向下游的所有算子进行广播。
  - 当所有算子都接收并处理barrier时，该快照生成结束
  - 如果是精准一次语义，上游算子有多个线程，则会进行barrier对齐，阻塞已经受到barrier算子的流，直到接收到所有上游的barrier。

  

- checkpoint的语义如何实现精准一次的语义？

  checkpoint的默认语义是精准一次，通过barrier对齐进行精准一次，但是会造成生成checkpoint的时间比较长，降低吞吐量。



- 什么是Chandy Lamport 算法？

  一个分布式快照算法，让多个分布式的节点一起完成快照保存。核心思想是，节点之间，。flink则通过在source时，在业务流添加一个barrier，以替代节点之间的maker信号，结构上更统一。



- 侧输出流有什么作用？

  将数据流进行分割，用以实现不同的处理逻辑，如未迟到的数据可以通过主流进行处理，少量的迟到数据通过测输出流直接落库等。



- flink有哪些处理函数？
  - ProcessFunction，最基本的处理函数
  - KeyedProcessFunction，keyedby后才能使用的函数，可以使用定时器
  - 



- flink有哪几种状态后端，优缺点是什么？

  内存状态后端，重启会丢数据，一般用来本地开发。

  文件系统状态后端，在运行时，数据还是存储在磁盘上的，不过可以定时保存到文件系统上，适合大状态、长窗口的场景。目前可以支持HDFS、阿里云和亚马逊的OSS存储。

  RocksDB状态后端，内嵌了一个数据库进行数据存储，会争抢CPU和内存资源，导致吞吐量降低，比较适合超大状态、超常窗口的场景。



- flink 如何处理反压，相比 Spark Streaming 提供的反压机制，描述其实现有什么不同？

  反压简单理解就是下游消费者，消费的速度跟不上上游的生产者了。flink通过调用Thread类获取线程当前的堆栈信息，在50毫秒内，触发100次堆栈跟踪，计算有多少堆栈卡住的比例。OK时，(0,10%]，LOW为(10%,50%]，HIGH为50%以上，也可以在jobmanager页面中看到。

  出现反压时，除了业务代码上进行排查外。flink在写满缓存区时，会拒接接收新的数据，以处理反压。而Spark可以通过设置每秒接收的最大条数，处理反压。

  

- flink如何处理数据倾斜？

  一般是keyby时，较多相同的key导致的某个算子压力较大。可以通过给key加上一些随机值、加盐，来将数据打散。

  

- 如何优化大状态的 Flink 作业？

  大状态的flink，网络传输和序列化成本较高，需要适当增大checkpoint的间隔。使用RocksDB作为状态后端。



- 哪种 join 可以满足单个流断流的时候仍然能够保证正确的 join 到数据？

  广播流，

  

- watermark是怎么生成和传递的？

  watermark用来处理乱序数据，过滤网络抖动或者一些其他原因而迟到的脏数据。

  

- 异常





https://zhuanlan.zhihu.com/p/341289391

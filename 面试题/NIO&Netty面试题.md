- BIO、NIO、AIO有什么区别？

  BIO为Blocking IO，一条连接需要启动一个线程进行处理

  NIO为Not Blocking IO，同步非阻塞IO，将网络连接虚拟化成Channel，通过Selector获取对应状态的Channel进行操作

  AIO为Async Not Blocking IO，异步非阻塞IO，为NIO的2.0版本，在NIO的基础上增加了异步回调的功能

  

- socket、selector、channel、buffer的关系是怎样的？

  - socket，网络层TCP和UDP连接的对象
  - channel，网络
  - selector，多路复用器
  - buffer，



- buffer的flip()、rewind()方法的作用是什么？

  flip将缓冲区的position指针指向数据的第一位，limit指针指向数据的最后一位

  rewind将缓冲区的position指针指向数据的第一位

  

- channel的操作有哪些？

  可读、可写、连接、接收。

  channel并不是可以支持所有的操作，例如客户端的SocketChannel就不支持Accept。

  

- NIO有哪些注意事项？

  // todo 

  

- NIO的空轮询怎么处理？

  JDK1.5引入了epoll来优化NIO，epoll机制将事件处理交给了操作系统内核，优化了select和poll文件描述符无效遍历的问题。但是在Java的实现存在bug，即使客户端无数据新数据处理时，多路复用器的select()方法仍有可能被唤醒，如果外层存在while true，则会导致不断空转，CPU使用率100%。

  Netty用一个变量记录空转的次数，如果达到512，则重构多路复用器。

  

- NIO和Netty有什么区别？

  原生的NIO，解决了网络层的通信问题，但是API过于低效和难用，需要自己构建协议，甚至select方法还有bug。

  Netty基于NIO开发，API比较容易上手，有HTTP等基础协议的支持，重新开发了FastThreadLocal，解决了select的bug。

  

- Netty架构是怎样的？

  

- Netty服务端启动流程是怎样的？

  

- EventLoop和EventLoopGroup的区别是什么？

  EventLoop是单线程的执行器，在run方法中处理channel中的事件。

  EventLoopGroup是一组EventLoop，channel调用EventLoopGroup的register()方法，与一个EventLoop进行绑定，后续该channel的操作有绑定的EventLoop进行处理。

  

- Boss Group、Worker Group、Default Group有什么区别？

  都是EventLoopGroup实例。

  Boss只处理ServerSocketChannel上的Accept事件，Worker处理SocketChannel的读写事件。

  Default Group不处理IO事件，只处理普通的业务逻辑。

  

- Boss Group如何实现多线程效果？

  如果只监听一个端口，那么服务端的ServerSocketChannel只会与Boss Group中的一个EventLoop进行绑定，无法实现多线程效果，但是boss只处理Accept，不大会产生性能瓶颈。

  Boss Group的多线程，适用于服务端监听多个端口的情况。

  

- PipeLine不同处理过程如何实现EventLoop的切换？

  Netty源码中，会判断下一个处理的线程和当前线程是否是同一个，如果是同一个，则直接执行。如果不是，则传递给下一个EventLoop。

  

- Netty如何实现监听多个端口？

  

- 如何获取ChannelFuture中的执行结果？

  使用sync()方法，进行同步。添加一个监听器，监听回调结果。

  

- Netty如何优雅关闭？

  调用EventLoopGroup的优雅关闭方法。

  如果是整个程序的关闭，需要使用Runtime中优雅关闭的钩子方法，在其中关闭相关资源。

  

- Netty默认缓存区多大？

  // todo 

  IO缓冲区一般都是1024、2048、4096、8192字节这四个值，如HttpUrlConnection默认缓冲区就是8192字节。Netty默认缓冲器大小初始化时为1024字节，。根据我自己的一些测试结果，在网络比较良好的情况下，调大缓冲区的值不会有明显的提升，反而增加了内存占用。

  

- Netty如何进行调优？

  - boss group和worker group分开，避免阻塞accept事件
  - 使用default group处理具体的业务操作，不占用worker group的线程资源，避免io阻塞

  

- Netty有那些异步操作？

  

- IO多路复用如何支持海量连接？

  在操作系统层面，使用epoll函数，减少用户空间和内核空间的数据拷贝，减少网络连接的文件描述符遍历次数。

  在Java层面，使用NIO或者Netty减少网络连接的对应的线程数，减少操作系统的资源开销

  

- 如何正确的关闭Socket？

  // todo 

  

- 为什么图片、视频、音乐、文件等 都是要字节流来读取？

  怎么存的就怎么读，用字节流来存储就用字节流读



-  select()、poll、epoll()方法有什么区别？

  // todo 



https://blog.csdn.net/qq_19801061/article/details/117934114

BIO、NIO、AIO：https://developer.aliyun.com/article/726698#slide-10
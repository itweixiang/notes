### 架构模型

Netty中有两组线程池，分别为BossGroup和WorkGroup。BossGroup负责接收客户端的连接，WorkGroup负责网络的读写。

BossGroup和WorkGroup类型都是NioEventLoopGroup，表示一个事件循环组NioEventLoop，组中有多个事件循环

- BossGroup维护的Selector只负责处理Accept事件，当接受到Accept事件时，则获取对应的SocketChannel，将其封装为NioSocketChannel，并注册到WorkGroup中的Selector中。
  - 轮训accept事件
  - 与client建立连接，生成NioSocketChannel，将其注册到WorkGroup中的NioEventLoop的Selector上
  - 处理任务队列的任务，
- Work线程监听到Selector中通道的事件时，则由Handler进行处理
  - 轮训read\write事件
  - 在NioSocketChannel中，读取read\write事件，并处理
  - 处理任务队列的任务，
- NioEventLoop表示一个不断循环，处理任务的线程。每个loop都有一个Selector，用以监听其绑定的Socket的网络事件。
- 每个WorkGroup的NioEventLoop，在处理业务时，会使用到Pipeline。Pipeline中包含了Channel，也维护了很多的处理器。



### 常用的处理器


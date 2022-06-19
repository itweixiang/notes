## Environment



### getExecutionEnvironment

创建一个执行环境,表示当前执行程序的上下文。如果程序是独立调用的,则此方法返回本地执行环境;如果从命令行客户端调用程序以提交到集群,则此方法返回此集群的执行环境,也就是说, **getexecutionEnvironment会根据查询运行的方式决定返回什么样的运行环境**,是最常用的一种创建执行环境的方式。



批处理环境

```
ExecutionEnvironment env = ExecutionEnvironment.getExecutionEnvironment();
```



流处理环境

```
StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
```



### 本地环境

返回本地执行环境

```
LocalStreamEnvironment env = StreamExecutionEnvironment.createLocalEnvironment();
```



### 远程环境

连接服务器上的fink，需要指定ip端口，和对应jar文件的路径。

```
StreamExecutionEnvironment env = StreamExecutionEnvironment.createRemoteEnvironment("ip", port, "jarFiles");
```



## Source



### 集合数据



### 文件数据



### kafka数据



### 自定义Source






查看和部分修改jvm的参数



### 查看当前进程的虚拟机信息

```
jinfo pid
```



### 查看当前虚拟机的启动参数，命令行和main参数等

```
jinfo -flags pid
```



### 查看或重置某个参数

```
jinfo -flag param pid
```

####查看

```
jinfo -flag UseParallelGc 12828
```



#### 重置

```
jinfo -flag HeapDumpPath=/tmp/cores/
```

  

### 查看所有JVM参数启动的初始值

```
java -XX:+PrintFlagsInitial
```



### 查看所有JVM参数启动的最终值

```
java -XX:+PrintFlagsFinal -version
```



### 查看已经重置的参数

```
java -XX:+PrintCommandLineFlags
```


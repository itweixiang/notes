多功能工具，实现除了jstat之外的所有命令的功能



### 列出所有的java进程，类似于jps -l

```
jcmd -l
```



###  查看支持的所有命令

```
jcmd pid help
```



### 具体的命令

```
jcmd pid 具体命令
```

如：`jcmd 121247 Thread.print`


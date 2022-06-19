导出内存镜像文件和内存使用情况



### 导出内存镜像

- 存活对象

```
jmap -dump:live,format=b,file=filename.hprof pid
```



- 所有对象

```
jmap -dump:format=b,file=filename.hprof pid
```



live，表示存活的对象，format表示生成的文件与扩展名适配



### 查看堆信息

- 显示堆内存的配置，即已使用的信息

```
jmap -heap pid
```



- 显示堆中的对象信息

```
jmap -histo pid
```






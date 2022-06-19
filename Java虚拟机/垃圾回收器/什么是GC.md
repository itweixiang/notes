GC：

垃圾回收器Garbage Collector

垃圾回收名词Garbage Collection

垃圾回收动作（Do）Garbage Collection

一般指垃圾回收器。



### 回收区域

- 年轻代\新生代

Young GC = Minnor



- 老年代

Old GC = Major GC + Full GC（不包括方法区的情况下）



### 线程数量

Full GC

一般是一个单线程、STW的垃圾回收器，**约**等于Serial GC。但在-XX:UseParallelXxxGC的情况下，会开启并行化，相当于Parallel GC。



多线程 GC 

ParNew、Parallel、CMS、G1



### STW

全局暂停：

Serial Parallel ParNew



局部暂停：

CMS G1 
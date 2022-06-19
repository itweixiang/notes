

### 标准参数



标准参数以`-`开头，比较稳定，后续版本基本不会变化。



在控制台输入`java -help`，可以看到所有的标准参数

```
-d32	  使用 32 位数据模型 (如果可用)
-d64	  使用 64 位数据模型 (如果可用)
-server	  选择 "server" VM
              默认 VM 是 server.

-cp <目录和 zip/jar 文件的类搜索路径>
-classpath <目录和 zip/jar 文件的类搜索路径>
              用 ; 分隔的目录, JAR 档案
              和 ZIP 档案列表, 用于搜索类文件。
-D<名称>=<值>
              设置系统属性
-verbose:[class|gc|jni]
              启用详细输出
-version      输出产品版本并退出
-version:<值>
              警告: 此功能已过时, 将在
              未来发行版中删除。
              需要指定的版本才能运行
-showversion  输出产品版本并继续
-jre-restrict-search | -no-jre-restrict-search
              警告: 此功能已过时, 将在
              未来发行版中删除。
              在版本搜索中包括/排除用户专用 JRE
-? -help      输出此帮助消息
-X            输出非标准选项的帮助
-ea[:<packagename>...|:<classname>]
-enableassertions[:<packagename>...|:<classname>]
              按指定的粒度启用断言
-da[:<packagename>...|:<classname>]
-disableassertions[:<packagename>...|:<classname>]
              禁用具有指定粒度的断言
-esa | -enablesystemassertions
              启用系统断言
-dsa | -disablesystemassertions
              禁用系统断言
-agentlib:<libname>[=<选项>]
              加载本机代理库 <libname>, 例如 -agentlib:hprof
              另请参阅 -agentlib:jdwp=help 和 -agentlib:hprof=help
-agentpath:<pathname>[=<选项>]
              按完整路径名加载本机代理库
-javaagent:<jarpath>[=<选项>]
              加载 Java 编程语言代理, 请参阅 java.lang.instrument
-splash:<imagepath>
              使用指定的图像显示启动屏幕
```



### -X参数



非标准化参数，功能比较稳定，后续版本可能会变更，以`-X`开头



在控制台输入`java -X`，可以看到相关参数

```
-Xmixed           混合模式执行（默认）
-Xint             仅解释模式执行
-Xbootclasspath:<用 ; 分隔的目录和 zip/jar 文件>
                  设置引导类和资源的搜索路径
-Xbootclasspath/a:<用 ; 分隔的目录和 zip/jar 文件>
                  附加在引导类路径末尾
-Xbootclasspath/p:<用 ; 分隔的目录和 zip/jar 文件>
                  置于引导类路径之前
-Xdiag            显示附加诊断消息
-Xnoclassgc        禁用类垃圾收集
-Xincgc           启用增量垃圾收集
-Xloggc:<file>    将 GC 状态记录在文件中（带时间戳）
-Xbatch           禁用后台编译
-Xms<size>        设置初始 Java 堆大小
-Xmx<size>        设置最大 Java 堆大小
-Xss<size>        设置 Java 线程堆栈大小
-Xprof            输出 cpu 分析数据
-Xfuture          启用最严格的检查，预计会成为将来的默认值
-Xrs              减少 Java/VM 对操作系统信号的使用（请参阅文档）
-Xcheck:jni       对 JNI 函数执行其他检查
-Xshare:off       不尝试使用共享类数据
-Xshare:auto      在可能的情况下使用共享类数据（默认）
-Xshare:on        要求使用共享类数据，否则将失败。
-XshowSettings    显示所有设置并继续
-XshowSettings:system
                  （仅限 Linux）显示系统或容器
                  配置并继续
-XshowSettings:all
                  显示所有设置并继续
-XshowSettings:vm 显示所有与 vm 相关的设置并继续
-XshowSettings:properties
                  显示所有属性设置并继续
-XshowSettings:locale
                  显示所有与区域设置相关的设置并继续
```



- -Xinit：禁用JIT，所有的字节码都被解释执行，速度最慢

- -Xcomp，所有的字节码第一次就被编译，然后再执行
- -Xmixed，混合模式，默认，让JIT根据程序运行情况，动态编译

- -Xms<size>，初始化java堆的大小，相当于-XX:InitialHeapSize，如-Xms2g
- -Xmx<size>，设置最大java堆大小，相当于-XX:MaxHeapSize
- -Xss<size>，设置java线程栈的大小，相当于-XX:ThreadStackSize，默认1M



### -XX参数 



使用最多的参数类型，比较不稳定，以`-XX`开头



-XX参数分为Boolean类型和非Boolean类型



#### Boolean类型

-XX:+<option>，表示开启option

-XX:-<option>，表示关闭option，有些参数是默认开启的，可以通过`-`进行关闭



如，-XX:+UseParallelGC，-XX:+UseAdaptiveSizePolicy



#### 非Boolean



非Boolean，分为数值类型和非数值类型，如果是数值类型，就进行赋值

-XX:<option>=<number>

如，-XX:NewRatio=2，-XX:NewSize=2M



如果是非数值类型，则填写对应的值

-XX:<option>=<string>

如，-XX:HeapDumpPath=/xxx/xxx/duml.hprof



#### PrintFlagsFinal

-XX:+PrintFlagsFinal，输出所有参数的名称和默认值，默认不包括诊断和实验的参数



### 常用参数
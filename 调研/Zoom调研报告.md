### 数据来源

1、招聘介绍，组件内容较多，但无法推断具体的架构

2、官网文档，几乎没有

3、峰会PPT，几乎没有

4、内部人员交流，无



### 组件架构



招聘介绍：HDFS、Spark、Flink、HBase、Presto、Impala、Kafka



> 资深大数据开发工程师：
>
> 2、负责**基于Hadoop、Spark等大数据集群的实时、离线数仓**，及数据服务的设计和开发
>
> 3、负责数据基础架构和数据处理体系（**实时和离线**）的升级和优化





### 分析

1、从zoom资深大数据开发工程师的岗位要求分析，zoom的实际情况是，**实时数仓和离线数仓并存**。

2、在zoom所有大数据相关的岗位中，没有Druid、ClickHouse等实时数仓的要求，很大可能，**zoom大数据平台任然以离线数仓（Hadoop）为主**。

3、zoom的大数据岗位招聘不是很活跃，**在大数据数仓建设方面，可能存在不足**。官网和相关峰会，也没有相关的大数据资料，也可以进行一部分印证。

4、在功能上，可以参考声网和zoom，在架构上，参考一线互联网大厂的数仓建设



HBase、Hive、Impala，都是基于Hadoop的数仓软件

| HBase                                                        |                             Hive                             |                       Impala                       |
| ------------------------------------------------------------ | :----------------------------------------------------------: | :------------------------------------------------: |
| HBase是基于Apache Hadoop的宽列存储数据库。 它使用BigTable的概念。 | Hive是一个数据仓库软件。 使用它，我们可以访问和管理基于Hadoop的大型分布式数据集。 | Impala是一个管理，分析存储在Hadoop上的数据的工具。 |
| HBase的数据模型是宽列存储。                                  |                      Hive遵循关系模型。                      |                Impala遵循关系模型。                |
| HBase是使用Java语言开发的。                                  |                  Hive是使用Java语言开发的。                  |              Impala是使用C ++开发的。              |
| HBase的数据模型是无模式的。                                  |                 Hive的数据模型是基于模式的。                 |           Impala的数据模型是基于模式的。           |
| HBase提供Java，RESTful和Thrift API。                         |               Hive提供JDBC，ODBC，Thrift API。               |             Impala提供JDBC和ODBC API。             |
| 支持C，C＃，C ++，Groovy，Java PHP，Python和Scala等编程语言。 |           支持C ++，Java，PHP和Python等编程语言。            |       Impala支持所有支持JDBC / ODBC的语言。        |
| HBase提供对触发器的支持。                                    |                  Hive不提供任何触发器支持。                  |          Impala不提供对触发器的任何支持。          |


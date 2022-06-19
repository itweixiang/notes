- be节点的内存划分以及作用

  从mem_tracker进行查看

  - load：摄取
  - compaction：压缩
  - query_pool：查询
  - page_cache：操作系统页缓存
  - tablet_meta：表的元数据
  - schema_change、column_pool、clone、chunk_allocator、consistency、update：未知



- compaction参数之间的关系

```
max_compaction_concurrency
compaction_max_memory_limit_percent
cumulative_compaction_num_threads_per_disk
base_compaction_num_threads_per_disk
```



- be日志大量报错，为版本丢失，但服务器较为稳定，不应该大范围出现版本丢失

``` 
W0221 15:12:37.846484  1143 storage_engine.cpp:641] failed to init vectorized base compaction. res=Internal error: cumulative compaction miss version error., table=79426.1390633327.c440d15e10b83160-0ae7290b0e528b8c
```



- base compaction和cumulative compaction的区别



- tablet_meta没有内存限制参数，内存会持续上涨，并且未见回收



- 导入任务state=RUNNING，但日志打印`too many tablet version`

摄取任务一直处于RUNNING状态，导致没有发现摄取任务的异常。而是通过kafka的消息堆积发现的。如果不能正常摄取消息，应该PAUSED掉。

文档中的恢复说明，无法进行恢复。

```
ADMIN REPAIR TABLE table_xxx;
ADMIN REPAIR TABLE table_xxx PARTITION (partition_xxx);
```



最终经过繁琐的重建才将其恢复：

1、建立temp表

2、insert into temp select * from table_xxx

3、drop table_xxx

4、create table_xxx

5、insert into table_xxx select * from temp 



- `SHOW TABLET FROM table_xxx partition(xxx)`中的Version字段是否为tablet version的数量



- 磁盘存储的文件和分区、分桶、元数据的对应关系
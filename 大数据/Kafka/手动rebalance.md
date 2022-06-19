## 扩容分区

需要先将分区扩容，然后执行rebalance

```bash
./kafka-topics.sh --bootstrap-server ${HOSTNAME}:9092 --alter --topic media_quality  --partitions 12
```





## 确定rebalance的topic

编写一个文件，文件名自己指定，json格式

```json
{
    "topics": [
        {
            "topic": "media_quality"
        }
    ],
    "version": 1
}
```





## rebalance执行

```bash
#!/bin/bash
bootstrapServer="${HOSTNAME}:9092"
brokerIdList=0,1,2

echo "bootstrapServer:"  $bootstrapServer
echo "brokerList:" $brokerIdList
echo "###########################start generate reblance conf##############################"
content=`bash kafka-reassign-partitions.sh --bootstrap-server $bootstrapServer --topics-to-move-json-file topicmove.conf  --broker-list $brokerIdList --generate`
content=`echo $content | awk -F 'Proposed partition reassignment configuration' '{print $2}'`
echo $content
echo $content > ressgintopic.conf
echo $content >> ./log/reblance.log
echo "" >> ./log/reblance.log
echo "###########################end generate reblance conf##############################"

#start reblance
echo "###########################start reblance##############################"
bash kafka-reassign-partitions.sh --bootstrap-server $bootstrapServer --reassignment-json-file ressgintopic.conf --execute
```



##  Rebalance进度查询

```bash
#!/bin/bash
bootstrapServer="${HOSTNAME}:9092"
bash kafka-reassign-partitions.sh --bootstrap-server $bootstrapServer --reassignment-json-file ressgintopic.conf --verify
```


# HDFS 操作指南

```bash
hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -chmod 777 /user/hive/warehouse

# 测试数据
hdfs dfs -put ./data/input /user/hive/warehouse
hdfs dfs -ls /user/hive/warehouse

# 查看文件目录
hdfs getconf -confKey dfs.datanode.data.dir
hdfs getconf -confKey dfs.namenode.name.dir
```

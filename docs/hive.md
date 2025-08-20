# Hive 操作指南

## 进入 Docker 容器

```bash
docker exec -it <container_name> /bin/bash
```

> 将 `<container_name>` 替换为你的 Hive 容器名称。

---

## 使用 Beeline 连接 Hive

```bash
beeline -u "jdbc:hive2://<hive-server-host>:10000" -n <username> -p <password>
```

- **`<hive-server-host>`**：HiveServer2 主机地址
- **`<username>`**：用户名
- **`<password>`**：密码

---

## 常用 Beeline 命令

- **给管理员权限：**

    ``` sql
    set role admin;
    ```

- **查看数据库：**

    ``` sql
    show databases;
    ```

- **使用数据库：**

    ``` sql
    use <database_name>;
    ```

- **查看表：**

    ``` sql
    show tables;
    ```

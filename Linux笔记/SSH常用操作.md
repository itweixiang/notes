### 创建本机公钥和密钥

```shell
# 一直回车就行，默认创建在~/.ssh目录下
ssh-keygen
```

### 将公钥拷贝到其他服务器上，实现免密登录
```shell
ssh-copy-id user@ip
```


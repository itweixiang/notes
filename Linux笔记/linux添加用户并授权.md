
### 添加用户
```shell
useradd ceph
```

### 设置用户密码
```shell
passwd ceph
```

### 设置sudo权限
```shell
visudo
# 将该配置粘贴进去，或者ceph ALL=(root) ALL
ceph ALL=(root) NOPASSWD:ALL
```
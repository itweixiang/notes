### 常用命令

- 创建账号

  ```sh
  rabbitmqctl add_user username password
  ```

  

- 设置角色

  ```sh
  rabbtmqctl set_user_tags username administrator
  ```

  

- 设置用户权限

  username后依次为conf、write、read

  ```
  rabbtmqctl set_permissions -p "/path" username ".*" ".*" ".*"
  ```

  

- 查看用户

  ```
  rabbtmqctl list_users
  ```

  

  
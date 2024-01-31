# 安装
```
bundle install
```

# 开启数据库

```
docker ps -a // 查找上次容器
docker restart [容器id]
```
若是第一次开启数据库，请运行以下命令

```
  docker network create network1

  docker run -d --name db-for-tomato -e POSTGRES_USER=tomato -e POSTGRES_PASSWORD=123456 -e POSTGRES_DB=tomato_dev -e PGDATA=/var/lib/postgresql/data/pgdata -v tomato-data:/var/lib/postgresql/data --network=network1 postgres:14
```

# 创建数据库

`bin/rails db:create`

# 删除数据库

`bin/rails db:drop`

# 运行 server

`bin/rails s`

# docker 常用命令

```
docker ps -a // 查看所有容器
docker kill [container id] // 关闭[container id]容器
docker restart [container id] //重启[container id]容器
docker rm [container id] //删除[container id]容器
docker container prune //删除无用容器
```
# 测试

`bin/rspec`

# 创建API文档

`bin/rake docs:generate`

`./spec/acceptance`和`./spec/requests`
作用：两个目录下的文件均用来测试controller
差异：`acceptance`只测试成功的（成功才可创建文档），`requests`可测试失败的

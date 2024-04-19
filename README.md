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

`bundle exec rspec`，后面还可指定需要测试的路径，如`bundle exec rspec spec/requests/api/v1`

`bin/rspec` 和 `bundle exec rspec` 都是用于运行 RSpec 测试的命令，但它们的运行环境有所不同。

1. `bin/rspec`: 这个命令会运行在你的项目的 bin 目录下的 rspec 脚本。这个脚本通常是在你安装 RSpec 的时候自动生成的，它会在你项目的环境中运行 RSpec。这意味着，如果你的项目使用了 Bundler 来管理 gem，并且你在 Gemfile 中指定了 RSpec 的版本，那么 bin/rspec 将会运行你在 Gemfile 中指定的那个版本的 RSpec。

2. `bundle exec rspec`: 这个命令会在 Bundler 的上下文中运行 RSpec。Bundler 是一个 Ruby 的依赖管理工具，它能确保你的程序运行在一个包含所有你在 Gemfile 中指定的 gem 的环境中。当你运行 bundle exec rspec 的时候，Bundler 会先创建这样一个环境，然后在这个环境中运行 RSpec。这意味着，无论你的系统中安装了什么版本的 RSpec，bundle exec rspec 总是运行你在 Gemfile 中指定的那个版本的 RSpec。
总的来说，两者的区别在于运行环境。在大多数情况下，两者的效果是一样的。但是，如果你的系统中安装了多个版本的 RSpec，或者你的项目需要在一个特定的环境中运行，那么使用 bundle exec rspec 可能会更加可靠。

# 创建API文档

`bin/rake docs:generate`
注意若项目代码未变更的情况下运行报错了，可运行命令`rm -rf tmp/cache/bootsnap`清除缓存后再运行。
`./spec/acceptance`和`./spec/requests`
作用：两个目录下的文件均用来测试controller
差异：`acceptance`只测试成功的（成功才可创建文档），`requests`可测试失败的

`bundle exec rspec` 和 `bin/rake docs:generate` 区别

1. `bundle exec rspec`: 这个命令是用来运行 RSpec 测试的。RSpec 是 Ruby 语言中最常用的测试框架之一，它提供了一种 DSL（领域特定语言）来编写测试用例。当你执行 bundle exec rspec 命令时，RSpec 会运行你项目中的所有测试，并返回测试结果。这可以帮助你确保你的代码正常工作，没有引入新的错误或回归。

2. `bin/rake docs:generate`: 这个命令是用来生成文档的。rake 是 Ruby 语言的一个任务运行工具，你可以使用它来定义和运行各种任务。docs:generate 是一个自定义的 rake 任务，它的功能取决于你如何定义这个任务。通常，docs:generate 任务可能会生成 API 文档，或者其他类型的项目文档。

总的来说，`bundle exec rspec` 是用来运行测试的，该命令运行表示所有测试用例通过。而 `bin/rake docs:generate` 是用来生成文档的，该命令成功运行并不表示所有的测试用例都正常工作，只能说明文档生成没有问题。

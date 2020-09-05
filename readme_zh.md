
这个README.md知识提供快速开始的文档。其他详细信息可以查看：[redis.io](https://redis.io/)

什么是Redis？
------

Redis是一个内存结构数据库。这意味着Redis通过一组命令提供对可变数据结构的访问，这些命令是使用带有TCP套接字和简单协议的
服务器-客户机模型发送的。因此不同的进程可以以共享的方式查询和修改相同的数据结构。

Redis中实现的数据结构有几个特殊属性：

- Redis会将数据存储在磁盘上，数据总是被服务和修改到服务器内存中。这意味着Redis速度很快，但也不是易失性的。
- 数据结构的实现强调内存效率，因此与使用高级编程语言建模的相同数据结构相比，Redis中的数据结构可能使用更少的内存。
- Redis提供了许多在数据库中很自然的特性，比如复制、可调的持久性级别、集群、高可用性。

另一个很好的例子是将Redis看作是memcached的一个更复杂的版本，其中的操作不仅仅是set和get，而是处理复杂数据类型（如列表、
集合、有序数据结构等）的操作。

如果您想了解更多信息，可以点击下面链接：
- Redis数据类型介绍：[http://redis.io/topics/data-types-intro](http://redis.io/topics/data-types-intro)
- 直接在浏览器中尝试Redis。[http://try.redis.io](http://try.redis.io)
- Redis命令的完整列表。[http://redis.io/commands](http://redis.io/commands)
- Redis官方文档中还有更多内容。[http://redis.io/documentation](http://redis.io/documentation)

构建Redis
------

Redis可以在Linux、OSX、OpenBSD、NetBSD、FreeBSD上编译和使用。我们支持big-endian和little-endian体系结构，以及32位和64位
系统。

它可以在Solaris派生的系统（例如SmartOS）上编译，但是我们对这个平台的支持是最好的，Redis不能保证在Linux、OSX和*BSD中工作
得那么好。

编译命令
```sh
make
```
要使用TLS支持进行构建，您需要OpenSSL开发库（例如Debian/Ubuntu上的libssl dev）并运行：
```sh
make BUILD_TLS=yes
```
您可以使用以下方法运行32位Redis二进制文件:
```sh
make 32bit
```
在构建Redis之后，最好使用以下方法进行测试：
```sh
make test
```
如果构建了TLS，请在启用TLS的情况下运行测试（您需要安装tcl TLS）：
```sh
./utils/gen-test-certs.sh
./runtest --tls
```

修复依赖项或缓存生成选项的生成问题
-------

Redis有一些包含在deps目录中的依赖项。即使依赖项源代码中的某些内容发生更改，make也不会自动重新生成依赖项。

使用git pull更新源代码或以任何其他方式修改依赖关系树中的代码时，请确保使用以下命令，以便真正清理所有内容并从头开始重建：

```sh
make distclean
```
这将清除：jemalloc，lua，hiredis，linenoise。
另外，如果强制某些生成选项，如32位目标、无C编译器优化（用于调试目的）和其他类似的生成时选项，则这些选项将被无限期缓存，
直到发出makedistclean命令。

修复生成32位二进制文件的问题
-----

如果在用32位目标构建Redis之后需要用64位目标重新构建它，或者反过来，您需要在Redis发行版的根目录中执行`make distclean`。

如果在尝试构建32位的Redis二进制文件时出现构建错误，请尝试以下步骤：
- 安装包libc6-dev-i386（也可以尝试g++-multilib）。
- 尝试使用以下命令行` makecflags=“-m32-march=native”LDFLAGS=“-m32”` 代替` make32bit`

内存分配
-----
通过设置MALLOC环境变量，可以在构建Redis时选择非默认内存分配器。Redis在默认情况下是针对libc malloc编译和链接的，但
jemalloc是Linux系统上的默认设置。之所以选择此默认值，是因为jemalloc被证明比libc malloc具有更少的碎片问题。

强制使用`libc`编译，请使用：
```sh
 make MALLOC=libc
```
强制使用`jemalloc`编译，请使用：
```sh
make MALLOC=jemalloc
```

详细构建信息
-----
默认情况下，Redis将生成用户友好的彩色输出。如果要查看更详细的输出，请使用以下命令：

```sh
make V=1
```

运行Redis
------

要使用默认配置运行Redis，执行下面命令：

```sh
cd src
./redis-server
```

如果你想提供redis.con，您必须使用其他参数（配置文件的路径）来运行它：

```sh
cd src
./redis-server /path/to/redis.conf
```
通过使用命令行直接将参数作为参数传递，可以更改Redis配置。示例：

```sh
./redis-server --port 9999 --replicaof 127.0.0.1 6379
./redis-server /etc/redis/6379.conf --loglevel debug
```
所有redis.conf的配置参数也支持使用命令行作为参数，使用完全相同的名称。

Redis 支持TLS
-----

请查看[TLS.md](https://git.zeekling.cn/zeekling/redis/src/branch/master/TLS.md)文件获取有关如何将Redis与TLS一起使用的详细信息。

使用Redis
------

您可以使用redis cli来连接redis。启动一个redis服务器实例，然后在另一个终端上尝试以下操作：

```sh
% cd src
% ./redis-cli
redis> ping
PONG
redis> set foo bar
OK
redis> get foo
"bar"
redis> incr mycounter
(integer) 1
redis> incr mycounter
(integer) 2
redis>
```

您可以在中找到所有可用命令的列表:[http://redis.io/commands](http://redis.io/commands).

安装Redis
------

要将Redis二进制文件安装到/usr/local/bin中，只需使用：

```sh
make install
```

如果要使用其他目标，可以使用`make prefix=/some/other/directory install`。

`make install`将只在系统中安装二进制文件，但不会在适当的位置配置init脚本和配置文件。如果你只想玩一点Redis，这是不需要的，
但是如果你是在一个生产系统中正确地安装它，我们有一个脚本为Ubuntu和Debian系统这样做：

```sh
cd utils
./install_server.sh
```

**注意**:`install_server.sh`不支持在`Mac OSX`上面运行，只支持`Linux`。

该脚本将解决您一些问题，并将设置您所需的一切，以便将Redis作为后台守护程序正常运行，该后台守护程序将在系统重新启动时
重新启动。

您可以使用名为`/etc/init.d/Redis_<portnumber>`的脚本来停止和启动Redis，例如`/etc/init.d/Redis_6379`。



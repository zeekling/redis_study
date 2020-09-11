
[![Build Status](https://monitor.zeekling.cn/api/badges/zeekling/redis/status.svg)](https://monitor.zeekling.cn/zeekling/redis)

查看英文版，请查看:[README.md](https://git.zeekling.cn/zeekling/redis/src/branch/master/README_EN.md)

这个README.md知识提供快速开始的文档。其他详细信息可以查看：[redis.io](https://redis.io/)

## 什么是Redis？


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

## 构建Redis


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

### 修复依赖项或缓存生成选项的生成问题


Redis有一些包含在deps目录中的依赖项。即使依赖项源代码中的某些内容发生更改，make也不会自动重新生成依赖项。

使用git pull更新源代码或以任何其他方式修改依赖关系树中的代码时，请确保使用以下命令，以便真正清理所有内容并从头开始重建：

```sh
make distclean
```
这将清除：jemalloc，lua，hiredis，linenoise。
另外，如果强制某些生成选项，如32位目标、无C编译器优化（用于调试目的）和其他类似的生成时选项，则这些选项将被无限期缓存，
直到发出makedistclean命令。

### 修复生成32位二进制文件的问题


如果在用32位目标构建Redis之后需要用64位目标重新构建它，或者反过来，您需要在Redis发行版的根目录中执行`make distclean`。

如果在尝试构建32位的Redis二进制文件时出现构建错误，请尝试以下步骤：
- 安装包libc6-dev-i386（也可以尝试g++-multilib）。
- 尝试使用以下命令行` makecflags=“-m32-march=native”LDFLAGS=“-m32”` 代替` make32bit`

### 内存分配

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

### 显示详细构建信息

默认情况下，Redis将生成用户友好的彩色输出。如果要查看更详细的输出，请使用以下命令：

```sh
make V=1
```

### 运行Redis


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

### Redis 支持TLS


请查看[TLS.md](https://git.zeekling.cn/zeekling/redis/src/branch/master/TLS.md)文件获取有关如何将Redis与TLS一起使用的详细信息。

### 使用Redis


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

### 安装Redis

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

## 代码贡献

**注意**： 通过以任何形式向Redis项目贡献代码，包括通过Github发送请求、通过私人电子邮件或公共讨论组发送代码片段或补丁，
您同意根据BSD许可条款发布代码，您可以在Redis源代码发行版中包含的[COPYING](https://git.zeekling.cn/zeekling/redis/src/branch/master/COPYING)中找到该许可证。

有关详细信息，请参阅此源发行版中的[CONTRIBUTING](https://git.zeekling.cn/zeekling/redis/src/branch/master/CONTRIBUTING)。


## Redis 内部结构


如果您正在阅读这篇自述，那么您很可能是在Github页面前面或者您刚刚解除了Redis发行tar-ball的限制。在这两种情况下，您基本上
都离源代码只有一步之遥，所以这里我们将解释Redis源代码的布局、每个文件中的基本内容、Redis服务器内部最重要的功能和结构等
等。我们将所有的讨论保持在一个高水平上，而不是深入到细节，因为这个文档将是巨大的，否则我们的代码库将不断变化，但一个总体
的想法应该是一个很好的起点来理解更多。此外，大部分代码都有大量注释，并且易于理解。

### 源代码布局

Redis根目录只包含这个readme文件、调用src目录中实际Makefile的Makefile以及Redis和Sentinel的示例配置。您可以找到一些用于运行
Redis、Redis Cluster和Redis Sentinel单元测试的shell脚本，这些测试在tests目录中实现。

根目录中有以下重要目录：

- `src`: 包含Redis实现，用C编写。
- `tests`：包含在Tcl中实现的单元测试。
- `deps`：包含Redis使用的库。编译Redis所需的一切都在这个目录中；您的系统只需要提供libc、一个与POSIX兼容的接口和一个C编
  译器。值得注意的是，deps包含jemalloc的副本，这是Linux下Redis的默认分配器。请注意，在deps下，还有一些事情是从Redis项目
  开始的，但是对于这些项目，主存储库不是antirez/Redis。

还有一些目录，但它们对我们的目标并不重要。我们将主要关注src，其中包含Redis实现，探索每个文件中都有什么。为了逐步揭示不同的复杂性层次，文件的公开顺序是必须遵循的逻辑顺序。

**注意**：最近Redis被重构了不少。函数名和文件名已更改，因此您可能会发现此文档更接近于不稳定分支的反映。例如，在Redis 3.0
中，server.c和server.h文件名为Redis.c和Redis.h，但总体结构是相同的。请记住，所有新的开发和拉取请求都应该针对不稳定的分支执行。

### server.h

理解程序如何工作的最简单的方法是理解它使用的数据结构。所以我们从Redis的主头文件开始，它是server.h。

所有的服务器配置和一般的共享状态都是在一个名为server的全局结构中定义的，类型为struct rediserver。该结构中的几个重要字段是：

- `server.db`：是Redis数据库的数组，其中存储数据。
- `server.commands`：是命令列表。
- `server.clients`：是连接到服务器的客户端的链接列表。
- `server.master`：是一个特殊的客户机，如果实例是副本，则是主客户机。

还有很多其他的结构。大多数字段直接在结构定义内部进行注释。

另一个重要的Redis数据结构是定义客户机的结构。过去叫redisClient，现在只叫client。结构有很多字段，这里我们只展示主要字段：

```c
struct client {
    int fd;
    sds querybuf;
    int argc;
    robj **argv;
    redisDb *db;
    int flags;
    list *reply;
    char buf[PROTO_REPLY_CHUNK_BYTES];
    ... many other fields ...
}
```

`client`结构定义连接的客户端：

- fd字段是客户机套接字文件描述符。
- argc和argv使用客户端正在执行的命令填充，以便实现给定Redis命令的函数可以读取参数。
- querybuf对来自客户端的请求进行累加，这些请求由Redis服务器根据Redis协议进行解析，并通过调用客户端正在执行的命令的实现来执行。
- reply和buf是动态和静态缓冲区，用于累积服务器发送给客户机的响应。一旦文件描述符可写，这些缓冲区就会以增量方式写入套接字。

正如您在上面的客户机结构中看到的，命令中的参数被描述为robj结构。下面是完整的robj结构，它定义了一个Redis对象：

```c
typedef struct redisObject {
    unsigned type:4;
    unsigned encoding:4;
    unsigned lru:LRU_BITS; /* lru time (relative to server.lruclock) */
    int refcount;
    void *ptr;
} robj;
```
基本上，这个结构可以表示所有基本的Redis数据类型，如字符串、列表、集合、排序集等等。有趣的是它有一个类型字段，这样就可以
知道给定对象的类型，以及refcount，这样就可以在多个地方引用同一个对象，而无需多次分配它。最后，ptr字段指向对象的实际表示
形式，即使对于同一类型，它也可能有所不同，这取决于所使用的编码。

Redis对象在Redis内部被广泛使用，但是为了避免间接访问的开销，最近在很多地方我们只使用普通的动态字符串，而不是包装在Redis对象中。


### server.c

这是Redis服务器的入口点，在这里定义main（）函数。以下是启动Redis服务器的最重要步骤。

- `initServerConfig()`:设置服务器结构的默认值。
- `initServer()`:分配操作所需的数据结构，设置侦听套接字，等等。
- `aeMain()`:启动侦听新连接的事件循环。

事件循环定期调用两个特殊函数：

- `serverCron()`:定期调用（根据服务器.hz必须从时间和频率方面检查客户机。
- `beforeSleep()`:每次触发事件循环时都会调用，Redis为一些请求提供服务，并返回到事件循环中。

在server.c中，您可以找到处理Redis服务器其他重要事务的代码：

- `call()`:用于在给定客户端的上下文中调用给定命令。
- `activeExpireCycle()`:通过EXPIRE命令处理带有生存时间设置的密钥的设备。
- `freeMemoryIfNeeded()`:当应执行新的write命令，但根据maxmemory指令Redis内存不足时调用。
- 全局变量redisCommandTable定义所有Redis命令，指定命令的名称、实现该命令的函数、所需参数的数量以及每个命令的其他属性。

### networking.c

这个文件定义了客户端、主机和副本的所有I/O功能（在Redis中只是特殊的客户端）：

- `createClient()`：分配并初始化新客户端。
- 分配并初始化一个新的客户命令实现使用`addReply*()`系列函数，以便将数据附加到客户机结构中，这些数据将作为对执行的给定命令的应答传输到客户端。
- `writeToClient()`:将输出缓冲区中挂起的数据传输到客户端，并由可写事件处理程序`sendReplyToClient()`调用。
- `readQueryFromClient()`:是可读的事件处理程序，并将从客户端读取的数据累积到查询缓冲区。
- `processInputBuffer()`:是根据Redis协议解析客户端查询缓冲区的入口点。一旦命令准备好被处理，它就会调用在server.c中定义的processCommand（），以便实际执行该命令。
- `freeClient()`:取消分配、断开和删除客户端。

### aof.c and rdb.c

从名称中可以猜到，这些文件实现了Redis的RDB和AOF持久性。基于Redis（）的共享线程在同一个Redis线程上创建共享内存fork（）
模型。这个辅助线程将内存的内容转储到磁盘上。rdb.c使用它在磁盘上创建快照，aof.c使用它在只追加的文件太大时执行aof重写。

在aof.c中的实现有附加的函数，以便实现一个API，该API允许命令在客户端执行命令时将新命令附加到aof文件中。

在server.c中定义的call（）函数负责调用将命令写入AOF的函数。

### db.c

某些Redis命令操作特定的数据类型，其他命令是通用的。通用命令的示例有DEL和EXPIRE。它们操作的是键，而不是具体的值。所有这
些通用命令都在db.c中定义

此外，db.c实现了一个API，以便在Redis数据集上执行某些操作，而不直接访问内部数据结构。

db.c中最重要的函数在许多命令实现中使用如下：

- lookupKeyRead（）和lookupKeyWrite（）用于获取指向与给定键关联的值的指针，如果该键不存在，则为NULL。
- dbAdd（）和它的高级对应setKey（）在Redis数据库中创建一个新的键。
- dbDelete（）删除键及其关联值。
- emptyDb（）删除整个单个数据库或定义的所有数据库。

文件的其余部分实现了向客户机公开的通用命令。

### object.c

已经描述了定义Redis对象的robj结构。在object.c中有所有在基本级别操作Redis对象的函数，比如分配新对象、处理引用计数等等。
此文件中的重要功能：

- incrRefcount（）和decrefCount（）用于递增或递减对象引用计数。当它降到0时，对象最终被释放。
- createObject（）分配新对象。还有一些专门的函数来分配具有特定内容的字符串对象，如createStringObjectFromLongLong（）和类似函数。

此文件还实现OBJECT命令。

### replication.c

这是Redis中最复杂的文件之一，建议您在对其余代码库有一点熟悉之后再使用它。在这个文件中，实现了Redis的master和replica角色。

这个文件中最重要的函数之一是replicationFeedSlaves（），它向表示连接到主服务器的副本实例的客户机写入命令，以便副本可以获
得客户端执行的写入操作：这样，它们的数据集将与主服务器中的数据集保持同步。

此文件还实现SYNC和PSYNC命令，这些命令用于在主服务器和副本之间执行第一次同步，或在断开连接后继续复制。

### Other C files

- t_hash.c、t_list.c、t_set.c、t_string.c、t_zset.c和t_stream.c包含Redis数据类型的实现。它们实现一个API来访问给定的数据
  类型，而客户机命令实现这些数据类型。
- ae.c实现了Redis事件循环，它是一个自包含的库，易于阅读和理解。
- sds.c是Redis字符串库，详细查看[https://github.com/antirez/sds](https://github.com/antirez/sds)。
- 与内核公开的原始接口相比，anet.c是一个以更简单的方式使用POSIX网络的库。
- dict.c是一个非阻塞哈希表的实现，它可以递增地重新计算。
- c实现Lua脚本。它完全独立于Redis实现的其余部分，并且非常简单，可以理解您是否熟悉luaapi。
- c实现Redis集群。在非常熟悉Redis代码库的其余部分之后，这可能是一个不错的只读版本。如果你想读cluster.c，一定要读[Redis cluster规范](https://redis.io/topics/cluster-spec)。

### Anatomy of a Redis command

所有Redis命令的定义方式如下：

```c
void foobarCommand(client *c) {
    printf("%s",c->argv[1]->ptr); /* Do something with the argument. */
    addReply(c,shared.ok); /* Reply something to the client. */
}
```

然后在命令表的server.c中引用该命令：

```c
{"foobar",foobarCommand,2,"rtF",0,NULL,0,0,0,0,0},
```

在上面的示例中，2是命令接受的参数数，而“rtF”是命令标志，如server.c中的命令表顶部注释中所述。

命令以某种方式运行后，它将一个应答返回给客户机，通常使用addReply（）或networking.c中定义的类似函数。

Redis源代码中有大量的命令实现，可以作为实际命令实现的示例。编写一些玩具命令是熟悉代码库的一个很好的练习。

还有许多其他的文件没有在这里描述，但它是没有用的涵盖一切。我们只想帮助你迈出第一步。最终，您将在Redis代码库中找到自己的方法：-）




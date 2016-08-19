# Skynet 框架入门指南

## 目录

* 安装
* Hello Skynet

## 安装
参照 [Skynet 官方文档](https://github.com/cloudwu/skynet)

## Hello Skynet
云风在 Blog 里经常提起，你可以把 Skynet 当成一个操作系统。以下的内容正是基于这一灵感，如果你认为有类比不对或表达不清的地方，欢迎你给我提 [issue](https://github.com/lintide/GettingStartedSkynet/issues/new)

在很久很久以前，那还是一个需要自己去电脑城组装电脑的时代，店里的小哥记下你要的配置，组装好后回到家你高高兴兴地开机验货。在 Skynet 里的世界也是一样的，首先你需要一个配置单。

### 第一台 Skynet 电脑配置单
[hello/config](hello/config)：

```lua
root = "./"
thread = 4
harbor = 0 -- 单点模式
bootstrap = "snlua helloSkynet"	-- 启动第一个服务
luaservice = root.."service/?.lua;"..root.."test/?.lua;"..root.."GettingStartedSkynet/hello/?.lua"
```

配置单的信息

* 这是一台四核的电脑: `thread = 4`，如果你预算比较多，搞成8核，16核都可以
* 单机模式，不跟其它电脑通讯：`harbor = 0`，所以也没有任何网络接口
* 告诉 Skynet 电脑启动后运行 `helloSkyent` 程序：`bootstrap = "snlua helloSkynet"`
* `helloSkynet` 这个程序放在 `GettingStartedSkynet/hello/?.lua` 目录下: `luaservice = ...`


### 第一个程序
[hello/helloSkynet.lua](hello/helloSkynet.lua):

 ```lua
 local skynet = require "skynet"

 skynet.start(function()
   skynet.error("Hello Skynet!")
   skynet.exit()
 end)
 ```

* 导入 `skynet`
* 任何__服务__必须有启动函数 `skynet.start` ，`skynet.start` 需要转入 `function() ... end` 参数
* 在启动函数里打印 __Hello Skynet!__ 字符串，然后退出 `skynet.exit()`

### 验证电脑是否有毛病
```
$ ./skynet GettingStartedSkynet/hello/config
```

如果输出
```
[:00000001] LAUNCH logger
[:00000002] LAUNCH snlua helloSkynet
[:00000002] Hello Skynet!
[:00000002] KILL self
```

恭喜你，我们进入下一个旅程

## 服务
电脑能给我们提供什么服务？我相信绝大多事的人购买电脑目的是为了学习，个别同志会想办法下下片。说起下片，有个神器 __kuaipo__。

### 下片
[unzip/kuaipo](unzip/kuaipo.lua) 最重要的就是下载功能了，以下功能仅作模拟，还真下不了片。

```lua
local kuaipo = {}

-- 快播有下载的功能
kuaipo.download = function(file)
  for i=0,100,10 do
    skynet.error(file .. " downloading... %" .. i)
    skynet.sleep(10)
  end
end
```

下完片之后我还需要他自动解压缩，祭出盗版软件 __WinRAR__ （我突然发现好久没用过这个鬼东西了，满满都是回忆）。

### 自动解压
下完片，一般我们都是手动解压缩的。片下多了，一个个点开解压缩也不是办法，得让他自动化。那么问题来了，这是两个不同的软件，怎么让他们沟通起来呢？

```
kuaipo 对 WinRAR 说：片下好了，麻烦你解压一下。
```

转换为代码如下 [unzip/kuaipo](unzip/kuaipo.lua)：
```lua
local winRAR = skynet.newservice("winRAR")
skynet.send(winRAR, "lua", "upzip", filename)
```

* `skynet.newservice` 创建一个新服务，类似我们在电脑上打开 __winRAR__ 这个软件
* `skynet.send` 告诉 __winRAR__ 解压文件 `filename`

现实生活中，我们是如何知道 __winRAR__ 软件可以解压缩的呢？大多应该都是听朋友讲的，口口相传。在 skynet 的世界里而你必须告诉 skynet 我有办法解压缩。

[unzip/kuaipo](unzip/kuaipo.lua)
```lua
skynet.dispatch("lua", function(session, source, cmd, filename, ...)
...
end)
```

你必须通过 `skynet.dispatch` 函数来告诉系统 __winRAR__ 这个软件能干嘛。

读完这一小节，你只要好好理解这三个函数即可：`newservice`, `send`, `dispatch`

注意 (config)[upzip/config] 文件有变化哦，我也还没弄明白其中的道理，你先这样用着吧 :)

# Skynet 框架入门指南

## 目录

* 安装
* Hello Skynet

## 安装
参照 [Skynet 官方文档](https://github.com/cloudwu/skynet)

## Hello Skynet
云风在 Blog 里经常提起，你可以把 Skynet 当成一个操作系统。以下的内容就是基于这一灵感。

在很久很久以前，那还是一个需要自己去电脑城组装电脑的时候，店里的小哥记下你要的配置，组装好后回到家你高高兴兴地开机验货。在 Skynet 里的世界也是一样的，首先你需要一个配置单。以下就是我们第一个 Skynet 的配置单 [hello/config](hello/config)：

```
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


 第一个程序: [hello/helloSkynet.lua](hello/helloSkynet.lua):

 ```
 local skynet = require "skynet"

 skynet.start(function()
   skynet.error("Hello Skynet!")
   skynet.exit()
 end)
 ```

* 导入 `skynet`
* 任何服务必须有启动函数 `skynet.start` ，`skynet.start` 需要转入 `function() ... end`
* 在启动函数里打印 __Hello Skynet!__ 字符串，然后退出 `skynet.exit()`

验证电脑是否有毛病
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

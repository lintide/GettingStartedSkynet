local skynet = require "skynet"
local socket = require "socket"

local client
local agent = {}
local gate

skynet.start(function()
  gate = skynet.newservice("gate")

  skynet.call(gate, "lua", "open" , {
    address = "127.0.0.1", -- 监听地址 127.0.0.1
    port = 8888,    -- 监听端口 8888
    maxclient = 1024,   -- 最多允许 1024 个外部连接同时建立
    nodelay = true,     -- 给外部连接设置  TCP_NODELAY 属性
  })

  skynet.dispatch("lua", function(session, source, cmd, subcmd, ...)
    skynet.error("cmd: "..cmd.."  subcmd: "..subcmd)
    if cmd == "socket" then
      if subcmd == "open" then
        newClient(...)

      elseif subcmd == "data" then
        local msg
        fd, msg = ...
        skynet.error(msg)

        -- send message
        local sm = "pong"
        local pack = string.pack(">s2", sm)
        socket.write(fd, pack)
      end
    end
  end)


end)


function newClient(fd, addr)
  skynet.error("newClient from: "..addr)

  -- 以下两句用其中一句都可以接收到客户端的数据，但是用 forward 时会报错 Unknown request
  skynet.call(gate, "lua", "accept", fd);
  -- skynet.call(gate, "lua", "forward", fd);

-- 每次收到 handler.connect 后，你都需要调用 openclient 让 fd 上的消息进入。默认状态下， fd 仅仅是连接上你的服务器，
-- 但无法发送消息给你。这个步骤需要你显式的调用是因为，或许你需要在新连接建立后，把 fd 的控制权转交给别的服务。那么你可以在一切准备好以后，再放行消息。
-- https://github.com/cloudwu/skynet/wiki/GateServer


end

local skynet = require "skynet"
local netpack = require "netpack"
local socket = require "socket"
local sproto = require "sproto"
local sprotoloader = require "sprotoloader"

local WATCHDOG
local host
local send_request

local CMD = {}
local REQUEST = {}
local client_fd

-- skynet.register_protocol {
--   name = "client",
--   id = skynet.PTYPE_CLIENT,
--   pack = function(m) return tostring(m) end,
--   unpack = skynet.tostring,
-- }

-- skynet.register_protocol {
-- 	name = "client",
-- 	id = skynet.PTYPE_CLIENT,
-- 	unpack = function (msg, sz)
-- 		return host:dispatch(msg, sz)
-- 	end,
-- 	dispatch = function (_, _, type, ...)
-- 		if type == "REQUEST" then
-- 			local ok, result  = pcall(request, ...)
-- 			if ok then
-- 				if result then
-- 					send_package(result)
-- 				end
-- 			else
-- 				skynet.error(result)
-- 			end
-- 		else
-- 			assert(type == "RESPONSE")
-- 			error "This example doesn't support request client"
-- 		end
-- 	end
-- }

function CMD.start(conf)
	local fd = conf.client
	local gate = conf.gate
	WATCHDOG = conf.watchdog
	-- slot 1,2 set at main.lua
	-- host = sprotoloader.load(1):host "package"
	-- send_request = host:attach(sprotoloader.load(2))
	-- skynet.fork(function()
	-- 	while true do
	-- 		-- send_package(send_request "heartbeat")
	-- 		skynet.sleep(500)
	-- 	end
	-- end)

	client_fd = fd
	skynet.call(gate, "lua", "forward", fd)
end

function CMD.disconnect()
	-- todo: do something before exit
	skynet.exit()
end

skynet.start(function()
	skynet.dispatch("lua", function(_,_, command, ...)
		local f = CMD[command]
		f(...)
		-- skynet.ret(skynet.pack(f(...)))
	end)

	-- skynet.dispatch("client", function(a, b, c, ...)
	-- 	skynet.error("client message: "..a.." "..b.." "..c.." ")
	-- 	skynet.error(#c)
	-- end)
end)

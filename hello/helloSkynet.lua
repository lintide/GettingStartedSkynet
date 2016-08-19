local skynet = require "skynet"

skynet.start(function()
  skynet.error("Hello Skynet!")
  skynet.exit()
end)

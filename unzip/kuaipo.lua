local skynet = require "skynet"

local kuaipo = {}

-- 快播有下载的功能
kuaipo.download = function(file)
  for i=0,100,10 do
    skynet.error(file .. " downloading... %" .. i)
    skynet.sleep(10)
  end
end

skynet.start(function()

  local filename = "hahaha.av.rar"
  -- 开始下载
  kuaipo.download(filename)

  -- 下载完成后用 winRAR 解压缩
  local winRAR = skynet.newservice("winRAR")
  skynet.send(winRAR, "lua", "upzip", filename)
end)

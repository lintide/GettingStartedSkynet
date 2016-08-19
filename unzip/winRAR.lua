local skynet = require "skynet"

skynet.start(function()
  skynet.dispatch("lua", function(session, source, cmd, filename, ...)
    skynet.error(cmd.." "..filename.." starting...")

    for i=0,100,10 do
      skynet.error(cmd.." "..filename.." %"..i)
      skynet.sleep(10)
    end

    skynet.error(cmd.." "..filename.." completed.")
  end)
end)

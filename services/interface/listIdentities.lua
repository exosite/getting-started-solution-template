operation.solution_id = nil
local identities = Device2.listIdentities(operation)
if identities.code ~= nil then
  return identities
end

local configIO = require("configIO")
local configIOData = configIO.get()
if configIOData.config_io ~= "" and next(identities.devices) ~= nil then
  local transform = require("vendor.transform")
  for k, identity in pairs(identities.devices) do
    identities.devices[k].state.config_io = {
      timestamp = configIOData.timestamp,
      set = configIOData.config_io,
      reported = configIOData.config_io
    }
    if transform ~= nil and transform.convertIdentityState ~= nil then
      identities.devices[k].state = transform.convertIdentityState(identities.devices[k].state)
    end
  end
end

return identities

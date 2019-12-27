
local transform = require("vendor.transform")
if event.type == "provisioned" then
  Device2.setIdentityState({
    identity = identity,
    config_io = "<<Config IO is defined globally in the module `vendor.configIO`>>"
  })
end
if event.payload and transform and transform.convertIdentityState then
  for i, data in ipairs(event.payload) do
    data.values = transform.convertIdentityState(data.values)
  end
end

return Interface.trigger({event="event", data=event})

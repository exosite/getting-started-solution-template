local identities = Device2.listIdentities(operation)
if identities.error or not next(identities.devices) then return identities end

local configIO = require("configIO")
for k, identity in pairs(identities.devices) do
  identity.state = configIO.setState(identity.state);
end
local transform = require("vendor.transform")
if transform and transform.convertIdentityState then
  for k, identity in pairs(identities.devices) do
    identity.state = transform.convertIdentityState(identity.state)
  end
end

return identities

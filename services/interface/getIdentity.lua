local identity = Device2.getIdentity(operation)
if identity.error then return identity end

local configIO = require("configIO")
identity.state = configIO.setState(identity.state);

local transform = require("vendor.transform")
if transform and transform.convertIdentityState then
  identity.state = transform.convertIdentityState(identity.state)
end

return identity

local identityState = Device2.getIdentityState(operation)
if identityState.error then return identityState end

local configIO = require("configIO")
identityState = configIO.setState(identityState);

local transform = require("vendor.transform")
if transform and transform.convertIdentityState then
  identityState = transform.convertIdentityState(identityState)
end

return identityState

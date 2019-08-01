
local murano2cloud = require("c2c.murano2cloud").alias

-- This event listen to the changes made on the Service configuration to react to user setting change
if service.service == murano2cloud.alias and (service.action == "added" or service.action == "updated") then
  local result = Config.getParameters({service = service.service})
  if (result.parameters.callback_token) then
    -- User changed the token save it.
    require("c2c.authentication").setToken(service.parameters.callback_token)

    -- New credentials should sync again
    require("c2c.cloud2murano").syncAll()
  end
end

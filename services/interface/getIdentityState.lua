operation.solution_id = nil

local identityState = Device2.getIdentityState(operation)
if identityState.code ~= nil then
  return identityState
end

local configIOCache = Keystore.get({ key = "config_io" })

if configIOCache.value ~= nil then
  local configIO, err = json.parse(configIOCache.value)
  if err ~= nil then
    print("The config_io parse error", err)
  else
    local configIOSetting = configIO.values
    identityState.config_io = {
      timestamp = configIO.timestamp,
      set = configIOSetting,
      reported = configIOSetting
    }
  end
end

return identityState
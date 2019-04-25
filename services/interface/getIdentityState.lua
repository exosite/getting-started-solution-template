operation.solution_id = nil

local identityState = Device2.getIdentityState(operation)
if identityState.code ~= nil then
  return identityState
end

local now = os.time(os.date("!*t"))
-- Invalidate cache every 10 sec
if configIOCache == nil or now - configIOCache_ts > 10 then
  result = Keystore.get({ key = "config_io" })
  if result ~= nil and result.value ~= nil then
    -- Following is a VM global value cached on hot VM
    configIOCache, err = json.parse(result.value)
    if err ~= nil then
      print("The config_io parse error", err)
    else
      configIOCache_ts = now
    end
  end
end

if configIOCache ~= nil then
  identityState.config_io = {
    timestamp = configIOCache.timestamp,
    set = configIOCache.values,
    reported = configIOCache.values
  }
end

return identityState
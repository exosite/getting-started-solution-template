operation.solution_id = nil
local config_io = operation.config_io
if config_io ~= nil then
  local timestamp = os.time(os.date("!*t")) * 1000000
  local configIOString, err = json.stringify({ timestamp = timestamp, values = config_io })
  if err ~= nil then
    print("The config_io encode to JSON error", err)
  else
    Keystore.set({ key = "config_io", value = configIOString })
  end
  for key, value in pairs(operation) do
    if key ~= "config_io" and key ~= "identity" then
      operation.config_io = nil
      return Device2.setIdentityState(operation)
    end
  end
  return { status = 204, status_code = 204 }
end

return Device2.setIdentityState(operation)
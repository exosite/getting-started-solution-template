
-- Migrate config_io structure
local result = Keystore.get({ key = "config_io" })
if result ~= nil and result.value ~= nil then
  result, err = json.parse(result.value)
  if err ~= nil then
    log.error("'config_io' parsing error", err)
  else
    if result.config then
      result.config_io = result.config
      result.config = nil
    end
    if type(result.config_io) ~= "string" then
      result.config_io = json.stringify(result.config_io)
    end
    Keystore.set({ key = "config_io", value = json.stringify(result) })
  end
end

local configIO = {}

function configIO.get()
  local now = os.time(os.date("!*t"))
  if configIOCache == nil or now - configIOCache_ts > 10 then
    local result = Keystore.get({ key = "config_io" })
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
  local configIOString, err = json.stringify(configIOCache.config)
  if err ~= nil then
    print("The config_io encode to JSON error", err)
    return { config = "" }
  else
    return { timestamp = configIOCache.timestamp, config = configIOString }
  end
end

function configIO.set(configIO)
  local timestamp = os.time(os.date("!*t"))
  local configIOTable = { timestamp = timestamp * 1000000, config = configIO }
  local configIOString, err = json.stringify(configIOTable)
  if err ~= nil then
    print("The config_io encode to JSON error", err)
  else
    configIOCache = configIOTable
    configIOCache_ts = timestamp
    Keystore.set({ key = "config_io", value = configIOString })
  end
end

return configIO
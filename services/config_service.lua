function join(t1, t2)
  for _, v in pairs(t2) do
    table.insert(t1, v)
  end
  return t1
end

if service.service == "sigfox" and service.action == "updated" then
  local currentTime = os.time(os.date("!*t"))
  local timestamp = currentTime * 1000000
  local isoTime = os.date("!%Y-%m-%dT%H:%M:%S+00:00", currentTime)
  local parameters = Config.getParameters({service = "sigfox"})
  local payloadConfigs = {}
  local channels = {}
  if parameters.parameters.callbacks ~= nil then
    for k, v in pairs(parameters.parameters.callbacks) do
      if v.payloadConfig ~= nil then
        join(payloadConfigs, v.payloadConfig)
      end
    end
  end
  for k, v in pairs(payloadConfigs) do
    local channelName = ""
    local properties = {}
    local nestJson = string.match(v.resource, "data_in%.%a+%.")
    if nestJson ~= nil then
      channelName = string.sub(v.resource, string.len(nestJson) + 1)
      properties.data_type = "JSON"
    elseif string.match(v.resource, "data_in%.") ~= nil then
      channelName = string.sub(v.resource, 9)
      properties.data_type = "NUMBER"
    end

    if channelName ~= "" then
      channels[channelName] = {
        display_name = channelName,
        description = "",
        properties = properties
      }
    end
  end

  local configIO = {
    last_edited = isoTime,
    last_editor = "sigfox",
    channels = channels
  }
  local configIOJson, err = json.stringify(configIO)
  if err ~= nil then
    print("The config_io encode to JSON error", err)
  else
    local configIOString, err = json.stringify({ timestamp = timestamp, values = configIOJson })
    if err ~= nil then
      print("The config_io encode to JSON error", err)
    else
      Keystore.set({ key = "config_io", value = configIOString })
    end
  end

  -- When Sigfox service configuration changes fetch new data
  -- Eg. if password change or else..
  Sigfox.muranoSync()
  -- Would not be needed if Sigfox uses x-exosite-init/x-exosite-update lifecycle events
end

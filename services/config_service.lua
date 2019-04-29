local configIO = require("configIO")

function join(t1, t2)
  for _, v in pairs(t2) do
    table.insert(t1, v)
  end
  return t1
end

function getType(definition)
  if definition:match("char") ~= nil then
    return "STRING"
  end
  return "NUMBER"
end

if service.service == "sigfox" and service.action == "updated" then
  local currentTime = os.time(os.date("!*t"))
  local timestamp = currentTime * 1000000
  local isoTime = os.date("!%Y-%m-%dT%H:%M:%S.000Z", currentTime)
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
      channelName = string.sub(v.resource, 9, string.len(nestJson) - 1)
      if channelName == "gps" then
        properties.data_type = "LOCATION"
        properties.data_unit = "LAT_LONG_ALT"
      else
        properties.data_type = "JSON"
      end
    elseif string.match(v.resource, "data_in%.") ~= nil then
      channelName = string.sub(v.resource, 9)
      properties.data_type = getType(v.definition)
    end

    if channelName ~= "" then
      channels[channelName] = {
        display_name = channelName,
        description = "",
        properties = properties
      }
    end
  end

  if next(channels) ~= nil then
    configIO.set({
      last_edited = isoTime,
      last_editor = "sigfox",
      channels = channels
    })
  end

  -- When Sigfox service configuration changes fetch new data
  -- Eg. if password change or else..
  Sigfox.muranoSync()
  -- Would not be needed if Sigfox uses x-exosite-init/x-exosite-update lifecycle events
end
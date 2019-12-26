-- This files generates the configIO & merge it with CUSTOM channels defined in 'vendor.configIO'

local configIO = {}
local vendorIO = require("vendor.configIO")

function configIO.get()
  local now = os.time(os.date("!*t"))
  if globalConfigIOCache == nil or now - globalConfigIOCache_ts > 10 then
    local result = Keystore.get({ key = "config_io" })
    if result ~= nil and result.value ~= nil and result.value ~= "" then
      -- Following is a VM global value cached on hot VM
      globalConfigIOCache, err = json.parse(result.value)
      if err ~= nil then
        log.error("'config_io' parsing error", err)
      else
        globalConfigIOCache_ts = now -- global
      end
    end
  end
  return globalConfigIOCache
end

function configIO.merge(configIO_a, configIO_b)
  local config_io = {}
  if type(configIO_a) == "string" then configIO_a = json.parse(configIO_a)
  if type(configIO_b) == "string" then configIO_b = json.parse(configIO_b)

  for k,v in pairs(configIO_a.channels or {}) do config_io[k] = v end
  for k,v in pairs(configIO_b.channels or {}) do config_io[k] = v end
  return config_io
end

function configIO.set(config_io)
  if type(config_io) == "string" then json.parse(config_io) end
  local timestamp = os.time(os.date("!*t"))
  config_io.last_edited = os.date("!%Y-%m-%dT%H:%M:%S.000Z", timestamp)

  local configIOTable = { timestamp = timestamp * 1000000, config_io = config_io }
  if vendorIO and vendorIO.config_io then
    if vendorIO.timestamp then configIOTable.timestamp = vendorIO.timestamp
    configIOTable.config = configIO.merge(vendorIO.config_io, config_io)
  end
  if type(configIOTable.config_io) ~= "string" then
    configIOTable.config_io = json.stringify(configIOTable.config_io)
    if not configIOTable.config_io then
      log.error("'config_io' encoding error", err, configIOTable.config_io)
      return nil, err
    end
  end
  local configIOString, err = json.stringify(configIOTable)
  if err ~= nil then
    log.error("'config_io' encoding error", err, configIOTable)
    return nil, err
  end
  globalConfigIOCache = configIOTable
  globalConfigIOCache_ts = timestamp
  return Keystore.set({ key = "config_io", value = configIOString })
end

local function getPrimitivType(definition, nestJson)
  if nestJson and nestJson ~= "" then
    return "JSON"
  elseif definition:match("bool") ~= nil then
    return "BOOLEAN"
  elseif definition:match("char") ~= nil then
    return "STRING"
  end
  return "NUMBER"
end

function configIO.createChannel(resource, definition)
  local channelTypes = require("channelTypes")
  local channelName, nestJson = string.match(resource, "data_in%.([%w_]+)%.?(.*)")
  local displayName = ""
  local description = ""
  local properties = {
    data_type = getPrimitivType(definition, nestJson)
  }

  -- Hard-coded custom mapping
  if channelName == "gps" and nestJson == "lng" or nestJson == "lat" then
    properties.data_type = "LOCATION"
    properties.data_unit = "LAT_LONG_ALT"
  elseif channelName then
    local tLen, lLen
    -- getting type from matching resource name to Exosense type
    for i, type in ipairs(channelTypes) do
      tLen = string.len(type.id)
      if string.upper(string.sub(channelName, 1, tLen)) == type.id
        -- primitive_type is not yet in the types files but should be
        -- and properties.data_type == type.primitive_type
      then
        properties.data_type = type.id
        if type.name then
          displayName = type.name
          description = type.name
        end

        -- getting unit
        if type.units then
          for i, unit in ipairs(type.units) do
            lLen = 0
            if string.upper(string.sub(channelName, tLen + 2, tLen + 1 + string.len(unit.id))) == unit.id then
              lLen = string.len(unit.id)
            else
              local abbr = string.upper(string.gsub(unit.abbr, "([^%w])", ""))
              if string.upper(string.sub(channelName, tLen + 2, tLen + 1 + string.len(abbr))) == abbr then
                lLen = string.len(abbr)
              end
            end
            if lLen > 0 then
              properties.data_unit = unit.id
              if unit.name then
                displayName = displayName .. ' (' .. (unit.abbr or unit.name) .. ')'
                description = description .. ' in ' .. unit.name
              end
              break
            end
          end
        end
        break
      end
    end
  end

  if not channelName then
    return nil
  end

  if displayName == "" then
    displayName = channelName
  end
  if description == "" then
    description = displayName
  end

  return channelName, {
    display_name = displayName,
    description = description,
    properties = properties
  }
end

return configIO

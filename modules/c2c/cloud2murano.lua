local cloud2murano = {}
-- This module authenticates the 3rd party cloud callback requests
-- To be updated depending on the security requirements

local cloudServiceName = require("c2c.murano2cloud").alias
local transform = require("vendor.c2c.transform")
local device2 = murano.services.device2 -- to bypass the proxy (device2.lua)

-- Propagate event to Murano applications
function cloud2murano.trigger(identity, event_type, payload, options)
    local event = {
      ip = options.ip,
      type = event_type,
      identity = identity,
      protocol = cloudServiceName,
      timestamp = options.timestamp or os.time(os.date("!*t")),
      connection_id = options.request_id or context.tracking_id,
      payload = payload
    }

    if handle_device2_event then
      handle_device2_event(event)
    end
end

function cloud2murano.provisioned(identity, data, options)
  device2.addIdentity({ identity = identity })
  cloud2murano.trigger(identity, "provisioned", nil, options)
end

function cloud2murano.deleted(identity, data, options)
  device2.removeIdentity({ identity = identity })
  cloud2murano.trigger(identity, "deleted", nil, options)
end

function cloud2murano.data_in(identity, data, options)
  data = transform.data_in(data) -- template user customized data transforms
  result = device2.setIdentityState({
    identity = identity,
    data_in = data
  })
  if result and result.status == 404 then
    -- Auto register device on data in
    cloud2murano.provisioned(identity, nil, options)
  end

  local payload = {{
    values = {
      data_in = data
    },
    timestamp = (options.timestamp or os.time(os.date("!*t")))
  }}

  event.updated_resources = {"data_in"} -- not sure if needed?
  cloud2murano.trigger(identity, "data_in", payload, options)
end

local even_type_map = {
  data = "data_in",
  device_added = "provisioned",
  device_removed = "deleted"
  -- "connect" & "disconnect" are not fully supported as we cannot set the connection state to device2
}

-- Parse a data from 3rd part cloud into Murano event
-- Update this part to match the incoming payload content.
-- The below example assume the callback passes 1 device id and 1 event type
function cloud2murano.sync(data, options)
  if not (data.identity or data.type) then
    log.warn("Cannot find identity or type in callback payload..", to_json(data))
    return
  end

  local event_type = even_type_map[data.type]
  if event_type then
    return cloud2murano[event_type](data.identity, data.data, options)
  end
end

local murano2cloud = require('murano2cloud')

function cloud2murano.syncAll()
  if murano2cloud and murano2cloud.sync then
    local results = require('murano2cloud').sync()
    if results.error then
      return log.error(results.error)
    end
  end
  for i, result in ipairs(results) do
    if result.device_id then
      cloud2murano.data_in(result.device_id, result.data, {})
    end
  end
end

return cloud2murano
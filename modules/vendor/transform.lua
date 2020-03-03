local transform = {}

-- local parser_factory = require("bytes.parser_factory")
-- function transform.DecodeMode(uplink)
--   -- Here decode data from uplink string (the 12 bytes transmitted by devices)
--   -- Generated data in 'data_in' must be defined in the module 'vendor.configIO'
--   -- In this example an integer in first byte is used as mode
--   local mode = parser_factory.getuint(parser_factory.fromhex(uplink),0,8)
--   if mode == 1 then
--     -- Here decode the remaining bytes base on the mode. Example: temperature as float
--     return {temperature = parser_factory.getfloat_32(parser_factory.fromhex(uplink),1)}
--   elseif mode == 2 then
--     -- Another mode example extracting a Boolean value
--     return {button_enabled = parser_factory.getbool(parser_factory.fromhex(uplink),1,2)}    
--   else
--     log.error("Un-supported mode " .. mode .. " from uplink: " .. uplink)
--     return {}
--   end
-- end


-- function convertState(data_in_source)
--   local data_in, err = json.parse(data_in_source)
--   if err ~= nil then
--     return data_in_source
--   end

--   if data_in.gps ~= nil then
--     if data_in.gps.lat ~= nil then
--       data_in.gps.lat = data_in.gps.lat / 1000000
--     end
--     if data_in.gps.lng ~= nil then
--       data_in.gps.lng = data_in.gps.lng / 1000000
--     end
--   end

--    In this example we generate dynamically a new channel 'sum_ab'
--    This virtual custom channel MUST be defined in the module 'vendor.configIO'
--    if type(data_in.a) == "number" and type(data_in.b) == "number" then
--      data_in.sum_ab = data_in.a + data_in.b
--    end
--   return json.stringify(data_in)
-- end


-- function transform.convertIdentityState(state)
--   if state == nil or state.data_in == nil then
--     return state
--   end

-- Below an example of transforming uplink message from a device
-- decoded values in string will be then stored in data_in
--   if type(state.uplink) == "table" then
--     state.data_in = json.stringify(transform.DecodeMode(state.uplink.reported))
--   else
--     state.data_in = json.stringify(transform.DecodeMode(state.uplink))
--   end

--   if state.data_in.reported == nil then
--     state.data_in = convertState(state.data_in)
--   else
--     state.data_in.reported = convertState(state.data_in.reported)
--     state.data_in.set = convertState(state.data_in.set)
--   end

--   return state
-- end

return transform

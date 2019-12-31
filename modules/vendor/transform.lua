local transform = {}

-- Below an example of transforming the GPS data values

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

--   if state.data_in.reported == nil then
--     state.data_in = convertState(state.data_in)
--   else
--     state.data_in.reported = convertState(state.data_in.reported)
--     state.data_in.set = convertState(state.data_in.set)
--   end

--   return state
-- end

return transform

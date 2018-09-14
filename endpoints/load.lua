--#ENDPOINT GET /hello
return "Hello world!"

--#ENDPOINT GET /load
return "Hello world!"

--#ENDPOINT GET /print
-- Query Parameters count=1
for i = 1, request.parameters.count or 1 do
  print("Hello world!" .. i)
end

--#ENDPOINT GET /wait
-- Query Parameters sec=1
-- Currently not clean way: either need a Lua 'sleep' function or a dedicated service call. Timer.wait()
local clock = os.clock
local n = request.parameters.sec or 1
local ntime = clock() + n
repeat until clock() > ntime

--#ENDPOINT GET /busy
-- Query Parameters sec=1
local clock = os.clock
local n = request.parameters.sec or 1
local ntime = clock() + n
while clock() < ntime do end

--#ENDPOINT GET /load/{service}/{operation}
-- Query parameters: args, count=1
local service = request.parameters.service
local operation = request.parameters.operation
local args = request.parameters.args and from_json(request.parameters.args)
for i = 1, request.parameters.count or 1 do
  result = murano.service_call(service, operation, args)
  if result and result.error then
    response.code = result.status
    return result.error
  end
end

return request.parameters.count or 1

--#ENDPOINT POST /load/{service}/{operation}
-- Query parameters: count=1
-- Body payload: service args in application/json format
local service = request.parameters.service
local operation = request.parameters.operation
for i = 1, request.parameters.count or 1 do
  result = murano.service_call(service, operation, request.body)
  if result and result.error then
    return result.error
  end
end

return request.parameters.count or 1

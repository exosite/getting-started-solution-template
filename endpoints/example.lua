-- File containing Webservice http endpoints
--#ENDPOINT POST /api/user text/plain
-- A lua handler for this endpoint, doc: http://docs.exosite.com/reference/services/webservice/#request
return "new-user-id"

--#ENDPOINT GET /api/summary/user/{userId}
--#TAGS user public
--#SUMMARY api to get user
--#DESCRIPTION this is an api to get user by userId
print("Fetch a given user" .. request.parameters.userId)
return {id=request.parameters.userId}  -- json by default

--#ENDPOINT GET /api/user/{userId}
--#TAGS user public
print("Fetch a given user" .. request.parameters.userId)
return {id=request.parameters.userId}  -- json by default

--#ENDPOINT GET /api/ratelimit/withauth
--#TAGS security
--#SECURITY basic bearer
--#RATELIMIT 1
print("This endpoint needs a basic or bearer auth and " ..
"has a rate limit 1 per minute, per authentication credentials. " ..
"If no credentials is provided by user a 401 status code is returned.")
return 'OK'

--#ENDPOINT GET /api/noauthnolimit
--#SECURITY none
--#RATELIMIT 0
print("Authentication and RateLimit are explicitly deactivated " ..
"for this endpoint regardless of the API configuration.")
return 'OK'

--#ENDPOINT GET /api/ratelimit
--#RATELIMIT 1
print("No security defined, uses to the API default settings. " ..
"If none defined, the ratelimit will be per the client Ip Address.")
return 'OK'
-- oef

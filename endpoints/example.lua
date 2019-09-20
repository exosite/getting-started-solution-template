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
-- oef

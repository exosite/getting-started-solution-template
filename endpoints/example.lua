-- File containing Webservice http endpoints
--#ENDPOINT POST /api/user text/plain
-- A lua handler for this endpoint, doc: http://docs.exosite.com/reference/services/webservice/#request
return "new-user-id"

--#ENDPOINT GET /api/user/{userId}
--#TAGS user public
print("Fetch a given user" .. request.parameters.userId)
return {id=request.parameters.userId}  -- json by default


--#ENDPOINT GET /test/slash text/plain
return "slash test"
-- oef

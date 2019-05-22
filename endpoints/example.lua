--#ENDPOINT POST /api/user text/plain
-- a lua handler for this endpoint
return "new-user-id"

--#ENDPOINT GET /api/user/{userId}
--#TAGS user public
print("Fetch a given user" .. request.parameters.userId)
return {id=request.parameters.userId}  -- json by default

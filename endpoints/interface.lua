--#ENDPOINT GET /test/interface
-- Test endpoint for subscribers communication through interface service
-- This call will send an event 'myEvent' to all subscriber solutions
-- The 'myEvent' event MUST be defined in the interface.yaml configuration events.
-- Doc http://docs.exosite.com/reference/services/interface/#trigger
return Interface.trigger({
  mode = "sync",
  event = "myEvent",
  data = "hello"
})

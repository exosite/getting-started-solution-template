-- Handling of related operation defined in the ./interface.yaml file exposed to subscribers.
-- This script is triggered when a subscriber calls <my service id>.myOp({message: ".."})

print("Subscriber " .. context.caller_id .. " says " .. event.message)

-- You can also do some asyncronous job by trigging an asynchronous thread and reply by sending an event
-- This will trigger the ../scripts_asyncJob.lua script
Scripts.trigger({
  event="asyncJob",
  mode="async",
  data={
    to=context.caller_id
  }
})

return "Sync reply" -- response to the subscriber

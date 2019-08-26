-- Custom event function, primarily used to do asyncronous handling
-- Here called by ./interface/myOps.lua
-- This script is enabled by default on all solution and doesnt requires special configuration
-- More info: http://docs.exosite.com/reference/services/scripts

if data and data.to then
  -- .. do some processing ..

  -- Here do the async reply to the message from the custom operation defined at
  -- ./interface/myOp.lua
  Interface.triggerOne({
    target=data.to,
    -- This event must be defined in the interface.yaml definition.
    event="myEvent",
    data="Async reply"
  })
end

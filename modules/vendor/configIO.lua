-- This module handle 'configIO' metadata generation for Exosense applications
-- Define here the device data schema as describe in https://github.com/exosite/industrial_iot_schema
-- Limitation: Exosense currently cannot modify per device schema
--
-- This file is in the 'vendor' safeNamespace and changes will persists upon template updates

-- The config_io is automatically generated from the Sigfox structure.
-- You can here define FIXED CUSTOM channels which will be ADDED to the generated ones.
-- Custom channel must be set from the module `vendor.stransform`.
-- IMPORTANT: once this file is udpated you MUST save the Sigfox service settings again
-- Under Services -> Sigfox and hit 'apply'

-- local config_io = [[
--  {
--   -- "channels": {
--   --   "sum_ab": {
--   --     "display_name": "SUM A + B",
--   --     "description": "A virtual channel generated on the fly in module 'vendor.transform'",
--   --     "properties": {
--   --       "data_type": "NUMBER",
--   --       "primitive_type": "NUMBER"
--   --     }
--   --   }
--   -- }
-- }
-- ]]
--
-- return {
--   config_io = config_io
-- }

return nil -- by default use the generated configIO

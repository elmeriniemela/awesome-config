--[[

     Lain
     Layouts, widgets and utilities for Awesome WM

     Utilities section

     Licensed under GNU General Public License v2
      * (c) 2013,      Luca CPZ
      * (c) 2010-2012, Peter Hofmann

--]]

local awful        = require("awful")
local sqrt         = math.sqrt
local pairs        = pairs
local client       = client
local tonumber     = tonumber
local wrequire     = require("lain.helpers").wrequire
local setmetatable = setmetatable

-- Lain utilities submodule
-- lain.util
local util = { _NAME = "lain.util" }


return setmetatable(util, { __index = wrequire })

#!/usr/bin/env lua

LU = require 'luaunit'

require 'tests.test_main'
require 'tests.test_state'

LU.LuaUnit.verbosity = 2
os.exit(LU.run())

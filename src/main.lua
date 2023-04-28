--[[
 PICO-8 SETUP | Felipe Izolan | 2023 
 **SET PICO.EXE PATH IN MAKEFILE!**
]]

require("lib.my_module")

function _draw()
  cls()
  local aVeryBigAndCoolLocalVariableName=true

  print(message,64-(#message*2),64,11)
  print(aVeryBigAndCoolLocalVariableName,8)
end

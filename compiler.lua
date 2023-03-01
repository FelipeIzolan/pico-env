CART_PATH = "./game.p8"
SCRIPT_PATH = "./main.lua"

local cart = io.open(CART_PATH, "r")
local script = io.open(SCRIPT_PATH)

if cart and script then
  local cart_source = cart:read("*a")
  local script_source = script:read("*a")

  cart:close()
  script:close()

  local __lua__ = string.find(cart_source, "__lua__")
  local __gfx__ = string.find(cart_source, "__gfx__") - 1

  local p1
  local p2 = string.sub(cart_source, __gfx__)

  if not __lua__ then
    p1 = string.sub(cart_source, 0, __gfx__)
    script_source = "__lua__\n" .. script_source
  else
    p1 = string.sub(cart_source, 0, __lua__ + 7)
  end

  local output = p1 .. script_source .. p2
  local writer = io.open(CART_PATH, "w")

  if writer then
    writer:write(output)
    writer:close()
  end
end

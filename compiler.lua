Diet = require("luasrcdiet.main")

CART_PATH = "./game.p8"
SCRIPT_PATH = "./src/main.lua"
RELATIVE_PATH = "./src/"

PATTERNs = {
  Q = "…",
  W = "∧",
  E = "░",
  R = "➡️",
  T = "⧗",
  Y = "▤",
  U = "⬆️",
  I = "☉",
  O = "🅾️",
  P = "◆",
  A = "█",
  S = "★",
  D = "⬇️",
  F = "✽",
  G = "●",
  H = "♥",
  J = "웃",
  K = "⌂",
  L = "⬅️",
  Z = "▥",
  X = "❎",
  C = "🐱",
  V = "ˇ",
  B = "▒",
  N = "♪",
  M = "😐"
}

local cart = io.open(CART_PATH, "r")
local script = io.open(SCRIPT_PATH)

if cart and script then
  local cart_source = cart:read("*a")
  local main = script:read("*a")
  local module_source = {}

  cart:close()
  script:close()

  main:gsub(
    "require%(%p[%w|%p]+%p%)",
    function (m)
      -- extract path.
      local p = m:sub(10,#m-2)

      -- remove "require()" line.
      local _,e = main:find(p)
      main = main:sub(e + 3)

      -- transform path to io.open().
      p = RELATIVE_PATH .. p:gsub("%.+", "/") .. ".lua"

      local r = io.open(p, "r")
      if r then
        table.insert(module_source, r:read("*a"))
        r:close()
      end
    end
  )

  -- separates in parts .p8 structure.
  local __lua__ = cart_source:find("__lua__")
  local __gfx__ = cart_source:find("__gfx__") - 1

  local p1
  local p2 = string.sub(cart_source, __gfx__)

  -- add .p8 code block, if it not exist.
  if not __lua__ then
    p1 = string.sub(cart_source, 0, __gfx__)
    p1 = p1 .. "__lua__\n"
  else
    p1 = string.sub(cart_source, 0, __lua__ + 7)
  end

  local output = ""

  -- append all module.
  for _,value in ipairs(module_source) do
    output = output .. value .. "\n"
  end


  output = Diet.optimize(Diet.MAXIMUM_OPTS,output..main)
  output = p1 .. output .. p2

  for key,pattern in pairs(PATTERNs) do
    output = output:gsub("'"..key.."'", '"'..pattern..'"')
    output = output:gsub('"'..key..'"', '"'..pattern..'"')
  end

  -- write cartridge!
  local writer = io.open(CART_PATH, "w")

  if writer then
    writer:write(output)
    writer:close()
  end
end

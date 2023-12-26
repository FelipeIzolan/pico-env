Minifier = require("minifier")

REQUIRE_PATTERN = "require[%s]?[%(]?%p[%w|%.|_]+%p[%)]?"
REQUIRE_CAPTURE_PATTERN = "require[%s]?[%(]?[%p]([%w|%.|_]+)[%p][%)]?"

SRC_PATH = "./src/"
CART_PATH = "./game.p8"
SCRIPT_PATH = SRC_PATH .. "main.lua"

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

local modules = {}
local cart = io.open(CART_PATH):read("*a")
local main = io.open(SCRIPT_PATH):read("*a")
local output = ""

function find(arr, value)
  for _,v in ipairs(arr) do
    if value == v then return true end
  end

  return false
end

-- MODULES

function extract(m)
  m = m:match(REQUIRE_CAPTURE_PATTERN) -- remove require and quotes;
  m = m:gsub("%.+", "/")
  m = m .. ".lua"
  m = SRC_PATH .. m

  return m
end

function callback(m)
  local module = extract(m)
  local source = io.open(module):read("*a")

  source:gsub(REQUIRE_PATTERN, callback)
  if not find(modules, module) then
    table.insert(modules, module)
    output = output .. source:gsub(REQUIRE_PATTERN, "")
  end
end

main:gsub(REQUIRE_PATTERN, callback)

output = output .. main:gsub(REQUIRE_PATTERN, "")
output = Minifier(output)
print(output)

-- WRITE CARTRIDGE

-- local __lua__ = cart:find("__lua__")
-- local __gfx__ = cart:find("__gfx__") - 1

-- local p1 = cart:sub(0, __lua__+7)
-- local p2 = cart:sub(__gfx__)

-- for key,pattern in pairs(PATTERNs) do
--   output = output:gsub(key, pattern)
-- end

-- io.open(CART_PATH, "w"):write(p1..output..p2)

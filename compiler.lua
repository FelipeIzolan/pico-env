Diet = require("luasrcdiet.main")

REQUIRE_REGEX = "require[%s]?[%(]?%p[%w|%p]+%p[%)]?"
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
  local _first_quote = m:find("[\"|\']")+1
  local _last_quote = m:find("[\"|\']", _first_quote)-1
  local module = m:sub(_first_quote,_last_quote) -- remove require and quotes;

  module = module:gsub("%.+", "/")
  module = module .. ".lua"
  module = RELATIVE_PATH .. module

  return module
end

function callback(m)
  local module = extract(m)
  local source = io.open(module):read("*a")

  source:gsub(REQUIRE_REGEX, callback)

  if not find(modules, module) then
    table.insert(modules, module)
    output = output .. source:gsub(REQUIRE_REGEX,"")
  end
end

main:gsub(REQUIRE_REGEX, callback)
output = output .. main:gsub(REQUIRE_REGEX, "")
output = Diet.optimize(Diet.MAXIMUM_OPTS,output)

-- WRITE CARTRIDGE

local __lua__ = cart:find("__lua__")
local __gfx__ = cart:find("__gfx__") - 1

local p1 = cart:sub(0, __lua__+7)
local p2 = cart:sub(__gfx__)

for key,pattern in pairs(PATTERNs) do
  output = output:gsub(key, pattern)
end

io.open(CART_PATH, "w"):write(p1..output..p2)

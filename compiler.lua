local req = "require%s?%(?%s*[\'\"][%w%._]+[\'\"]%s*%)?"
local req_match = "require%s?%(?%s*[\'\"]([%w%._]+)[\'\"]%s*%)?"
local upper2symbol = {
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

local main = io.open("./src/main.lua"):read("*a")
local output = ""

-- get modules -------------------------------------------------------------------
local map = {}
local modules = {}
function list(str)
  for path in string.gmatch(str, req_match) do
    if not map[path] then
      map[path] = true
      local path = './src/' .. path:gsub('%.', '/') .. '.lua'
      local src = io.open(path):read("*a")
      list(src)
      table.insert(modules, src)
    end
  end
end

list(main)
-- build output ------------------------------------------------------------------
for _, value in ipairs(modules) do
  local module = value:gsub(req, '')
  output = output .. module .. '\n'
end
output = output .. main:gsub(req, '')
for key, pattern in pairs(upper2symbol) do
  output = output:gsub(key, pattern)
end
-- create script.lua -------------------------------------------------------------
io.open("./out/code.lua", 'w'):write(output)
----------------------------------------------------------------------------------

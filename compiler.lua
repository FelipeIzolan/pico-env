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

local output = io.open("./src/main.lua"):read("*a")

-- resolve modules ---------------------------------------------------------------
local map = {}
local req = "require%s?%(?%s*[\'\"][%w%._]+[\'\"]%s*%)?"
local reqm = "require%s?%(?%s*[\'\"]([%w%._]+)[\'\"]%s*%)?"
function resolve(str)
  for path in string.gmatch(str, reqm) do
    if not map[path] then
      map[path] = true
      local file = './src/' .. string.gsub(path, '%.', '/') .. '.lua'
      local src = io.open(file):read("*a")
      src = resolve(src)
      str = string.gsub(str, req, src, 1)
    else
      str = string.gsub(str, req, "", 1)
    end
  end
  return str
end

output = resolve(output)
-- replace uppercase to symbol ---------------------------------------------------
for key, pattern in pairs(upper2symbol) do
  output = string.gsub(output, key, pattern)
end
-- create code.lua ---------------------------------------------------------------
io.open("./out/code.lua", 'w'):write(output)
----------------------------------------------------------------------------------

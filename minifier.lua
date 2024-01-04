--   _   _ _____ ___ _    ___ 
--  | | | |_   _|_ _| |  / __|
--  | |_| | | |  | || |__\__ \
--   \___/  |_| |___|____|___/
-- quoted(t, pt) -> returns start/end of quoted pattern.
-- trim(s) -> removes whitespace from both sides.
-- unspace(line, pt) -> removes whitespace between the pattern.
-- unspace_comma(line) -> same as unspace(line, pt) but specific to comma(,).

function quoted(t, pt)
  return t:find("[\"|\'.+]![\"|\'].+".. pt .. ".+[\"|\']")
end

function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function unspace(line, pt)
  local s = quoted(line, pt)

  if s then
    return line
  else
    local v = table.pack(pt:gsub(pt == "%%" and "" or "%%", ""))[1]
    return line:gsub("%s+" .. pt, v):gsub(pt .. "%s+", v)
  end
end

--   ___ ___  __  __ __  __ ___ _  _ _____ ___ 
--  / __/ _ \|  \/  |  \/  | __| \| |_   _/ __|
-- | (_| (_) | |\/| | |\/| | _|| .` | | | \__ \
--  \___\___/|_|  |_|_|  |_|___|_|\_| |_| |___/
-- comment(line) -> remove comment.
-- comment_block(line) -> remove comment-block.

IS_COMMENT_BLOCK = false

function comment(line)
  local _, e1 = quoted(line, "%-%-")
  local _start = line:find("%-%-", e1)

  if _start then
    line = line:sub(0, _start-1)
  end

  return line
end


function comment_block(line)
  local _, e1 = quoted(line, "%-%-%[%[")
  local _start = line:find("%-%-%[%[", e1)
  local _end = line:find("%]%]", e1)

  if _start then
    line = line:sub(0, _start-1)
    if not _end then IS_COMMENT_BLOCK = true end
  end

  return line
end

function resolve_comment_block(line)
  if line:find("%]%]") then
    IS_COMMENT_BLOCK = false
  end
end

--   __  __   _   ___ _  _ 
--  |  \/  | /_\ |_ _| \| |
--  | |\/| |/ _ \ | || .` |
--  |_|  |_/_/ \_\___|_|\_|

return function (src)
  local iterator = src:gmatch("(.-)\n")
  local lines = {}

  for line in iterator do
    -- comments
    if IS_COMMENT_BLOCK then resolve_comment_block(line); goto continue end
    if line:find("%-%-") and not line:find("%-%-%[%[") then line = comment(line) end
    if line:find("%-%-%[%[") then line = comment_block(line) end

    --
    if line:find("%s+=%s+")  then line = unspace(line, "=")  end
    if line:find("%s+%.%.%s+") then line = unspace(line, "%.%.") end
    if line:find(",") then line = unspace(line, ",") end
    if line:find("{%s+") then line = unspace(line, "{") end
    if line:find("%s+}") then line = unspace(line, "}") end

    -- arithmetic
    if line:find("%s+%+%s+") then line = unspace(line, "%+") end
    if line:find("%s-%-%s-") then line = unspace(line, "%-") end
    if line:find("%s+%*%s+") then line = unspace(line, "%*") end
    if line:find("%s+%/%s+") then line = unspace(line, "%/") end
    if line:find("%s+%%%s+") then line = unspace(line, "%%") end
    if line:find("%s+%^%s+") then line = unspace(line, "%^") end

    -- relational
    if line:find("%s+==%s+") then line = unspace(line, "==") end
    if line:find("%s+~=%s+") then line = unspace(line, "~=") end
    if line:find("%s+>%s+")  then line = unspace(line, ">")  end
    if line:find("%s+<%s+")  then line = unspace(line, "<")  end
    if line:find("%s+>=%s+") then line = unspace(line, ">=") end
    if line:find("%s+<=%s+") then line = unspace(line, "<=") end

    line = trim(line)
    line = line:gsub("%s+", " ")

    if line == "" then goto continue end
    table.insert(lines, line)

    ::continue::
  end

  return table.concat(lines, "\n")
end

--   _   _ _____ ___ _    ___ 
--  | | | |_   _|_ _| |  / __|
--  | |_| | | |  | || |__\__ \
--   \___/  |_| |___|____|___/

function quoted(t, pt)
 return t:find("\".+".. pt .. ".+\"")
end

--   ___ ___  __  __ __  __ ___ _  _ _____ ___ 
--  / __/ _ \|  \/  |  \/  | __| \| |_   _/ __|
-- | (_| (_) | |\/| | |\/| | _|| .` | | | \__ \
--  \___\___/|_|  |_|_|  |_|___|_|\_| |_| |___/

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

--  __   ___   ___ ___   _   ___ _    ___ ___ 
--  \ \ / /_\ | _ \_ _| /_\ | _ ) |  | __/ __|
--   \ V / _ \|   /| | / _ \| _ \ |__| _|\__ \
--    \_/_/ \_\_|_\___/_/ \_\___/____|___|___/

function _local()

end

return function (src)
  local iterator = src:gmatch("(.-)\n")
  local lines = {}

  for line in iterator do
    -- comment
    if IS_COMMENT_BLOCK then resolve_comment_block(line); goto continue end
    if line:find("%-%-") and not line:find("%-%-%[%[") then line = comment(line); end
    if line:find("%-%-%[%[") then line = comment_block(line); end

    if line == "" then goto continue end
    table.insert(lines, line)

    ::continue::
  end

  return table.concat(lines, "\n")
end

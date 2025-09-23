# pico8-env

pico8-env is an environment to develop games to [pico8](https://www.lexaloffle.com/pico-8.php).

## 🚀 Getting Started

```
git clone https://github.com/FelipeIzolan/pico8-env.git
```

- Edit PICO8 in Makefile
- Write your game in /src
- ```make debug```

## 📜 Makefile

- debug - compile and run the cartridge.
- compile - compile the cartridge.
- load - load the cartridge.

## 📦 Modules 

before compiler:
```lua
-- math.lua
function area2d(x, y)
    return x * y
end
```

```lua
-- main.lua

require ("lib.math")

function _draw()
    print("area(10,2): " .. tostr(area2d(10,2)))
end
```

after compiler:

```lua
function area2d(x, y)
    return x * y
end

function _draw()
    print("area(10,2): " .. tostr(area2d(10,2)))
end
```

## Pico8 Pattern 🐱

before compiler:
```lua
function _draw()
    fillp("C")
    circfill(32,32,8,9)
end
```

after compiler:
```lua
function _draw()
    fillp("🐱")
    circfill(32,32,8,9)
end
```

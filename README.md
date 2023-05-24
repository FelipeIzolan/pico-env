# pico8-setup

pico8-setup is a environment to develop games to [pico8](https://www.lexaloffle.com/pico-8.php).

## Getting Started 🚀

```
git clone https://github.com/FelipeIzolan/pico8-setup.git
```

- Edit PICO8 in Makefile
- Write your game in /src
- ```make debug```

## Makefile 🪧

- debug - compile and run the cartridge.

- compile - compile the cartridge.

- load - load the cartridge.

---

### Pico8 Pattern 🐱

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

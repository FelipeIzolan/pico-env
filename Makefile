PICO8 := path\to\pico-8\pico8.exe

load:
	$(PICO8) "./game.p8"

compile: 
	lua compiler.lua

debug:
	lua compiler.lua && $(PICO8) -run "./game.p8"

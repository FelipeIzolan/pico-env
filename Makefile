PICO8 := pico8

load:
	$(PICO8) "./out/game.p8"

compile: 
	lua compiler.lua

debug:
	lua compiler.lua && $(PICO8) -run "./out/game.p8"

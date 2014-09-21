#NoEnv
SendMode Input
SetKeyDelay, 20, 20
SetControlDelay 50
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen

f3::
start()
return

f2::
Reload
return

f4::
;MsgBox % cargoFull()
controlclick, X190 Y190, EVE, R, , , NA
return

start(){
	loop{
		if(cargoFull())
			mineTillFull()
		else if(cargoEmpty())
			dumpOreOff()
	}
}

mineTillFull(){
	while(!cargofull()){
		travelToOre()
		mine()
	}
}

travelToOre(){
	controlclick, , EVE, R, , , NA X190 Y200
	sleap(2)
	controlclick, , EVE, , , , NA X220 Y200
	sleap(20)
}

travelToArray(){
	controlclick, , EVE, R, , , NA X190 Y190
	sleap(2)
	controlclick, , EVE, , , , NA X220 Y190
	sleap(20)
}

mine(){
	controlsend, , {f1}{f2}{f3}, EVE
	controlclick, , EVE, , , , NA X1600 Y210
}

dumpOreOff(){
	travelToArray()
}

cargoFull(){
	WinGetPos, winx, winy, winw, winh, EVE 
	PixelGetColor, c, % winx+450, % winy+865
	SplitBGRColor(c,red,grn,blu)
	return, % blu > 60
}

cargoEmpty(){
	WinGetPos, winx, winy, winw, winh, EVE 
	PixelGetColor, c, % winx+182, % winy+865
	SplitBGRColor(c,red,grn,blu)
	return, % blu < 60
}

sleap(sec){
	sleep, 1000
	sec--
	WinGetPos, winx, winy, winw, winh, EVE
	Loop, %sec%{
		random, randtime, 820,1279
		if(mod(a_index,15) = 0){
			Random, randx, % winx+100, % winx + winw-100
			Random, randy, % winy+100, % winy + winh-100
			;movemouse(randx, randy)
		}
		Sleep, %randtime%
	}
}

SplitBGRColor(BGRColor, ByRef Red, ByRef Green, ByRef Blue){
    Red := BGRColor & 0xFF
    Green := BGRColor >> 8 & 0xFF
    Blue := BGRColor >> 16 & 0xFF
}
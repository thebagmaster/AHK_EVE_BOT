#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetKeyDelay, 5, 5
SetControlDelay 5
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen

belts:=10
sleep, 1000

f9::
	belti:=1
	nomas:=false
	silent:=false
	gosub, mine
return

mine:
;	OVtab(3)
;	if(belts = 0){
;		belts := countOVitems()
;	}
	while(belti < belts){
		winmove,EVE,,0,0
		checkiflogged()
		gosub, minebelt
		if(nomas){
			belti++
			nomas:=false
		}
		gosub, dock
		gosub, undock
	}
return

undock:
	WinGetPos, winx, winy, winw, winh, EVE 
	dockbutx := winx+10
	dockbuty := winy+winh-40
	while(docked()){
		if(!silent)
			WinActivate, EVE 
		movemouse(dockbutx,dockbuty)
		if(silent)
			controlclick,,EVE,,,2,% "NA x" dockbutx " y" dockbuty
		else
			send {click 2}
		sleap(12)
	}
return

minebelt:
	OVtab(3)
	movemousetoOVindex(belti,x,y)
	if(silent)
		controlclick,,EVE,,RIGHT,,% "NA x" x " y" y
	else
		send {click R}
	sleap(2)
	if(silent)
		controlclick,,EVE,,,,% "NA x" x " y" y
	else
		send {click}
	OVtab(1)
	sleap(2)
	loop, 10{
		if(countOVitems() != 0)
			break
		sleap(10)
	}
	sleap(10)
	activateAfterburner()
	if(countOVitems() = 0){
		nomas:=true
		return
	}else
		gosub, minetillfull
return

minetillfull:
	while(!cargofull()){
		if(countOVitems() = 0){
			nomas:=true
			return
		}
		if(anylasersoff())
			gosub, moveinrange
		lasers(true)
		sleap(2)
		movemousetoOVindex(0,x,y)
		if(silent)
			controlclick,,EVE,,,,% "NA x" x " y" y
		else
			send {click}
		sleap(5)
		if(anylasersoff()){
			if(lostTarget()){
				lasers(false)
				continue
			}else
				lasers(true)
		}
		waitformine:
		sleap(20)
		if(anylasersoff()){
			if(lostTarget()){
				lasers(false)
				continue
			}else
				lasers(true)
		}
		if(!cargofull())
			goto, waitformine
	}
return

moveinrange:
	movemousetoOVindex(0,x,y)
	if(silent)
		controlclick,,EVE,,,10,% "NA x" x " y" y
	else{
		send {click 4}
		sleep, 100
		send {w down}
		sleep, 100
		send {click}
		sleep, 100
		send {w up}
	}
	sleap(5)
	movemousecenter()
	waituntilinrange()
return

dock:
	while(!docked()){
		OVtab(2)
		;movemousetoOVindex(0,x,y)
		movemousecenter()
		WinGetPos, winx, winy, winw, winh, EVE 
		Imagesearch, imgx, imgy, %winx%, %winy%, % winx+winw, % winy+winh, station.bmp
		imgy+=10
		x:=imgx
		y:=imgy
		movemouse(x,y)
		if(silent)
			controlclick,,EVE,,RIGHT,,% "NA x" x " y" y
		else
			send {click R}
		sleap(2)
		Imagesearch, imgx, imgy, %winx%, %winy%, % winx+winw, % winy+winh, dock.bmp
		movemouse(imgx,imgy+4)
		if(silent)
			controlclick,,EVE,,,,% "NA x" x " y" y+55
		else
			send {click}
		if(!docked())
			sleap(34)
		if(!docked())
			sleap(34)
		if(!docked())
			sleap(34)
	}
	gosub, storeitems

return

storeitems:
	while(!cargoempty() and docked()){
		openInventory()
		openorehold()
		WinGetPos, winx, winy, winw, winh, EVE 
		Imagesearch, imgx, imgy, %winx%, %winy%, % winx+winw, % winy+winh, orehold.bmp
		if(!errorlevel){
			random, ex, % imgx+20, % imgx+120
			movemouse(ex,imgy+86)
			send {click down}
			random, ex, % imgx+20, % imgx+120
			movemouse(ex,imgy-90)
			send {click up}
		}
		sleap(2)
	}
return

movemouse(x,y){
	global silent
	if(!silent)
		WinActivate, EVE 
	MouseGetPos, curx, cury
	devx := round((abs(x-curx)/2))
	devy := round((abs(y-cury)/2))
	Loop{
		adx := round(0.3*abs(devx - abs(devx-abs(curx-x)))+1)
		ady := round(0.3*abs(devy - abs(devy-abs(cury-y)))+1)
		if(x < curx) 
			curx-=adx
		if(x > curx) 
			curx+=adx
		if(y < cury)
			cury-=ady
		if(y > cury)
			cury+=ady
		if(abs(x-curx)<3 and abs(y-cury)<3)
			break
		if(silent)
			controlclick,,EVE,,,0,% "NA x" curx " y" cury
		else
			MouseMove, curx, cury
		random, rnd, 20, 60
		sleep, %rnd%		
	}
	;MouseMove, x, y
}

OVtab(t){
	global silent
	WinGetPos, winx, winy, winw, winh, EVE 
	Imagesearch, imgx, imgy, %winx%, %winy%, % winx+winw, % winy+winh, overview.bmp
	if(!silent)
		WinActivate, EVE 
	if(t=1)
		movemouse(imgx+20,imgy+20)
	if(t=2)
		movemouse(imgx+60,imgy+20)
	if(t=3)
		movemouse(imgx+100,imgy+20)
	x:=imgx+(t-1)*40+20
	y:=imgy+20
	if(silent)
		controlclick,,EVE,,,2,% "NA x" x " y" y
	else
		send {click 2}
}

movemousecenter(){
	WinGetPos, winx, winy, winw, winh, EVE 
	movemouse(winx+winw/2,winy+winh/2)
}

countOVitems(){
	WinGetPos, winx, winy, winw, winh, EVE 
	Imagesearch, imgx, imgy, %winx%, %winy%, % winx+winw, % winy+winh, overview.bmp
	movemousecenter()
	getx := imgx+10
	gety := imgy+70
	PixelGetColor, bg, %getx%, %gety%
	PixelGetColor, bg2, % getx, % gety+1
	SplitBGRColor(bg,red,grn,blu)
	SplitBGRColor(bg2,red2,grn2,blu2)
	dev := 8
	cnt := 0
	while(gety < (winy+winh-10)){
		PixelGetColor, tst, %getx%, %gety%
		;msgbox, % tst " " gety
		if(tst = 0x626262 or tst = 0x898989){
			cnt++
			foundit := gety
		}
		if(gety > 19+foundit and foundit > 0)
			return cnt
		gety++
	}
	return cnt
}

movemousetoOVindex(ind, ByRef x, ByRef y){
	WinGetPos, winx, winy, winw, winh, EVE 
	Imagesearch, imgx, imgy, %winx%, %winy%, % winx+winw, % winy+winh, overview.bmp
	random, ex, % imgx+100, % imgx+150
	movemouse(ex,imgy+63+ind*19)
	x:=ex
	y:=(imgy+63+ind*19)
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
			movemouse(randx, randy)
		}
		checkiflogged()
		Sleep, %randtime%
	}
}

waituntilinrange(){
	WinGetPos, winx, winy, winw, winh, EVE 
	Imagesearch, imgx, imgy, %winx%, %winy%, % winx+winw, % winy+winh, km.bmp
	while(errorlevel = 0){
		sleap(8)
		Imagesearch, imgx, imgy, %winx%, %winy%, % winx+winw, % winy+winh, km.bmp
	}
}

lostTarget(){
	WinGetPos, winx, winy, winw, winh, EVE 
	Imagesearch, imgx, imgy, %winx%, %winy%, % winx+winw, % winy+winh, lost.bmp
	return, % !errorlevel
}

SplitBGRColor(BGRColor, ByRef Red, ByRef Green, ByRef Blue){
    Red := BGRColor & 0xFF
    Green := BGRColor >> 8 & 0xFF
    Blue := BGRColor >> 16 & 0xFF
}

anylasersoff(){
	WinGetPos, winx, winy, winw, winh, EVE 
	PixelGetColor, c1, % winx+620, % winy+678
	PixelGetColor, c2, % winx+671, % winy+678
	PixelGetColor, c3, % winx+722, % winy+678
	SplitBGRColor(c1,red,grn,blu)
	SplitBGRColor(c2,red2,grn2,blu2)
	SplitBGRColor(c3,red3,grn3,blu3)
	return, % !(blu>160 and blu2>160 and blu3>160)
}

lasers(make){
	WinGetPos, winx, winy, winw, winh, EVE 
	PixelGetColor, c1, % winx+620, % winy+678
	PixelGetColor, c2, % winx+671, % winy+678
	PixelGetColor, c3, % winx+722, % winy+678
	SplitBGRColor(c1,red,grn,blu)
	SplitBGRColor(c2,red2,grn2,blu2)
	SplitBGRColor(c3,red3,grn3,blu3)
	WinActivate, EVE 
	if((!make and blu>160)or(make and blu<160))
		send {f1}
	if((!make and blu2>160)or(make and blu2<160))
		send {f2}
	if((!make and blu3>160)or(make and blu3<160))
		send {f3}
}

cargofull(){
	openorehold()
	WinGetPos, winx, winy, winw, winh, EVE 
	PixelGetColor, c, % winx+253, % winy+702
	SplitBGRColor(c,red,grn,blu)
	;msgbox, % abs(blu-77) " " abs(grn-63)
	;return, % (abs(blu-77)<40 and abs(grn-63)<25)
	return, % blu > 60
}

cargoempty(){
	openorehold()
	WinGetPos, winx, winy, winw, winh, EVE 
	PixelGetColor, c, % winx+52, % winy+702
	SplitBGRColor(c,red,grn,blu)
	;msgbox % abs(blu-77) " " abs(grn-63)
	return, % blu < 60
}

docked(){
	WinGetPos, winx, winy, winw, winh, EVE 
	Imagesearch, imgx, imgy, %winx%, %winy%, % winx+winw, % winy+winh, docked.bmp
	return, % !errorlevel
}

openinventory(){
	global silent
	WinGetPos, winx, winy, winw, winh, EVE 
	Imagesearch, imgx, imgy, %winx%, %winy%, % winx+winw, % winy+winh, inventory.bmp
	while(errorlevel){
		if(!silent)
			WinActivate, EVE 
		sleap(1)
		if(silent)
			controlsend,,{ralt down},EVE
		else
			send, {ralt down}
		sleap(1)
		if(silent)
			controlsend,,{c},EVE
		else
			send, {c}
		sleap(1)
		if(silent)
			controlsend,,{ralt up},EVE
		else
			send, {ralt up}
		sleap(2)
		Imagesearch, imgx, imgy, %winx%, %winy%, % winx+winw, % winy+winh, inventory.bmp
	}
}

openorehold(){
	global silent
	WinGetPos, winx, winy, winw, winh, EVE 
	Imagesearch, imgx, imgy, %winx%, %winy%, % winx+winw, % winy+winh, orehold.bmp
	while(errorlevel){
		if(!silent)
			WinActivate, EVE 
		sleap(1)
		if(silent)
			controlsend,,{ralt down},EVE
		else
			send, {ralt down}
		sleap(1)
		if(silent)
			controlsend,,{p},EVE
		else
			send, {p}
		sleap(1)
		if(silent)
			controlsend,,{ralt up},EVE
		else
			send, {ralt up}
		sleap(2)
		Imagesearch, imgx, imgy, %winx%, %winy%, % winx+winw, % winy+winh, orehold.bmp
	}
}

activateAfterburner(){
	;WinActivate, EVE 
	;send, !{f1}
}

connlost(){
	WinGetPos, winx, winy, winw, winh, EVE 
	Imagesearch, imgx, imgy, %winx%, %winy%, % winx+winw, % winy+winh, connlost.bmp
	return, % !errorlevel
}

atlogin(){
	WinGetPos, winx, winy, winw, winh, EVE 
	Imagesearch, imgx, imgy, %winx%, %winy%, % winx+winw, % winy+winh, conn.bmp
	return, % !errorlevel
}

clickrestart(){
	sleep, 2000
	while(connlost()){
		movemouse(imgx+110,imgy+185)
		send {click 3}
		sleep, 3000
	}
}

logintochar(){
	while(atlogin()){
		WinActivate, EVE
		movemouse(569,741)
		send {click 2}
		sleep, 2000
		setkeydelay, 100,50
		send {end}{backspace 50}1nternetT{enter}
		sleep, 20000
	}
}

logintogame(){
	WinGetPos, winx, winy, winw, winh, EVE 
	Imagesearch, imgx, imgy, %winx%, %winy%, % winx+winw, % winy+winh, skull.bmp
	while(!errorlevel){
		sleep, 2000
		send {enter}
		sleep, 10000
		Imagesearch, imgx, imgy, %winx%, %winy%, % winx+winw, % winy+winh, skull.bmp
	}
}

resumegame(){
	sleap(40)
	openorehold()
	gosub, dock
	gosub, undock
	belti:=0
	gosub, mine
}

checkiflogged(){
	ifwinexist, Sponsored session
		winclose
	if(connlost())
		clickrestart()
	if(atlogin()){
		logintochar()
		logintogame()
		resumegame()
	}
}

f4::
	Reload
return

f6::
	;msgbox % losttarget()
	;gosub, storeitems
	;openorehold()
	checkiflogged()
return
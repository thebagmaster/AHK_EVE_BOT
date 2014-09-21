SetKeyDelay, 250
SetDefaultMouseSpeed, 10
global station := 9
global locations := 5
global roid := 10

global locationsUsed := 0
global roidKmColorY := ((roid*19)+97)

;global Pwb := ComObjCreate("InternetExplorer.Application")
;Pwb.Visible := True
;Pwb.Navigate("http://evebot.isgreat.org/")

InteliSleep(sec)
{
   GuiControl +Range0-%sec%,MyProgress
   GuiControl,, MyProgress, 0
   cnt := 0
   mvtime := 0
   Random, mvtime, 10, 60
   Loop, %sec%
   {
		cnt := cnt + 1
		if cnt >= %mvtime%
		{
			Random, randx, 1, 1279
			Random, randy, 1, 1023
			MouseMove, %randx%, %randy%
			Random, mvtime, 10, 60
			cnt := 0
		}
		Sleep, 1000
		GuiControl,, MyProgress, +1
   }
}

ActivateEve()
{
   WinWait, EVE, 
   IfWinNotActive, EVE, , WinActivate, EVE, 
   WinWaitActive, EVE,   
}
Undock()
{
   ActivateEve()
   UpdateGUI("Undock")
   MouseClick, left,  1000,  750
   InteliSleep(25)
}
DockIfNot()
{
   temp := (station * 19)
   temp += 97
   loops := 0
   
   PixelGetColor, color1, 990, 745
   while (abs(color1-0x42DAFF) > 0x050505)
   {
		CheckIfLoggedOut()
		loops += 1
		if(Mod(loops,5) == 1){
			ActivateEve()
			UpdateGUI("Dock")
			MouseClick, right,  150,  %temp%
			InteliSleep(2)
			temp += 53
			MouseClick, left,  200, %temp%
		}
		if(Mod(loops,17) == 0){
			ActivateEve()
			Send {F3}
			UpdateGUI("Logoff")
			InteliSleep(30)
			CheckIfLoggedOut()
			break
		}
		InteliSleep(30)
		PixelGetColor, color1, 990, 745
   }


}
CheckIfCargo()
{
   CheckIfLoggedOut()
   PixelGetColor, color1, 30, 637
   loops := 0
   while (abs(color1-0xF2F2EE) > 0x050505)
   {
		CheckIfLoggedOut()
		loops += 1
		if(Mod(loops,10) == 0)
			DockIfNot()
		UpdateGUI("Open Cargo")
		Send {Alt Down}
		InteliSleep(2)
		Send {c}
		InteliSleep(2)
		Send {Alt Up}
		InteliSleep(2)
		PixelGetColor, color1, 30, 637
   }
}
CheckIfKilledRoid()
{
	limit := 500000
	pcolor1 := 0
	pcolor2 := 0
	pcolor3 := 0
	diffcolor1 := 0
	diffcolor2 := 0
	diffcolor3 := 0
    Loop, 20
	{
		PixelGetColor, color1, 631, 679
		PixelGetColor, color2, 682, 679
		PixelGetColor, color3, 734, 679
		if(pcolor1 != 0){
			diffcolor1 += abs(pcolor1 - color1)
			diffcolor2 += abs(pcolor2 - color2)
			diffcolor3 += abs(pcolor3 - color3)
		}
		pcolor1 := color1
		pcolor2 := color2
		pcolor3 := color3
		Sleep, 100
	}
	;UpdateGUI(diffcolor1 . " " . diffcolor2 . " " . diffcolor3)
	;Sleep, 10000

	
	if((diffcolor1 < limit)||(diffcolor2 < limit)||(diffcolor3 < limit)){
		if(diffcolor1 > limit){
			Send {F1}
			InteliSleep(2)
		}
		if(diffcolor2 > limit){
			Send {F2}
			InteliSleep(2)
		}
		if(diffcolor3 > limit){
			Send {F3}
			InteliSleep(2)
		}
		return 1
	}
	return 0
}
MoveCargo()
{
   PixelGetColor, color1, 240, 665
   while (color1>0x505050)
   {
		DockIfNot()
		CheckIfCargo()
		UpdateGUI("Move Cargo, 3")
		MouseClickDrag, left, 100, 745, 400, 700
		InteliSleep(2)
		MouseClickDrag, left, 100, 725, 400, 700
		InteliSleep(2)
		MouseClickDrag, left, 100, 705, 400, 700
		InteliSleep(10)
		PixelGetColor, color1, 240, 665
   }
}

UndockIfDocked()
{   
	PixelGetColor, color1, 990, 745
	while (abs(color1-0x42DAFF) < 0x050505)
	{
		CheckIfLoggedOut()
		Undock()
		PixelGetColor, color1, 990, 745
	}
	ZoomOut()
}

ZoomOut()
{
   MouseClick, left,  500, 500
	Loop, 200{
		MouseClick, WheelUp
	Sleep, 10
	}	
}

OpenBookmarks()
{
   PixelGetColor, color1, 286, 64
   while (abs(color1-0xFCFDFC) > 0x200000)
   {
		CheckIfLoggedOut()
		UpdateGUI("Open Places")
		Send {Alt Down}
		InteliSleep(2)
		Send {e}
		InteliSleep(2)
		Send {Alt Up}
		InteliSleep(2)
		MouseClick, left, 420, 110
		PixelGetColor, color1, 286, 64
   }
}

TravelTillRoidInRange()
{
   CheckIfLoggedOut()
   UndockIfDocked()
   OpenBookmarks()

   jumpedOnce = 0
   PixelGetColor, color1, 117, %roidKmColorY%
   PixelGetColor, color2, 118, %roidKmColorY%
   while abs(color1-color2) < 0x303030
   {
		CheckIfLoggedOut()
		; Random, randbelt, 0, 0
		if(jumpedOnce > 1){
			jumpedOnce = 0
			locationsUsed += 1
			if(locationsUsed > locations)
				locationsUsed := 0
			GuiControl,,MyButton,Loc: %locationsUsed%
		}

		UpdateGUI("Jumping to Location " . %locationsUsed%)
		loc := (locationsUsed * 20)
		loc += 173

		MouseClick, right,  360, %loc%
		InteliSleep(2)
		loc += 10
		MouseClick, left, 425, %loc%
		InteliSleep(100)
		jumpedOnce += 1
		PixelGetColor, color1, 117, %roidKmColorY%
		PixelGetColor, color2, 118, %roidKmColorY%
   }
}
SelectApproachRoid()
{
   UpdateGUI("Select Steroid")
   MouseClick, left, 200,  %roidKmColorY%
   InteliSleep(2)
   UpdateGUI("Approach Steroid")
   MouseClick, left, 780, 105
   InteliSleep(2)
}
WaitTillRoidInRange()
{
   PixelGetColor, color1, 95, %roidKmColorY%
   PixelGetColor, color2, 94, %roidKmColorY%
   loops :=0
   while abs(color1-color2) > 0x202020
   {
		if(loops >= 5){
			MouseClick, left, 730, 105   ;approach case
			MouseClick, left, 755, 105   ;warp case
			UpdateGUI("Warp To Steroid")
			InteliSleep(30)
		}
		loops += 1
		SelectApproachRoid()
		InteliSleep(20)
		CheckIfLoggedOut()
		PixelGetColor, color1, 95, %roidKmColorY%
		PixelGetColor, color2, 94, %roidKmColorY%
   }
}

CheckIfLoggedOut()
{
   ActivateEve()
   PixelGetColor, color1, 475, 767
   PixelGetColor, color2, 475, 750
   if(color1==color2&&color1==0xFFFFFF)
   {
		UpdateGUI("Logging In")
		PixelGetColor, color1, 461, 745
		while (color1<0x606060)
		{
			ActivateEve()
			Send {TAB}
			InteliSleep(2)
			PixelGetColor, color1, 461, 745
		}
		Send {N}
		InteliSleep(2)
		Send {u}
		InteliSleep(2)
		Send {k}
		InteliSleep(2)
		Send {i}
		InteliSleep(2)
		Send {t}
		InteliSleep(2)
		Send {1}
		InteliSleep(2)
		Send {2}
		InteliSleep(2)
		Send {3}
		InteliSleep(2)
		Send {4}
		InteliSleep(2)
		Send {Enter}
		InteliSleep(20)
		Send {Enter}
		InteliSleep(20)
		Send {Enter}
		InteliSleep(20)
		Send {Enter}
		InteliSleep(20)
		ZoomOut()
		CheckIfCargo()
		ActivateEve()
   }
}

Gui, Add, Progress, w300 h20 cBlue vMyProgress BackgroundB0C4DE
Gui, Add, Button, gChangeLocation vMyButton, Loc: %locationsUsed%
Gui, Font, norm
Gui, Show, Y0 NoActivate, Init
Goto, Start

ChangeLocation:
	locationsUsed += 1
	if(locationsUsed > locations)
		locationsUsed := 0
	GuiControl,,MyButton,Loc: %locationsUsed%
return

UpdateGUI(str)
{
   Gui, Show, NoActivate, %str%
   try{
   Pwb.document.all.text.value := str
   Pwb.document.all.btn.click()
   } catch {
   Sleep, 1 
   }
   Return
}

Start:
Loop
{
   ActivateEve()
   CheckIfCargo()
   PixelGetColor, color1, 240, 665
;UpdateGUI(color1)
;InteliSleep(180)
   while (color1<0x606060)
   {
		TravelTillRoidInRange()
		SelectApproachRoid()
		WaitTillRoidInRange()

		InteliSleep(2)
		UpdateGUI("Lock")
		MouseClick, left, 830,  105
		InteliSleep(3)

		UpdateGUI("Press F's")
		Send {F1}
		InteliSleep(2)
		Send {F2}
		InteliSleep(2)
		Send {F3}
		InteliSleep(2)

		MouseClick, left, 200,  %roidKmColorY%
		
		UpdateGUI("Mining time")
		InteliSleep(180)
		;InteliSleep(2)
		CheckIfCargo()
		PixelGetColor, color1, 240, 665
		if(color1>0x606060)
			Break
		 
		if(CheckIfKilledRoid() == 0){
			UpdateGUI("Unlock")
			MouseClick, left, 830,  105
			InteliSleep(180)
			CheckIfCargo()
			PixelGetColor, color1, 240, 665
		}
   }
   DockIfNot()
   MoveCargo()
}
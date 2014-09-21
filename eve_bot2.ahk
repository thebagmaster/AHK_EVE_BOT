SetKeyDelay, 250
SetDefaultMouseSpeed, 10

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


CheckIfLoggedOut()
{
   PixelGetColor, color1, 475, 767
   PixelGetColor, color2, 475, 750
   if(color1==color2&&color1==0xFFFFFF)
   {
      UpdateGUI("Logging BacK In")
      Send {TAB}
      InteliSleep(2)
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
      Send {Alt Down}
      InteliSleep(2)
      Send {c}
      InteliSleep(2)
      Send {Alt Up}
      InteliSleep(2)
   }
}

Gui, Add, Progress, w300 h20 cBlue vMyProgress BackgroundB0C4DE
Gui, Show, NoActivate, Init

UpdateGUI(str)
{
   Gui, Show, NoActivate, %str%
   Return
}

Loop
{
   UpdateGUI("Activate EVE")
   WinWait, EVE, 
   IfWinNotActive, EVE, , WinActivate, EVE, 
   WinWaitActive, EVE,   
   InteliSleep(3)

   UpdateGUI("Undock")
   MouseClick, left,  1000,  750
   InteliSleep(25)

Loop, 1
{
   PixelGetColor, color1, 121, 253
   PixelGetColor, color2, 120, 253
   while color1-color2 < 0x303030
   {
      Random, randbelt, 0, 3
      UpdateGUI("Random Jump " . randbelt)
      randbelt *= 21
      randbelt += 100
      MouseClick, right,  200,  %randbelt%
      InteliSleep(2)
      randbelt += 10
      MouseClick, left, 250, %randbelt%
      InteliSleep(100)
      CheckIfLoggedOut()
      PixelGetColor, color1, 121, 253
      PixelGetColor, color2, 120, 253
   }
   UpdateGUI("Select Steroid")
   MouseClick, left, 200,  255
   InteliSleep(2)

   UpdateGUI("Approach Steroid")
   MouseClick, left, 780, 105
   
   PixelGetColor, color1, 96, 250
   PixelGetColor, color2, 94, 250
   while color1-color2 > 0x202020
   {
      InteliSleep(10)
      PixelGetColor, color1, 96, 250
      PixelGetColor, color2, 94, 250
   }
   InteliSleep(2)
   UpdateGUI("Lock")
   MouseClick, left, 830,  105
   InteliSleep(8)
   
   UpdateGUI("Press F's")
   Send {F1}
   InteliSleep(2)
   Send {F2}
   InteliSleep(2)

   UpdateGUI("Mining time")
   InteliSleep(180)

   UpdateGUI("Unlock")
   MouseClick, left, 830,  105
   ;only if loop > 1
   ;InteliSleep(190)
}

   UpdateGUI("Dock")
   MouseClick, right,  150,  234
   InteliSleep(2)
   MouseClick, left,  200, 285
   InteliSleep(110)

   UpdateGUI("Move Cargo, 3")
   MouseClickDrag, left, 100, 705, 400, 700
   InteliSleep(2)
   MouseClickDrag, left, 100, 725, 400, 700
   InteliSleep(2)
   MouseClickDrag, left, 100, 745, 400, 700
   InteliSleep(10)
}
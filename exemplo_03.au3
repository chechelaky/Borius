;~ #AutoIt3Wrapper_AU3Check_Parameters= -q -d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7
;~ #Tidy_Parameters=/sf

#include-once
#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <Misc.au3>
#include <GDIPlus.au3>
#include <WindowsConstants.au3>
#include <WinAPISys.au3>
#include <Timers.au3>


Global $KEYS[4]
Global Const $ROOT = Sqrt(2) / 2
Global Const $hDLL = DllOpen("user32.dll")
Global Enum $COLOR, $WALK, $IMAGE
Global $0[] = [0xFFFFFFFF, True, ""]
Global $1[] = [0xFF993300, False, ""]
Global $2[] = [0xFF000000, False, ""]
Global $3[] = [0xFFFF6600, False, "ator.png"]

Global $ax = 64, $ay = 96
Global $iSpeed = 5
Global $TILE = 32
Global $GRID[7][10] = [ _
		[$1, $1, $1, $1, $1, $1, $1, $1, $1, $1], _
		[$1, $2, $2, $0, $2, $2, $0, $2, $2, $1], _
		[$1, $2, $0, $0, $0, $0, $0, $0, $2, $1], _
		[$1, $0, $0, $2, $0, $0, $2, $0, $0, $1], _
		[$1, $2, $0, $0, $0, $0, $0, $0, $2, $1], _
		[$1, $2, $2, $0, $2, $2, $0, $2, $2, $1], _
		[$1, $1, $1, $1, $1, $1, $1, $1, $1, $1] _
		]

Global $MAP[1]
Global $FRAME[] = [UBound($GRID, 2), UBound($GRID, 1), UBound($GRID, 2) * $TILE, UBound($GRID, 1) * $TILE]
ConsoleWrite("FRAME[" & _ArrayToString($FRAME, ",") & "]" & @LF)
ReDim $MAP[$FRAME[1] + 1][$FRAME[$COLOR] + 1]

OnAutoItExitRegister("OnExit")

Opt("GUIOnEventMode", 1)
Opt("GUIEventOptions", 1)
Opt("MustDeclareVars", 1)

Global $aGuiSize[2] = [$FRAME[2], $FRAME[3]]
Global $sGuiTitle = "GuiTitle"
Global $hGui

Global $hGraphic, $hPen, $hBitmap, $hBackbuffer

$hGui = GUICreate($sGuiTitle, $aGuiSize[0], $aGuiSize[1])
GUISetOnEvent($GUI_EVENT_CLOSE, "Quit")

_GDIPlus_Startup()
$hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGui)
$hBitmap = _GDIPlus_BitmapCreateFromGraphics($FRAME[2], $FRAME[3], $hGraphic)
$hBackbuffer = _GDIPlus_ImageGetGraphicsContext($hBitmap)
$hPen = _GDIPlus_PenCreate()
_GDIPlus_GraphicsClear($hBackbuffer)


AdlibRegister("Keys", 26)
AdlibRegister("Update", 13)
GUISetState(@SW_SHOW, $hGui)

Func Update()
;~ 	Local Static $time = _Timer_Init()
;~ 	Local Static $count = 0
	_GDIPlus_GraphicsClear($hBackbuffer, 0xFFFFFFFF)
	For $ii = 0 To $FRAME[1] - 1
		For $jj = 0 To $FRAME[0] - 1
			Local $try = $GRID[$ii][$jj]
			_box($hBackbuffer, $jj * 32, $ii * 32, 32, 32, ($GRID[$ii][$jj])[0])
		Next
	Next
	_box($hBackbuffer, $ax, $ay, 32, 32, ($3)[0])

	_GDIPlus_GraphicsDrawImageRect($hGraphic, $hBitmap, 0, 0, $FRAME[2], $FRAME[3])
;~ 	If TimerDiff($time) >= 1000 Then
;~ 		ConsoleWrite("fps[" & $count & "]" & @LF)
;~ 		$time = _Timer_Init()
;~ 		$count = 0
;~ 	Else
;~ 		$count += 1
;~ 	EndIf
EndFunc   ;==>Update

While Sleep(500)
;~ 	Update()
WEnd

Func Keys()
;~ 	25 LEFT ARROW key
;~ 	26 UP ARROW key
;~ 	27 RIGHT ARROW key
;~ 	28 DOWN ARROW key
	Local $aa = 8, $bb = 24

	If _IsPressed(25, $hDLL) Then
		Local $eval = $iSpeed
		While ($GRID[($ay + $aa) / $TILE][($ax - 1) / $TILE])[$WALK] And ($GRID[($ay + $bb) / $TILE][($ax - 1) / $TILE])[$WALK] And $eval
			$ax -= 1
			$eval -= 1
		WEnd
		Return
	EndIf

	If _IsPressed(26, $hDLL) Then
		Local $eval = $iSpeed
		While ($GRID[($ay - 1) / $TILE][($ax + $aa) / $TILE])[$WALK] And ($GRID[($ay - 1) / $TILE][($ax + $bb) / $TILE])[$WALK] And $eval
			$ay -= 1
			$eval -= 1
		WEnd
		Return
	EndIf

	If _IsPressed(27, $hDLL) Then
		Local $eval = $iSpeed
		While ($GRID[($ay + $aa) / $TILE][($ax + $TILE) / $TILE])[$WALK] And ($GRID[($ay + $bb) / $TILE][($ax + $TILE) / $TILE])[$WALK] And $eval
			$ax += 1
			$eval -= 1
		WEnd
		Return
	EndIf

	If _IsPressed(28, $hDLL) Then
		Local $eval = $iSpeed
		While ($GRID[($ay + $TILE) / $TILE][($ax + $aa) / $TILE])[$WALK] And ($GRID[($ay + $TILE) / $TILE][($ax + $bb) / $TILE])[$WALK] And $eval
			$ay += 1
			$eval -= 1
		WEnd
		Return
	EndIf
EndFunc   ;==>Keys

Func OnExit()

	DllClose($hDLL)

;~ 	_GDIPlus_BitmapDispose($hMap)
	_GDIPlus_PenDispose($hPen)
	_GDIPlus_GraphicsDispose($hBackbuffer)
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_Shutdown()

	GUISetState($hGui, @SW_HIDE)
	GUIDelete($hGui)
EndFunc   ;==>OnExit

Func Quit()
	AdlibUnRegister("keys")
	AdlibUnRegister("Update")
	Exit
EndFunc   ;==>Quit

Func _box($hToGraphic, $xx, $yy, $ll, $aa, $COLOR = 0xFF000000)
	Local $aBox[5][2]
	$aBox[0][0] = 4
	$aBox[1][0] = $xx
	$aBox[1][1] = $yy
	$aBox[2][0] = $xx + $ll - 1
	$aBox[2][1] = $yy
	$aBox[3][0] = $xx + $ll - 1
	$aBox[3][1] = $yy + $aa - 1
	$aBox[4][0] = $xx
	$aBox[4][1] = $yy + $aa - 1
	If $COLOR Then
		_GDIPlus_PenSetColor($hPen, $COLOR)
		_GDIPlus_GraphicsDrawPolygon($hToGraphic, $aBox, $hPen)

;~ 		_GDIPlus_GraphicsDrawLine($hToGraphic, $aBox[1][0], $aBox[1][1], $aBox[3][0], $aBox[3][1], $hPen)
;~ 		_GDIPlus_GraphicsDrawLine($hToGraphic, $aBox[2][0], $aBox[2][1], $aBox[4][0], $aBox[4][1], $hPen)
	Else
		_GDIPlus_GraphicsDrawPolygon($hToGraphic, $aBox)

;~ 		_GDIPlus_GraphicsDrawLine($hToGraphic, $aBox[1][0], $aBox[1][1], $aBox[3][0], $aBox[3][1])
;~ 		_GDIPlus_GraphicsDrawLine($hToGraphic, $aBox[2][0], $aBox[2][1], $aBox[4][0], $aBox[4][1])
	EndIf
EndFunc   ;==>_box

Func RGB_2_ARGB($alfa = 0, $RGB = 0)
;~ 	https://www.autoitscript.com/forum/topic/167529-web-color-to-rgba/
;~ 	Local $dRed = Hex(BitAND(BitShift($RGB, 16), 0xFF), 2)
;~ 	Local $dGreen = Hex(BitAND(BitShift($RGB, 8), 0xFF), 2)
;~ 	Local $dBlue = Hex(BitAND($RGB, 0xFF), 2)
	Return "0x" & Hex($alfa, 2) & Hex(BitAND(BitShift($RGB, 16), 0xFF), 2) & Hex(BitAND(BitShift($RGB, 8), 0xFF), 2) & Hex(BitAND($RGB, 0xFF), 2)
EndFunc   ;==>RGB_2_ARGB


Func ARGB_2_RGB($RGB = 0)
;~ 	https://www.autoitscript.com/forum/topic/167529-web-color-to-rgba/
;~ 	Local $dRed = Hex(BitAND(BitShift($RGB, 16), 0xFF), 2)
;~ 	Local $dGreen = Hex(BitAND(BitShift($RGB, 8), 0xFF), 2)
;~ 	Local $dBlue = Hex(BitAND($RGB, 0xFF), 2)
	Return "0x" & Hex(BitAND(BitShift($RGB, 16), 0xFF), 2) & Hex(BitAND(BitShift($RGB, 8), 0xFF), 2) & Hex(BitAND($RGB, 0xFF), 2)
EndFunc   ;==>ARGB_2_RGB

;~ #AutoIt3Wrapper_AU3Check_Parameters= -q -d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7
;~ #Tidy_Parameters=/sf

#include-once
#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <Misc.au3>

Global Const $hDLL = DllOpen("user32.dll")
Global $0 = 0xFFFFFF
Global $1 = 0x993300
Global $2 = 0x000000
Global $3 = 0xFF6600

Global $ax = 2, $ay = 2
Global $TILE = 32
Global $GRID[5 + 2][8 + 2] = [ _
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
ReDim $MAP[$FRAME[1] + 1][$FRAME[0] + 1]

OnAutoItExitRegister("OnExit")

Opt("GUIOnEventMode", 1)
Opt("GUIEventOptions", 1)
Opt("MustDeclareVars", 1)

Global $aGuiSize[2] = [$FRAME[2], $FRAME[3]]
Global $sGuiTitle = "GuiTitle"
Global $hGui

$hGui = GUICreate($sGuiTitle, $aGuiSize[0], $aGuiSize[1])
GUISetOnEvent($GUI_EVENT_CLOSE, "Quit")

For $ii = 0 To $FRAME[1] - 1
	For $jj = 0 To $FRAME[0] - 1
		$MAP[$ii][$jj] = GUICtrlCreateLabel("", $jj * 32, $ii * 32, 32, 32)
		GUICtrlSetTip($MAP[$ii][$jj], "ii=" & $ii & " $jj=" & $jj & " g=" & $GRID[$ii][$jj])
		GUICtrlSetBkColor($MAP[$ii][$jj], $GRID[$ii][$jj] = $0 ? $0 : $GRID[$ii][$jj])
	Next
Next
GUICtrlSetBkColor($MAP[$ax][$ay], $3)


AdlibRegister("Keys", 50)
GUISetState(@SW_SHOW, $hGui)

While Sleep(25)
WEnd

Func Keys()
	If _IsPressed(25, $hDLL) And $GRID[$ax][$ay - 1] = $0 Then
		GUICtrlSetBkColor($MAP[$ax][$ay], $GRID[$ax][$ay])
		$ay -= 1
		GUICtrlSetBkColor($MAP[$ax][$ay], $3)
		Return
	EndIf
	If _IsPressed(26, $hDLL) And $GRID[$ax - 1][$ay] = $0 Then
		GUICtrlSetBkColor($MAP[$ax][$ay], $GRID[$ax][$ay])
		$ax -= 1
		GUICtrlSetBkColor($MAP[$ax][$ay], $3)
		Return
	EndIf
	If _IsPressed(27, $hDLL) And $GRID[$ax][$ay + 1] = $0 Then
		GUICtrlSetBkColor($MAP[$ax][$ay], $GRID[$ax][$ay])
		$ay += 1
		GUICtrlSetBkColor($MAP[$ax][$ay], $3)
		Return
	EndIf
	If _IsPressed(28, $hDLL) And $GRID[$ax + 1][$ay] = $0 Then
		GUICtrlSetBkColor($MAP[$ax][$ay], $GRID[$ax][$ay])
		$ax += 1
		GUICtrlSetBkColor($MAP[$ax][$ay], $3)
		Return
	EndIf
EndFunc   ;==>Keys

Func OnExit()
	AdlibUnRegister("keys")
	DllClose($hDLL)

	GUISetState($hGui, @SW_HIDE)
	GUIDelete($hGui)
EndFunc   ;==>OnExit

Func Quit()
	Exit
EndFunc   ;==>Quit

#Requires AutoHotkey v2.0.0


/*
    RandomBezier.ahk
    Copyright (C) 2012,2013 Antonio Fran�a

    This script is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.

    This script is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this script.  If not, see <http://www.gnu.org/licenses/>.
*/

;========================================================================
;
; Function:     RandomBezier
; Description:  Moves the mouse through a random Bezier path
; URL (+info):  --------------------
;
; Last Update:  30/May/2013 03:00h BRT
;
; Created by MasterFocus
; - https://github.com/MasterFocus
; - http://masterfocus.ahk4.net
; - http://autohotkey.com/community/viewtopic.php?f=2&t=88198
;
;========================================================================
; XO/YO : X/Y origin
; XD/YD : X/Y destination
; O     : options
RandomBezier(XO, YO, XD, YD, O := "" ) {
    Time := RegExMatch(O, "i)T(\d+)", &M) && (M[1] > 0) ? M[1] : 200
    BM := InStr(O, "BM")
    RO := InStr(O, "RO")
    RD := InStr(O, "RD")
    If !RegExMatch(O, "i)P(\d+)(-(\d+))?", &M)
        N := 2
    Else {
        N := (M[1] < 2) ? 2 : (M[1] > 19) ? 19 : M[1]
        If (M.Count = 3) {
            M := (M[3] < 2) ? 2 : (M[3] > 19) ? 19 : M[3]
            N := Random(N, M)
        }
    }
    OfT := RegExMatch(O, "i)OT(-?\d+)", &M) ? M[1] : 100
    OfB := RegExMatch(O, "i)OB(-?\d+)", &M) ? M[1] : 100
    OfL := RegExMatch(O, "i)OL(-?\d+)", &M) ? M[1] : 100
    OfR := RegExMatch(O, "i)OR(-?\d+)", &M) ? M[1] : 100
    MouseGetPos(&XM, &YM)
    If (RO) {
        XO += XM
        YO += YM
    }
    If (RD) {
        XD += XM
        YD += YM
    }
    If (XO < XD) {
        sX := XO - OfL
        bX := XD + OfR
    }
    Else {
        sX := XD - OfL
        bX := XO + OfR
    }
    If (YO < YD) {
        sY := YO - OfT
        bY := YD + OfB
    }
    Else {
        sY := YD - OfT
        bY := YO + OfB
    }
    MX := Map()
    MX[0] := XO
    MY := Map()
    MY[0] := YO
    Loop (--N) - 1 {
        MX[A_Index] := Random(sX, bX)
        MY[A_Index] := Random(sY, bY)
    }
    MX[N] := XD
    MY[N] := YD
    I := A_TickCount
    E := I + Time
    consecutiveZeroIdleCount := 0
    consecutiveNonZeroIdleCount := 0
    nonZeroThreshold := 5
    While (A_TickCount < E) {
        T := (A_TickCount - I) / Time
        U := 1 - T
        X := Y := 0
        Loop (N + 1) {
            F1 := F2 := F3 := 1
            Idx := A_Index - 1
            Loop Idx {
                F2 *= A_Index
                F1 *= A_Index
            }
            D := N - Idx
            Loop D {
                F3 *= A_Index
                F1 *= A_Index + Idx
            }
            M := (F1 / (F2 * F3)) * ((T + 0.000001) ** Idx)*((U - 0.000001) ** D)
            X += M * MX[Idx]
            Y += M * MY[Idx]
        }
        
        ; TODO: Add support for pausing mouse movement while it is being moved physically
        ; Check if user is trying to move mouse while it is being moved
        if (A_TimeIdleMouse = 0) {
            consecutiveNonZeroIdleCount := 0
            consecutiveZeroIdleCount += 1
            if (consecutiveZeroIdleCount > 3) {
                ; User is trying to move the mouse, handle accordingly
                if (!BM) {
                    ; kill this while loop because we want to cancel the Mouse Movement
                    MyTip("STOPPED MouseMoveRandom!")
                    break
                }
                else {
                    MyTip("Being moved by MouseMoveRandom.")
                }
            }
        } else {
            consecutiveNonZeroIdleCount += 1
            if (consecutiveNonZeroIdleCount > nonZeroThreshold) {
                consecutiveZeroIdleCount := 0
                consecutiveNonZeroIdleCount := 0
            }
            else {
                consecutiveNonZeroIdleCount += 1
            }
        }
        MouseMove(X, Y, 0)
        Sleep(1)
    }
    MouseMove(MX[N], MY[N], 0)
    Return (N + 1)
}


;========================================================================
;
; Function:     MouseMoveRandom
; Description:  Moves the mouse through a random Bezier path with more default configuration
; URL (+info):  --------------------
;
; Last Update:  08/May/2024
;
; Created by AnthonMS using MasterFocus RandomBezier function
; - https://github.com/AnthonMS
; - https://github.com/MasterFocus
;
;========================================================================
MouseMoveRandomParams := {
    offsetX:0, 
    offsetY:0, 
    mode:"normal", 
    startX:"null", 
    startY:"null", 
    relative:false, 
    blockMouse:false
}
MouseMoveRandom(endX, endY, params:={}) {
    for (key, value in ObjOwnProps(MouseMoveRandomParams)) {
        if (!params.HasOwnProp(key)) {
            params.%key% := value
        }
    }
    mode:=params.mode, blockMouse:=params.blockMouse, relative:=params.relative, offsetX:=params.offsetX, offsetY:=params.offsetY, startX:=params.startX, startY:=params.startY
    if (blockMouse) {
        BlockInput("MouseMove")
    }
    MouseGetPos(&mouseX, &mouseY)
    startX := startX != "null" ? startX : mouseX
    startY := startY != "null" ? startY : mouseY
    endX := Random(endX-offsetX, endX+offsetX)
    endY := Random(endY-offsetY, endY+offsetY)
    distance := Round(CalcDistance(startX, startY, endX, endY))
    randTravelTimeMin := 200, randTravelTimeMax := 300, randTravelTime := 200 ; Init travel time
    if RegExMatch(mode, "i)custom:(\d+)(?:-(\d+))?", &matches) { ; User defined travel time
        randTravelTimeMin := matches[1]  ; Extract the first number as min
        randTravelTimeMax := matches[2] ? matches[2] : matches[1]  ; If the second number is present, use it as max; otherwise, use the first number as both min and max
        randTravelTime := Random(randTravelTimeMin, randTravelTimeMax)
    }
    else { ; 
        Switch(mode) {
            Default:
                handSpeed := 100
            case "competitive":
                handSpeed := 900
            case "fast":
                handSpeed := 600
            case "normal":
                handSpeed := 300
            case "slow":
                handSpeed := 200
            case "really-slow":
                handSpeed := 50
            case "snail":
                handSpeed := 10
        }
        randTravelTime := CalcTravelTime(distance, handSpeed)
    }
    
    t := " T" randTravelTime " "
    rd := relative ? " RD " : " "
    bm := blockMouse ? " BM " : " "
    p := distance < 50 ? " P1-1 " : " P4-4 "
    RandomBezier(startX, startY, endX, endY, t rd bm p "OL50 OR50 OT50 OB50")
    
    if (blockMouse) {
        BlockInput("MouseMoveOff")
    }
}


CalcTravelTime(distance, handSpeed) {
    reactionTime := 50  ; Fixed delay representing reaction time (in milliseconds)
    speedFactor := 1.5  ; Speed adjustment factor for acceleration/deceleration
    distanceCentimeters := distance / 800 * 2.54 ; Convert distance to centimeters (assuming 800 DPI)
    handSpeed := handSpeed * Random(0.85, 1.15)
    timeSeconds := (distanceCentimeters / (handSpeed / 10)) * speedFactor ; Calculate time in seconds based on hand speed (mm/s)
    timeMilliseconds := (timeSeconds * 1000) + reactionTime ; Convert time to milliseconds
    return Round(timeMilliseconds) ; Round the time to the nearest millisecond
}
CalcDistance(startPosX, startPosY, endPosX, endPosY) {
    distance := Sqrt((endPosX - startPosX) ** 2 + (endPosY - startPosY) ** 2)
    return distance
}


SleepJitteryParams := {
    range: 20, 
    blockMouse: false
}
SleepJittery(ms, params:={}) {
    for (key, value in ObjOwnProps(SleepJitteryParams)) {
        if (!params.HasOwnProp(key)) {
            params.%key% := value
        }
    }
    if (params.blockMouse) {
        BlockInput("MouseMove")
    }
    startTime := A_TickCount  ; Get the current tick count
    endTime := startTime + ms
    range := params.range

    while (A_TickCount < endTime) {
        
        ; Check if the mouse has been physically moved
        if (A_TimeIdleMouse < 150) {
            ; If mouse moved, sleep for 1 second and check again
            if (params.blockMouse) {
                endTime += 900 - A_TimeIdleMouse
                Sleep(900)
                continue  ; Skip jittery movement
            }
            else {
                break
            }
        }
        ; Generate random jitter values
        randomX := Random(range*-1, range)
        randomY := Random(range*-1, range)
        
        MouseMoveRandom(randomX, randomY, params:={relative:true, mode:"snail"})
        
        Sleep(150)
    }
    if (params.blockMouse) {
        BlockInput("MouseMoveOff")
    }
}
### [Github](https://github.com/MasterFocus/AutoHotkey/tree/master/Functions/RandomBezier)

## Example:
`RandomBezier(0, 0, 400, 400, "T500 RO RD P4-20")`
  - Starts at 0, 0 | Ends at 400, 400
  - The time of the movement is 500 milliseconds.
  - Considers the origin and destination coordinates as relative.
  - Uses a random number of control points between 4 and 20.

`RandomBezier(0, 0, 1200, 1100, "T1000 BM P2-4 OL1 OR1 OT1 OB1")`
  - Starts at 0, 0 | Ends at 1200, 1100
  - The time of the movement is 1000 milliseconds.
  - Uses a random number of control points between 2 and 4.
  - Stays close to path with an offset of only 1


```
#Include RandomBezier.ahk

F5:: ToolTip, % "Points: " RandomBezier( 0, 0, 400, 400, "T500 RO RD OT0 OB0 OL0 OR0 P4-20" )
F6:: ToolTip, % "Points: " RandomBezier( 0, 0, 200, 200, "T1000 RO RD")
F7:: ToolTip, % "Points: " RandomBezier( 0, 0, 150, 150, "T1500 RO RD OT150 OB150 OL150 OR150 P6-4" )
F8:: ToolTip, % "Points: " RandomBezier( 0, 0, 200, 0, "T1200 RO RD OT100 OB-100 OL0 OR0 P4-3" )

F9:: ToolTip, % "Points: " RandomBezier( 0, 0, 400, 300, "T1000 RO P5" )
F10:: ToolTip, % "Points: " RandomBezier( 400, 300, 0, 0, "T1000 RD" )

F12::RELOAD
ESC::EXITAPP
```


========================================================================

 X0, Y0, Xf, Yf [, O]

 + Required parameters:
 - X0 and Y0     The initial coordinates of the mouse movement
 - Xf and Yf     The final coordinates of the mouse movement

 + Optional parameters:
 - O             Options string, see remarks below (default: blank)

 It is possible to specify multiple (case insensitive) options:

 # "Tx" (where x is a positive number)
   > The time of the mouse movement, in miliseconds
   > Defaults to 200 if not present
 # "RO"
   > Consider the origin coordinates (X0,Y0) as relative
   > Defaults to "not relative" if not present
 # "RD"
   > Consider the destination coordinates (Xf,Yf) as relative
   > Defaults to "not relative" if not present
 # "Px" or "Py-z" (where x, y and z are positive numbers)
   > "Px" uses exactly 'x' control points
   > "Py-z" uses a random number of points (from 'y' to 'z', inclusive)
   > Specifying 1 anywhere will be replaced by 2 instead
   > Specifying a number greater than 19 anywhere will be replaced by 19
   > Defaults to "P2-5"
 # "OTx" (where x is a number) means Offset Top
 # "OBx" (where x is a number) means Offset Bottom
 # "OLx" (where x is a number) means Offset Left
 # "ORx" (where x is a number) means Offset Right
   > These offsets, specified in pixels, are actually boundaries that
     apply to the [X0,Y0,Xf,Yf] rectangle, making it wider or narrower
   > It is possible to use multiple offsets at the same time
   > When not specified, an offset defaults to 100
     - This means that, if none are specified, the random B�zier control
       points will be generated within a box that is wider by 100 pixels
       in all directions, and the trajectory will never go beyond that

========================================================================
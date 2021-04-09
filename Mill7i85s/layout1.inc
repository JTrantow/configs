[XHC_HB04_CONFIG]
# specify layout = n for LIB:xhc-hb04-layout{n}.cfg files
layout = 2
# coords: specify upto 4 letters from set {x y z a b c u v w}
# coords: switch labels are xyza but any unique 4 letters
#         from the set {xyxabcuvw) can be used (if the coord exists)
coords = x y z 
coefs = 1 1 1 1
# scale plus or minus, rotaries may require larger scale factor:
scales = 1 1 1 1
# jogmode normal(default) or vnormal
jogmode = normal
# sequence 1: 0.001,0.010,0.100,1.000 (mm-based machine)
# sequence 2: 0.001,0.005,0.010,0.020 (inch-based machine)
# sequence 3: 0.001,0.010,0.100
# sequence 4: 0.001,0.005,0.010,0.020,0.050,0.100
# sequence 5: 0.001,0.010,0.050,0.100,1.000
sequence = 1
require_pendant = no
inch_or_mm = mm
# mpg_accels: provision for reduced acceleration for manual mode jogging
mpg_accels = 1 2 20 600


[XHC_HB04_BUTTONS]
# Layout 2 for 18 buttons.
#|--------------------------------------|
#|reset    |stop       |                |  
#|--------------------------------------|
#|goto-zero|start-pause|rewind |probe-z |  
#|--------------------------------------|
#|spindle  | half      | zero  |safe-z  |  
#|--------------------------------------|
#|home     |macro-1    |macro-2|macro-3 |  
#|--------------------------------------|
#|step     |mode       |macro-6|macro-7 |  
#|--------------------------------------|
#|                                 Off  |
#|                                   X  |
#|                                   Y  |
#|                  Rotary ------->  Z  |
#|                  Switch           A  |
#|                              Spindle |
#|                                 Feed |
#|--------------------------------------|
#
# Row 1
#
reset       = halui.estop.activate
stop        = halui.program.stop
#
# Row 2
#
goto-zero   = halui.mdi-command-10
start-pause = std_start_pause
rewind      = halui.program.step
probe       = halui.mdi-command-14

#
# Row 3
#
spindle     = halui.mdi-command-15
half        = halui.mdi-command-16
zero        = halui.mdi-command-20
safe-z      = halui.mdi-command-18
#
# Row 4
#
#home        = halui.mode.joint    halui.home-all 
home        = halui.home-all 
macro-1     = halui.mdi-command-01
macro-2     = halui.mdi-command-02
macro-3     = halui.mdi-command-03
#
# Row 5
#
step        = xhc-hb04.stepsize-up
mode        = halui.mdi-command-05
macro-6     = halui.mdi-command-06
macro-7     = halui.mdi-command-07

#
# Additional buttons are synthesized for buttons named zero, goto-zero, and half. These synthesized buttons are active when the button is pressed AND the selector-switch is set to the corresponding axis [xyza].
#
(bit out) xhc-hb04.button-zero-[xyza]
(bit out) xhc-hb04.button-goto-zero-[xyza]
(bit out) xhc-hb04.button-half-[xyza]
#
# synthesized per-axis buttons for zero button:
#
zero-x = halui.mdi-command-21
zero-y = halui.mdi-command-22
zero-z = halui.mdi-command-23
zero-a = halui.mdi-command-24
#
# synthesized per-axis buttons for goto-zero button:
#
goto-zero-x = halui.mdi-command-11
goto-zero-y = halui.mdi-command-12
goto-zero-z = halui.mdi-command-13
goto-zero-a = halui.mdi-command-14
#
# synthesized per-axis buttons for half button:
#
goto-half-x = halui.mdi-command-31
goto-half-y = halui.mdi-command-32
goto-half-z = halui.mdi-command-33
goto-half-a = halui.mdi-command-34

[HALUI]
# these are examples, edit as required:
# a halui hal pin is created for each MDI_COMMAND below
# halui.mdi-command-00, halui.mdi-command-01,... etc
MDI_COMMAND=(debug, example: mdi-00)
#G1 X0 Y0 Z0 F200
MDI_COMMAND=(debug, example: mdi-01)
MDI_COMMAND=(debug, example: mdi-02)
MDI_COMMAND=(debug, example: mdi-03)
MDI_COMMAND=(debug, example: mdi-04)
MDI_COMMAND=(debug, example: mdi-05)
MDI_COMMAND=(debug, example: mdi-06)
MDI_COMMAND=(debug, example: mdi-07)
MDI_COMMAND=(debug, example: mdi-08)
MDI_COMMAND=(debug, example: mdi-09)
#
# mdi-10 (These commands move axis to 0.
#
MDI_COMMAND=(debug, goto-zero: mdi-10)
MDI_COMMAND=G1 X0 F100
MDI_COMMAND=G1 Y0 F100
MDI_COMMAND=G1 Z0 F100
MDI_COMMAND=G1 X0 Y0 Z0 F100

MDI_COMMAND=(debug, example: mdi-15)
MDI_COMMAND=(debug, example: mdi-16)
MDI_COMMAND=(debug, example: mdi-17)
MDI_COMMAND=(debug, example: mdi-18)
MDI_COMMAND=(debug, example: mdi-19)

#
# Set axis to zero.
#
MDI_COMMAND=(debug, zero axis: mdi-20)
MDI_COMMAND=G10 L20 P0 X0
MDI_COMMAND=G10 L20 P0 Y0
MDI_COMMAND=G10 L20 P0 Z0
MDI_COMMAND=G10 L20 P0 X0 Y0 Z0

MDI_COMMAND=(debug, example: mdi-25)
MDI_COMMAND=(debug, example: mdi-26)
MDI_COMMAND=(debug, example: mdi-27)
MDI_COMMAND=(debug, example: mdi-28)
MDI_COMMAND=(debug, example: mdi-29)

#
# half buttons.
#
MDI_COMMAND=(debug, half: mdi-30)
MDI_COMMAND=(debug, half-x: mdi-31)
MDI_COMMAND=(debug, half-y: mdi-32)
MDI_COMMAND=(debug, half-z: mdi-33)
MDI_COMMAND=(debug, half-a: mdi-34)


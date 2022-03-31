#
# https://github.com/verser-git/probe_screen_v2/blob/master/my-mill.ini
#


[TOOLSENSOR]
# Absolute coordinates of the toolsetter pad 
X = 700
Y = 1
# Absolute Z start search coordinates
Z = 75
# Maximum search distance and direction (sign)
MAXPROBE = -80
# Speed of movements during working in Probe Screen
RAPID_SPEED = 1500
# Diameter of toolsetter pad 
TS_DIAMETER = 10
# The speed of the reverse rotation of the spindle when measuring the tool diameter
REV_ROTATION_SPEED = 0

[CHANGE_POSITION]
# Abs coordinates tool change point
X = 10  
Y = 100  
Z = 100


[PYTHON]
PATH_PREPEND = ./python
TOPLEVEL = python/toplevel.py

#
# https://github.com/verser-git/probe_screen_v2/blob/master/my-mill.ini
#

[TOOLSENSOR]
# Absolute coordinates of the toolsetter pad 
X = 325
Y = 175
# Absolute Z start search coordinates
Z = 300
# Maximum search distance and direction (sign)
MAXPROBE = -250
# Speed of movements during working in Probe Screen
RAPID_SPEED = 600
# Diameter of toolsetter pad 
TS_DIAMETER = 10
# The speed of the reverse rotation of the spindle when measuring the tool diameter
REV_ROTATION_SPEED = 0

[CHANGE_POSITION]
# Abs coordinates tool change point
X = 100
Y = 100
Z = 300

[PYTHON]
PATH_PREPEND = ./python
TOPLEVEL = python/toplevel.py


#!/usr/bin/python3
import subprocess
import sys

data = sys.stdin.readlines()[0][0:-1]

test = subprocess.Popen(["i3-msg","move container to workspace \"%s\"; workspace \"%s\"" % (data,data) ], stdout=subprocess.PIPE)

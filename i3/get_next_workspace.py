#!/usr/bin/python3
import subprocess
import json
import re

pat = re.compile('^[0-9]*')

test = subprocess.Popen(["i3-msg","-t","get_workspaces"], stdout=subprocess.PIPE)
output = test.communicate()[0]

data = json.loads(output.decode())
data = sorted(data, key=lambda k: k['name'])

next=1
for i in data:
  name = i['name']
  #print(i['name'])
  match = pat.match(str(name)).group()
  if match != None and match.isdigit():
    target = int(match)
    if target>=next: next = target+1

print(next)
#test = subprocess.Popen(["i3-msg","workspace "+str(target)], stdout=subprocess.PIPE)

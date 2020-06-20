#!/usr/bin/python3
import re
import sys
import i3
import os

import pprint


floating_windows = os.path.expanduser('~/.i3/scripts/floating_windows_list.txt')


def move_workspace(source, dest):
  i3.command('rename', 'workspace "%s" to "%s"' % (str(source), str(dest)))


def switch_to_workspace(target):
  i3.command('workspace "%s"' % (str(target)))

def move_window_to_workspace(target, follow=False):
  i3.command('move', 'container to workspace "%s"' % (str(target)))
  if follow: switch_to_workspace(target)

def move_window_to_output(target):
  i3.command('move', 'window to output "%s"' % (str(target)))




def get_workspaces():
  data = i3.get_workspaces()
  data = { int(item['name']): item for item in data if is_valid(item) }
  return data


def is_valid(item):
  try:
    garbage = int(item['name'])
    return True
  except ValueError:
    return False


def move_to_workspace_with_push(source, target, workspaces):
  print(source)
  end_of_the_line = max(workspaces.keys())+1
  if target in workspaces: # swap
    move_workspace(target,end_of_the_line)
    move_workspace(source,target)
    move_workspace(end_of_the_line,source)
  else:
    move_workspace(source,target)


def get_current_workspace(workspaces):
  for (k,v) in workspaces.items():
    if v['focused']: return (k,v)
  return (None,None)
  #return [k for k,v in workspaces if v['visible']][0]



def move_window_to_next_monitor(current_w,workspaces):
  monitor = current_w['output']
  monitors = sorted(set([v['output'] for (k,v) in workspaces.items()]))
  index = monitors.index(monitor)
  output = monitors[(index+1) % len(monitors)]
  move_window_to_output(output)


def get_monitor_ids(target_monitor,workspaces):
  return sorted([k for (k,v) in workspaces.items() if v['output'] == target_monitor])


# returns list item at index, or null if index is invalid
def safe_get(list,index):
  try: return list[index]
  except IndexError: return ""



def main():
  workspaces = get_workspaces()
  id,current_w = get_current_workspace(workspaces)
  if id == None: return
  monitor_ids = get_monitor_ids(current_w['output'],workspaces)
#  pp = pprint.PrettyPrinter(indent=4)
#  pp.pprint(workspaces)
#  return
  command = safe_get(sys.argv,1)
  direction = safe_get(sys.argv,2)

  target = None

  if direction == 'next':
    target = id+1
  elif direction == 'previous':
    target = id-1
  elif direction == 'end':
    target = max([k for (k,v) in workspaces.items()])+1
  elif direction == 'beginning':
    target = min([k for (k,v) in workspaces.items()])-1
  elif direction == 'next_on_monitor':
    target = monitor_ids[min((monitor_ids.index(id)+1),len(monitor_ids)-1)]
  elif direction == 'previous_on_monitor':
    target = monitor_ids[max((monitor_ids.index(id)-1),0)]


  if target!=None and target<0: target = 0 # put here because i3bar doesn't handle negative numbers nicely


  if command == 'move_workspace':
    move_to_workspace_with_push(id,target,workspaces)
  elif command == 'move_me':
    switch_to_workspace(target)
  elif command == 'move_window':
    move_window_to_workspace(target,follow=True)
  elif command == 'move_window_to_next_monitor':
    move_window_to_next_monitor(current_w,workspaces)

  elif command == 'float_with_storage':
    float_with_storage(workspaces)



def float_with_storage(workspaces):
  focused_window = my_filter(i3.get_tree()['nodes'])[0]
  window_class = focused_window['window_properties']['class']
  if window_class != None and len(window_class) > 1:
    window_class += "\n"
    found = False
    lines = []
    with open(floating_windows,'r+') as f:
      lines = f.readlines()
      print(repr(lines))
      print(repr(window_class))
      try:
        lines.remove(window_class)
      except ValueError:  # couldn't remove since it wasn't there
        lines.append(window_class)

    print(repr(lines))
    with open(floating_windows,'w') as f:
      f.writelines(lines)
    i3.command('floating', 'toggle')
  return


# would use:
# i3.filter(nodes=[], focused=True)[0]
# but it looks like it doesn't account for floating_nodes
def my_filter(parent):
  rv = []
  for child in parent:
    if len(child['nodes']) > 0 or len(child['floating_nodes']) > 0:
      rv += my_filter(child['nodes'])
      rv += my_filter(child['floating_nodes'])
    else:
      if child['focused']:
        rv.append(child)
  return rv


main()


  #  target = sys.stdin.readlines()[0][0:-1]

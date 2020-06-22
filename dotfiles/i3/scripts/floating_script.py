#!/usr/bin/python3
import i3
import os

import pprint


floating_windows = os.path.expanduser('~/.i3/scripts/floating_windows_list.txt')

def main():
  with open(floating_windows,'r') as f:
    lines = f.readlines()
    for line in lines:
      os.system("i3-msg '[class=%s] floating enable'" % (line.strip()))
      #os.system("i3-msg for_window [class=%s] floating enable" % (line.strip()))
      #i3.command('for_window', "[class=%s]" % (line.strip()), 'floating', 'enable')
      #i3.command("[class=%s]" % (line.strip()), 'floating', 'enable')


main()


  #  target = sys.stdin.readlines()[0][0:-1]

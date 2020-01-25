import sys
import re

if len(sys.argv) != 3:
    raise Exception("Usage:  python remove_local.py toc.yml cutoc.yml")

inf_pathname = sys.argv[1]
outf_pathname = sys.argv[2]

inf = open(inf_pathname,"r")
outf = open(outf_pathname,"w")

pfx = ''
for l in inf:
    if re.match(r'^#\s+end\s+local\s*$',l):
        pfx = ''
    outf.write(pfx)
    outf.write(l)
    if re.match(r'^#\s+begin\s+local\s*$',l):
        pfx = '#'
    
inf.close()
outf.close()

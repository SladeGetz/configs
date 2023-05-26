#!/home/slarch/.venv/base/bin/python3

from subprocess import check_output
import re
from i3_util import markup, MEMORY

mem_stats = check_output(['fastfetch', '--pipe'], universal_newlines=True)
m = re.search(r'Memory: (\d*.*B) /.*(\(.*\))', mem_stats)

print(markup(MEMORY, '#0aa1ff'), m.group(1), m.group(2))

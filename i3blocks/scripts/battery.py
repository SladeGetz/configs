#!/home/slarch/.venv/base/bin/python3

from subprocess import check_output
import re
from i3_util import markup, BOLT, BAT_EMPTY, BAT_QUARTER, BAT_HALF, BAT_3QUARTER, BAT_FULL 

bat_stats = check_output(['acpi'], universal_newlines=True)
m = re.search(r'.*: (\w*), (\d*)', bat_stats)

charge = m.group(1)
percent = int(m.group(2))
result='' if charge != 'Full' else markup(BOLT, '#f1fa73')+' '

if percent > 90:
    result+=markup(BAT_FULL, '#85fa73')
elif percent > 70:
    result+=markup(BAT_3QUARTER, '#cffa73')
elif percent > 40:
    result+=markup(BAT_HALF, '#faef73')
elif percent > 20:
    result+=markup(BAT_QUARTER, '#fab273')
else:
    result+=markup(BAT_EMPTY, '#fa7373')

print(result, m.group(2)+'%')

#!/usr/bin/bash

if [[ "$(ps -x | grep -c ssh-agent)" -gt 1 ]]; then
    echo "<span font='FontAwesome'> &#xf120; </span>"
fi

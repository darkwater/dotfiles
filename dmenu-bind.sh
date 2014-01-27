#!/bin/bash
exe=`dmenu_run -i -f  -p 'start'                            \
               -fn 'Droid Sans Mono-10Droid Sans Mono-10'   \
               -b -q -t -w 820                              \
               -class 'dmenu'                               \
               -h 24                                        \
               -nb '#1d1f21' -nf '#ababab'                  \
               -sb '#111111' -sf '#ffaf00'`                && eval "exec $exe"

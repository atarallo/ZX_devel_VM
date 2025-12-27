#!/bin/sh
#
#

_TPUT_CMD='/usr/bin/tput'
_USER_ID=$(/usr/bin/id -u)
_OLD_TERM=${TERM}

export TERM=${_OLD_TERM}

if [ -x ${_TPUT_CMD} ]; then

        if [ -n "${TERM}" ]; then
                export TERM=xterm
        fi
        _GREEN=$(${_TPUT_CMD} setaf 2)
        _BLUE=$(${_TPUT_CMD} setaf 4)
        _RED=$(${_TPUT_CMD} setaf 1)
        _WHITE=$(${_TPUT_CMD} setaf 7)
        _RESET=$(${_TPUT_CMD} sgr0)
        _BOLD=$(${_TPUT_CMD} bold)

        if [ ${_USER_ID} -eq 0 ]; then
        # ROOT
                export PS1="[${_RED}\u${_RESET}@${_BOLD}${_RED}\h${_RESET} \W]\#"
        else
        # All other user
                case ${USER} in
                        'oracle')
                                export PS1="[${_BOLD}${_WHITE}\u${_RESET}@${_RED}\h${_RESET} \W]\$"
                        ;;
                        'mysql')
                                export PS1="[${_BOLD}${_WHITE}\u${_RESET}@${_RED}\h${_RESET} \W]\$"
                        ;;
                        'postgres')
                                export PS1="[${_BOLD}${_WHITE}\u${_RESET}@${_RED}\h${_RESET} \W]\$"
                        ;;
                        'zimbra')
                                export PS1="[${_BOLD}${_WHITE}\u${_RESET}@${_RED}\h${_RESET} \W]\$"
                        ;;
                        *)
                                export PS1="[${_WHITE}\u${_RESET}@${_GREEN}\h${_RESET} \W]\$"
                        ;;
                esac
        fi
else
# TPUT not availiable
	if [ ${_USER_ID} -eq 0 ]; then
		export  PS1="[\e[0;32m\u\e[m@\e[0;32m\h\e[m \W]\#"
	else
		export  PS1="[\e[0;32m\u\e[m@\e[0;32m\h\e[m \W]\$"
	fi
fi


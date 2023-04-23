function prompt_soysource_min_setup(){
setopt PROMPT_SUBST 

function git_branch() {
  precmd_update_git_vars
  echo -n "$(git name-rev --name-only HEAD 2> /dev/null)"
}

function host_color() {
  HOSTNUM=$(hostname)
  if [ -z ${SSH_CONNECTION} ]; then
    COLORID=0
    export COLORHOST=""
  else
    if [ ${#HOSTNUM} -lt 5 ]; then
      HOSTID=${HOSTNUM}
    else
      expr "${HOSTNUM: -2:1}" + 1 >/dev/null 2>&1
      if [ $? -lt 2 ]; then 
        HOSTID=${HOSTNUM: -2:2}
      else
        expr "${HOSTNUM: -3:1}" + 1 >/dev/null 2>&1
        if [ $? -lt 2 ]; then 
          HOSTID=$[4 - ${HOSTNUM: -3:1}]${HOSTNUM: -1:1}
        else
          HOSTID=${HOSTNUM: -3:1}${HOSTNUM: -1:1}
        fi
      fi
    fi
    expr "${HOSTID: -2:1}" + 1 >/dev/null 2>&1
    if [ $? -lt 2 ]; then 
      if [ ${HOSTID} = "w" ]; then
        COLORID=20
      elif [ ${HOSTID} -eq 30 ]; then
        COLORID=22
      elif [ ${HOSTID} -ge 40 ] && [ ${HOSTID} -lt 50 ]; then
        COLORID=$[$HOSTID + 180]
      elif [ ${HOSTID} -gt 30 ] && [ ${HOSTID} -lt 40 ]; then
        NUM1=$[$HOSTID - 31]
        COLORID=$[$NUM1 % 2 + 28 + 6 * $[$NUM1 / 2]]
      elif [ ${HOSTID} -ge 50 ]; then
        NUM2=$[$HOSTID - 50]
        COLORID=$[$NUM2 % 2 + 26 + 6 * $[$NUM2 / 2]]
      else
        COLORID=14
      fi
    else
      COLORID=13
    fi
    echo "%{%B%K{${COLORID}}%F{233} ssh %f%k%}"
  fi
}

 
setopt prompt_subst

RPROMPT='%F{cyan}%~%f'
PROMPT='$(host_color)%(?.%{%B%K{230}%F{64}%} %n@%m %k%f.%{%B%K{230}%F{160}%} %n@%m %k%f)%(?.%{%B%K{71}%F{230}%} %T %D %{%b%k%f%}.%{%B%K{160}%F{230}%} %T %D %{%b%k%f%})%B
%(?,%F{green},%F{red})%(!,#,>>>)%f%b '
}

prompt_soysource_min_setup "$@"
# vim: filetype=zsh

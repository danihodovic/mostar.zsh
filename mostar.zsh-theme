setopt prompt_subst

turquoise="%F{81}"
lightblue="%F{111}"
orange="%F{166}"
purple="%F{135}"
hotpink="%F{161}"
limegreen="%F{118}"
red="%F{196}"
yellow="%F{226}"
purple="%F{135}"
reset="%f"

function k8s_info {
  k8s_context=$(cat ~/.kube/config | grep "current-context:" | sed "s/current-context: //")
  if [ ! -z $k8s_context ]; then
    echo "${purple}k8s ★ $k8s_context"
  fi
}

function aws_info {
  if [ ! -z $AWS_PROFILE ]; then
    echo "${lightblue}aws ☢ $AWS_PROFILE"
  fi
}

function has_git_untracked_files {
  git ls-files --other --exclude-standard 2> /dev/null | grep -q "."
}

# Hack around untracked files not being detected in vcs_info prompt by default
function detect_git_untracked_files {
  if has_git_untracked_files; then
    zstyle ':vcs_info:*' formats "| $turquoise✩ git: %b %c $orange✖"
  else
    zstyle ':vcs_info:*' formats "| $turquoise✩ git: %b %c %u"
  fi
}

autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true

zstyle ':vcs_info:*' formats "| $turquoise✩ git: %b %c %u"
zstyle ':vcs_info:*' actionformats "| $red✩ git: %b %a %c %u"
zstyle ':vcs_info:*' unstagedstr "$orange✖"
zstyle ':vcs_info:*' stagedstr "$limegreen✔"

precmd () {
  detect_git_untracked_files
  vcs_info 'prompt'
}

dir="%~"
clock="%*"

PROMPT=$'${yellow}${clock} ${dir} ${vcs_info_msg_0_} | $(k8s_info) | $(aws_info)
${yellow}$ '


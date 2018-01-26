
function __fzy_get_directories_db
  # Locate lists all files, and directories without a '/' on the end :/
  # 1. Get only entries starting with $PWD
  # 2. Trim $PWD
  # 3. Filter hidden files (and directories)
  # 4. Trim the filename by dropping everything after the last /
  # 5. Uniquify (locate output should be sorted)
  command locate "$PWD" \
    | command grep '^'"$PWD/"'.*/' \
    | command sed 's#'$PWD'/##' \
    | command grep -v -E "^\." \
    | command sed 's#/[^/]*$##' \
    | uniq
end

function __fzy_get_directories_raw
  if which fd >/dev/null ^/dev/null
    echo "fd"
    command fd . -t d
  else
    command find . \( -path '*/\\.*' -o -fstype 'dev' -o -fstype 'proc' \) -prune  -o -type d -print ^/dev/null \
      | command tail -n+2 \
      | command sed 's#\./##'
  end
end

function __fzy_get_directories
  set -l use_db "yes"
  if command git rev-parse --show-toplevel >/dev/null ^/dev/null
    set use_db "no"
  else if which hg >/dev/null ^/dev/null and command hg root >/dev/null ^/dev/null
    set use_db "no"
  else
    set -l fs (df $PWD | tail -n+2 | awk '{print $1}')
    switch $fs
      case 'tmpfs'
        set use_db "no"
      case '*'
        set use_db "yes"
    end
  end

  if not which locate >/dev/null ^/dev/null
    set use_db "no"
  end

  set -q FZY_ENABLE_DB or set -l FZY_ENABLE_DB "no"

  if [ "$FZY_ENABLE_DB" != "yes" ]
    set use_db "no"
  end

  switch $use_db
    case 'yes'
      __fzy_get_directories_db
    case '*'
      __fzy_get_directories_raw
  end
end

function fzy_select_directory
  __fzy_get_directories | fzy | read -l foo
  if [ $foo ]
    cd $foo
  end
end


function __fzy_get_directory_list -d 'Get a list of directories using fd or find'
  if which fd >/dev/null ^/dev/null
    command fd . -t d
  else
    command find . \( -path '*/\\.*' -o -fstype 'dev' -o -fstype 'proc' \) -prune  -o -type d -print ^/dev/null \
      | command tail -n+2 \
      | command sed 's#\./##'
  end
end

function fzy_select_directory -d 'cd to a directory using fzy'
  __fzy_get_directory_list | fzy | read -l foo
  if [ $foo ]
    cd $foo
  end
  commandline -f repaint
end

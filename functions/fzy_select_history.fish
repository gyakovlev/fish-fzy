function fzy_select_history
  if test (count $argv) = 0
    set fzy_flags
  else
    set fzy_flags -q "$argv"
  end
  history|fzy $fzy_flags|read -l foo
  commandline -f repaint
  commandline $foo
end

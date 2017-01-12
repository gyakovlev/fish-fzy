function fzy_select_history
  if test (count $argv) = 0
    set fzy_flags
  else
    set fzy_flags -q "$argv"
  end

  history|fzy $fzy_flags|read foo

  if [ $foo ]
    commandline $foo
  else
    commandline ''
  end
end

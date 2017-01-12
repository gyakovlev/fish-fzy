function fkill
  ps ax -o pid,time,command | fzy -q "$LBUFFER" | awk '{print $1}' | xargs kill
end

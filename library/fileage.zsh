_woot_is_newer_than() {
  local a=$1 
  local b=$2 

  local mtime_a=$(stat -c '%Y' "$a")
  local mtime_b=$(stat -c '%Y' "$b")

  if [[ ! -f $b ]]; then 
    return 1
  fi

  [[ $mtime_a -le $mtime_b ]]
}
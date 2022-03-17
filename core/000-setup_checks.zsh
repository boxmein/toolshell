declare -a _woot_setup_checks

_woot_create_setup_check() {
  _woot_setup_checks+=("$*")
}

_woot_invoke_setup_checks() {
  for check in $_woot_setup_checks; do 
    $SHELL -c "${check}" || echo "Error: $check failed." && exit 1
  done
}
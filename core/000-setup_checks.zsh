declare -a _toolshell_setup_checks

_toolshell_create_setup_check() {
  _toolshell_setup_checks+=("$*")
}

_toolshell_invoke_setup_checks() {
  for check in $_toolshell_setup_checks; do 
    ${=check} || echo "Error: $check failed." && exit 1
  done
}
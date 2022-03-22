
_woot_initialize() {
  local check_command=$1
  local fix_command=$2
  ${=check_command} || ${=fix_command}
}
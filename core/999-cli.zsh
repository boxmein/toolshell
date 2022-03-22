_woot_verbose=false

_woot_parse_cli_and_invoke() {

  _woot_invoke_setup_checks

  local didSomething=0
  while [[ $# -gt 0 ]]; do
    case $1 in
      -vv)
        _woot_verbose=true
        set -x
        ;;
      -v)
        _woot_verbose=true
        ;;
      -h|--help)
        _woot_usage
        didSomething=1
        ;;
      build)
        _woot_invoke_build_command
        didSomething=1
        ;;
      start)
        _woot_invoke_start_command
        didSomething=1
        ;;
      run)
        shift
        _woot_invoke_task "$*"
        didSomething=1
        ;;
      clean|cleanup)
        _woot_invoke_cleanup
        didSomething=1
        ;;
      *)
        _woot_fallback "$*"
        didSomething=1
        ;;
    esac
    shift
  done

  if [[ "$didSomething" -ne 1 ]]; then 
    _woot_fallback "$*"
  fi
}

alias woot='_woot_parse_cli_and_invoke $*'
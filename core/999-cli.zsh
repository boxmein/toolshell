_toolshell_verbose=false

_toolshell_parse_cli_and_invoke() {
  _toolshell_invoke_setup_checks

  local didSomething=0
  while [[ $# -gt 0 ]]; do
    case $1 in
      -vv)
        _toolshell_verbose=true
        set -x
        ;;
      -v)
        _toolshell_verbose=true
        ;;
      -h|--help)
        _toolshell_usage
        didSomething=1
        ;;
      build)
        _toolshell_invoke_build_command
        didSomething=1
        ;;
      start)
        _toolshell_invoke_start_command
        didSomething=1
        ;;
      run)
        shift
        _toolshell_invoke_task "$*"
        didSomething=1
        ;;
      clean|cleanup)
        _toolshell_invoke_cleanup
        didSomething=1
        ;;
      *)
        _toolshell_fallback "$*"
        didSomething=1
        ;;
    esac
    shift
  done

  if [[ "$didSomething" -ne 1 ]]; then 
    _toolshell_fallback "$*"
  fi
}

alias toolshell_main='_toolshell_parse_cli_and_invoke $*'

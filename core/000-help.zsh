_toolshell_usage() {
  local toolName=${SCRIPT_NAME:-toolshell}
  local projectName=${PROJECT_NAME:-this project}
  cat <<EOF
$toolName - tooling for $projectName

usage: 

  $toolName [args]

  where:

            -v:   enable verbose mode for the build tool
           -vv:   enable verbose mode for the build tool and set -x
    -h, --help:   get this help text
EOF
  _toolshell_help_start_command
  _toolshell_help_build_command
  _toolshell_help_cleanup
  _toolshell_help_tasks
}
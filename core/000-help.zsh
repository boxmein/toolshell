_woot_usage() {
  local toolName=${TOOL_NAME:-buildtool}
  local projectName=${PROJECT_NAME:-this project}
  cat <<EOF
$toolName - tooling for $projectName

usage: 

  $toolName [args]

  where:

            -v:   enable verbose mode for the build tool
    -h, --help:   get this help text
EOF
  _woot_help_start_command
  _woot_help_build_command
  _woot_help_cleanup
  _woot_help_tasks
}
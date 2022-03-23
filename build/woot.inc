_woot_use_package_manager() {
  return command -v $1 >/dev/null 2>/dev/nul
}

_woot_confirm() {
  read -p "$1 [y/N] " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    return 1
  fi
}

_woot_try_install_package() {
  set +e
  _woot_use_package_manager apt && apt install $1
  _woot_use_package_manager apt-get && apt-get install $1
  _woot_use_package_manager yum && yum install $1
  _woot_use_package_manager dnf && dnf install $1
  _woot_use_package_manager brew && \
    _woot_confirm "Install $1 with Homebrew?" && brew install $1
  _woot_use_package_manager yay && \
    _woot_confirm "Install $1 with yay?" && yay -S $1
  _woot_use_package_manager yaourt && \
    _woot_confirm "Install $1 with yaourt?" && yaourt -S $1
  _woot_use_package_manager emerge && \
    _woot_confirm "Install $1 with emerge?" && emerge $1
  _woot_use_package_manager apk && \
    _woot_confirm "Install $1 with apk?" && apk add $1
  _woot_use_package_manager port && \
    _woot_confirm "Install $1 with MacPorts?" && port install $1
  set -e
}_woot_docker_has_image() {
  local image="$1"
  local image_id
  image_id="$(docker images "$image" --format '{{.ID}}')"
  if [ -n "$image_id" ]; then
    return 0
  else
    return 1
  fi
}

_woot_docker_image_age() {
  local image="$1"
  local image_id
  image_id="$(docker images "$image" --format '{{.ID}}')"
  if [ -n "$image_id" ]; then
    local image_age
    image_age="$(docker images "$image" --format '{{.CreatedSince}}')"
    echo "$image_age"
  fi
}
_woot_is_newer_than() {
  local a=$1 
  local b=$2 

  local mtime_a=$(stat -c '%Y' "$a")
  local mtime_b=$(stat -c '%Y' "$b")

  if [[ ! -f $b ]]; then 
    return 1
  fi

  [[ $mtime_a -le $mtime_b ]]
}_woot_fs_file_modified_time() {
  stat -c '%Y' $1
}

_woot_git_file_modified_time() {
  local file="$1"
  local time=$(git log -1 --format=%at "$file")
  echo $time
}

_woot_git_get_staged_files() {
  git diff --cached --name-only --diff-filter=ACM
}
_woot_version_matches_caret_range() {
  local desired_caret_range=$1 # ^1.2.3
  local actual_version=$2 

  # ^1.2.3 matches 1.2.3 - 1.9999.9999
  local version=${desired_caret_range#\^}

  local -a desired_parts=( ${=version//./ } )
  local -a actual_parts=( ${=actual_version//./ } )

  local major_matches=$([[ ${actual_parts[1]} -eq ${desired_parts[1]} ]] && echo true || echo false)
  local minor_matches=$([[ ${actual_parts[2]} -ge ${desired_parts[2]} ]] && echo true || echo false)
  local patch_matches=$([[ ${actual_parts[3]} -ge ${desired_parts[3]} ]] && echo true || echo false)
  if [[
    $major_matches == "true" &&
    $minor_matches == "true" &&
    $patch_matches == "true"
  ]]; then
    return 0
  else
    return 1
  fi
}

_woot_version_matches_tilde_range() {
  local desired_caret_range=$1
  local actual_version=$2
  # ~1.2.3 matches 1.0.0 - 1.0.9999
  local version=${desired_caret_range#~}

  local -a desired_parts=( ${=version//./ } )
  local -a actual_parts=( ${=actual_version//./ } )

  local major_matches=$([[ ${actual_parts[1]} -eq ${desired_parts[1]} ]] && echo true || echo false)
  local minor_matches=$([[ ${actual_parts[2]} -eq ${desired_parts[2]} ]] && echo true || echo false)
  local patch_matches=$([[ ${actual_parts[3]} -ge ${desired_parts[3]} ]] && echo true || echo false)
  if [[
    $major_matches == "true" &&
    $minor_matches == "true" &&
    $patch_matches == "true"
  ]]; then
    return 0
  else
    return 1
  fi
}

_woot_version_matches_gte_range() {
  local desired_caret_range=$1
  local actual_version=$2
  # >= 1.2.3 matches 1.2.3 - 9999.9999.9999
  local version=${desired_caret_range#\>=}
  local -a desired_parts=( ${=version//./ } )
  local -a actual_parts=( ${=actual_version//./ } )

  local major_matches=$([[ ${actual_parts[1]} -ge ${desired_parts[1]} ]] && echo true || echo false)
  local minor_matches=$([[ ${actual_parts[2]} -ge ${desired_parts[2]} ]] && echo true || echo false)
  local patch_matches=$([[ ${actual_parts[3]} -ge ${desired_parts[3]} ]] && echo true || echo false)
  if [[
    $major_matches == "true" &&
    $minor_matches == "true" &&
    $patch_matches == "true"
  ]]; then
    return 0
  else
    return 1
  fi
}

_woot_version_matches_lte_range() {
  local desired_caret_range=$1
  local actual_version=$2
  # >= 1.2.3 matches 1.2.3 - 9999.9999.9999
  local version=${desired_caret_range#\>=}
  local -a desired_parts=( ${=version//./ } )
  local -a actual_parts=( ${=actual_version//./ } )

  local major_matches=$([[ ${actual_parts[1]} -le ${desired_parts[1]} ]] && echo true || echo false)
  local minor_matches=$([[ ${actual_parts[2]} -le ${desired_parts[2]} ]] && echo true || echo false)
  local patch_matches=$([[ ${actual_parts[3]} -le ${desired_parts[3]} ]] && echo true || echo false)
  if [[
    $major_matches == "true" &&
    $minor_matches == "true" &&
    $patch_matches == "true"
  ]]; then
    return 0
  else
    return 1
  fi
}

_woot_version_matches_dash_range() {
  local desired_dash_range=$1
  local actual_version=$2

  # 1.0.0-1.2.3 = >= 1.0.0 <= 1.2.3

  local versions=(${=desired_dash_range//-/ })

  _woot_version_matches_gte_range ${versions[0]} $actual_version
  _woot_version_matches_lte_ranmge ${versions[1]} $actual_version
}

_woot_version_matches_range() {
  local desired_version_range=$1 
  local actual_version=$2

  echo "desired $desired_version_range actual $actual_version"

  case $desired_version_range in
    '^'*)
      _woot_version_matches_caret_range $desired_version_range $actual_version
      return $?
      ;;
    '~'*)
      _woot_version_matches_tilde_range $desired_version_range $actual_version
      return $?
      ;;
    '>'*)
      _woot_version_matches_gt_range $desired_version_range $actual_version
      return $?
      ;;
    '>='*)
      _woot_version_matches_gte_range $desired_version_range $actual_version
      return $?
      ;;
    *-*);
      _woot_version_matches_dash_range $desired_version_range $actual_version
      return $?
      ;;
  esac

  echo "done"
}_woot_sync_path() {
  source_path=$1
  target_host_and_path=$2
  rsync -razv "$source_path" "$target_path"
}

_woot_watch_path_for_changes() {
  source_path=$1
  target_host_and_path=$2

  while true; do 
    rsync -razv --delete "$source_path" "$target_path"
    sleep 1
  done
}_woot_build_command=""

_woot_set_build_command() {
  _woot_build_command="$1"
}

_woot_invoke_build_command() {
  ${=_woot_build_command}
}

_woot_help_build_command() {
  if [[ -n "$_woot_build_command" ]]; then 
    echo "         build:   build $projectName"
  fi
}declare -a _woot_cleanup_folders

_woot_declare_cleanup_folders() {
  _woot_cleanup_folders=($*)
}

_woot_invoke_cleanup() {
  for folder in $_woot_cleanup_folders; do
    rm -rf $folder;
  done
}

_woot_help_cleanup() {
  if [[ -n "${_woot_clean_folders}" ]]; then
    echo  "         clean:   remove output folders"
  fi
}_woot_fuzzy_ui() {
  task_to_run=$(echo start.build.${(j:.:)${(k)_woot_task_map}} | tr '.' '\n' | fzf)
  echo "Running ./x $task_to_run"
  _woot_invoke_task "$task_to_run"
}

_woot_fallback() {
  if [[ -n "${_woot_task_map[$*]}" ]]; then 
    _woot_invoke_task "$*"
  else
    _woot_fuzzy_ui "$*"
  fi
}
_woot_git_hook_pre_commit() {
  ln -sf "$1" .git/hooks/pre-commit
}
_woot_usage() {
  local toolName=${TOOL_NAME:-buildtool}
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
  _woot_help_start_command
  _woot_help_build_command
  _woot_help_cleanup
  _woot_help_tasks
}
_woot_initialize() {
  local check_command=$1
  local fix_command=$2
  ${=check_command} || ${=fix_command}
}declare -a _woot_setup_checks

_woot_create_setup_check() {
  _woot_setup_checks+=("$*")
}

_woot_invoke_setup_checks() {
  for check in $_woot_setup_checks; do 
    ${=check} || echo "Error: $check failed." && exit 1
  done
}_woot_start_command=""

_woot_set_start_command() {
  _woot_start_command="$1"
}

_woot_help_start_command() {
  if [[ -n "$_woot_start_command" ]]; then 
    echo "         start:   start the dev mode"
  fi
}

_woot_invoke_start_command() {
  ${=_woot_start_command}
}
declare -A _woot_task_map

_woot_help_tasks() {
  if [[ -n "${(k)_woot_task_map}" ]]; then 
    echo "          run:   start a script for $projectName"
    echo
    echo "available scripts: "
    for task in ${(k)_woot_task_map}; do
      echo "$toolName $task"
    done
  fi
}

_woot_create_task_command() {
  _woot_task_map[$1]="$2"
}

_woot_invoke_task() {
  ${=_woot_task_map[$*]}
}source $(dirname $0)/../library/dependency_installer.zsh

_woot_check_tool_in_path() {
  local offer_install=false
  if [[ "$1" == "--offer-install" ]]; then
    offer_install=true
    shift
  fi 

  tool_name="$1"
  tool_expected_version="$2"

  if ! command -v "$tool_name" >/dev/null 2>/dev/null; then 
    echo "Tool not found: $tool_name"
    
    if [[ "$offer_install" == "true" ]]; then 
      _woot_try_install_package "$tool_name"
    else
      return 1
    fi
  fi

  tool_version=$(${tool_name} --version)
  if [[ "$tool_version" != *${tool_expected_version}* ]]; then 
    echo "Tool is the wrong version: $tool_name $tool_version"
    echo "Expected $tool_expected_version"
    return 1
  fi
}alias tool='_woot_check_tool_in_path'
alias start='_woot_set_start_command'
alias check='_woot_create_setup_check'
alias build="_woot_set_build_command"
alias run="_woot_create_task_command"
alias cleanup="_woot_declare_cleanup_folders"
alias init='_woot_initialize'_woot_verbose=false

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
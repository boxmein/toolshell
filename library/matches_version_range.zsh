
_toolshell_version_matches_caret_range() {
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

_toolshell_version_matches_tilde_range() {
  local desired_caret_range=$1
  local actual_version=$2
  # ~1.2.3 matches 1.0.0 - 1.0.9999
  local version=${desired_caret_range#'~'}

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

_toolshell_version_matches_gte_range() {
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

_toolshell_version_matches_lte_range() {
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

_toolshell_version_matches_dash_range() {
  local desired_dash_range=$1
  local actual_version=$2

  # 1.0.0-1.2.3 = >= 1.0.0 <= 1.2.3

  local versions=(${=desired_dash_range//-/ })

  _toolshell_version_matches_gte_range ${versions[0]} $actual_version
  _toolshell_version_matches_lte_ranmge ${versions[1]} $actual_version
}

_toolshell_range_matches_version() {
  local desired_version_range=$1 
  local actual_version=$2

  case $desired_version_range in
    '^'*)
      _toolshell_version_matches_caret_range $desired_version_range $actual_version
      return $?
      ;;
    '~'*)
      _toolshell_version_matches_tilde_range $desired_version_range $actual_version
      return $?
      ;;
    '>'*)
      _toolshell_version_matches_gt_range $desired_version_range $actual_version
      return $?
      ;;
    '>='*)
      _toolshell_version_matches_gte_range $desired_version_range $actual_version
      return $?
      ;;
    *-*);
      _toolshell_version_matches_dash_range $desired_version_range $actual_version
      return $?
      ;;
  esac

  echo "done"
}
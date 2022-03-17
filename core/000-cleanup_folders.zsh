declare -a _woot_cleanup_folders

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
}
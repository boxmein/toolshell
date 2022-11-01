declare -a _toolshell_cleanup_folders

_toolshell_declare_cleanup_folders() {
  _toolshell_cleanup_folders=($*)
}

_toolshell_invoke_cleanup() {
  for folder in $_toolshell_cleanup_folders; do
    rm -rf $folder;
  done
}

_toolshell_help_cleanup() {
  if [[ -n "${_toolshell_clean_folders}" ]]; then
    echo  "         clean:   remove output folders"
  fi
}
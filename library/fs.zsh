_toolshell_fs_file_modified_time() {
  stat -c '%Y' $1
}

_toolshell_git_file_modified_time() {
  local file="$1"
  local time=$(git log -1 --format=%at "$file")
  echo $time
}


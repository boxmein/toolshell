_woot_fs_file_modified_time() {
  local file="$1"
  local time=$(stat -f %m "$file")
  echo $time
}

_woot_git_file_modified_time() {
  local file="$1"
  local time=$(git log -1 --format=%at "$file")
  echo $time
}


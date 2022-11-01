_toolshell_sync_path() {
  source_path=$1
  target_host_and_path=$2
  rsync -razv "$source_path" "$target_path"
}

_toolshell_watch_path_for_changes() {
  source_path=$1
  target_host_and_path=$2

  while true; do 
    rsync -razv --delete "$source_path" "$target_path"
    sleep 1
  done
}
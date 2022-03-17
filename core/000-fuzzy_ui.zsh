_woot_fuzzy_ui() {
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

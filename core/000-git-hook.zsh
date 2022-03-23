_woot_git_hook_pre_commit() {
  ln -sf "$1" .git/hooks/pre-commit
}

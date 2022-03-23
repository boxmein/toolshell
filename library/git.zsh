_woot_git_get_staged_files() {
  git diff --cached --name-only --diff-filter=ACM
}
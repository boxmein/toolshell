_toolshell_use_package_manager() {
  return command -v $1 >/dev/null 2>/dev/nul
}

_toolshell_confirm() {
  read -p "$1 [y/N] " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    return 1
  fi
}

_toolshell_try_install_package() {
  set +e
  _toolshell_use_package_manager apt && apt install $1
  _toolshell_use_package_manager apt-get && apt-get install $1
  _toolshell_use_package_manager yum && yum install $1
  _toolshell_use_package_manager dnf && dnf install $1
  _toolshell_use_package_manager brew && \
    _toolshell_confirm "Install $1 with Homebrew?" && brew install $1
  _toolshell_use_package_manager yay && \
    _toolshell_confirm "Install $1 with yay?" && yay -S $1
  _toolshell_use_package_manager yaourt && \
    _toolshell_confirm "Install $1 with yaourt?" && yaourt -S $1
  _toolshell_use_package_manager emerge && \
    _toolshell_confirm "Install $1 with emerge?" && emerge $1
  _toolshell_use_package_manager apk && \
    _toolshell_confirm "Install $1 with apk?" && apk add $1
  _toolshell_use_package_manager port && \
    _toolshell_confirm "Install $1 with MacPorts?" && port install $1
  set -e
}
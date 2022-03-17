_woot_use_package_manager() {
  return command -v $1 >/dev/null 2>/dev/nul
}

_woot_confirm() {
  read -p "$1 [y/N] " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    return 1
  fi
}

_woot_try_install_package() {
  set +e
  _woot_use_package_manager apt && apt install $1
  _woot_use_package_manager apt-get && apt-get install $1
  _woot_use_package_manager yum && yum install $1
  _woot_use_package_manager dnf && dnf install $1
  _woot_use_package_manager brew && \
    _woot_confirm "Install $1 with Homebrew?" && brew install $1
  _woot_use_package_manager yay && \
    _woot_confirm "Install $1 with yay?" && yay -S $1
  _woot_use_package_manager yaourt && \
    _woot_confirm "Install $1 with yaourt?" && yaourt -S $1
  _woot_use_package_manager emerge && \
    _woot_confirm "Install $1 with emerge?" && emerge $1
  _woot_use_package_manager apk && \
    _woot_confirm "Install $1 with apk?" && apk add $1
  _woot_use_package_manager port && \
    _woot_confirm "Install $1 with MacPorts?" && port install $1
  set -e
}
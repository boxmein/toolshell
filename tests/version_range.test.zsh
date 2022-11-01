#!/usr/bin/env zunit 
# note: ZUnit only accepts single quotes in @test 'name' section

@test 'tilde ranges work' {
  load ../library/matches_version_range.zsh

  _assert_succeeds() {
    local range=$1
    local version=$2
    _toolshell_version_matches_range $range $version && pass || fail
  }

  _assert_fails() {
    local range=$1
    local version=$2
    _toolshell_version_matches_range $range $version && fail || pass
  }

  _assert_succeeds "~1.0.0" "1.0.0"
  _assert_succeeds "~1.0.0" "1.0.1"
  _assert_succeeds "~1.0.0" "1.0.9999"
  _assert_fails "~1.0.0" "1.1.0"
  _assert_fails "~1.0.0" "1.999.999"
  _assert_fails "~1.0.0" "999.0.0"
}

@test 'caret ranges work' {
  load ../library/matches_version_range.zsh

  _assert_succeeds() {
    local range=$1
    local version=$2
    _toolshell_version_matches_range $range $version && pass || fail
  }

  _assert_fails() {
    local range=$1
    local version=$2
    _toolshell_version_matches_range $range $version && fail || pass
  }

  _assert_succeeds "^1.0.0" "1.0.0"
  _assert_succeeds "^1.0.0" "1.0.1"
  _assert_succeeds "^1.0.0" "1.0.9999"
  _assert_succeeds "^1.0.0" "1.1.0"
  _assert_succeeds "^1.1.1" "1.2.0"
  _assert_fails "^2.0.0" "1.0.9999"
}

@test 'zunit works' {
  pass
}
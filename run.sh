#!/bin/bash
# Installer for versity-verify.sh

EMBEDDED_RUBY="/opt/chef/embedded/bin/ruby"
EMBEDDED_RUBY_URL="https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64/chef-11.4.4-2.el6.x86_64.rpm"
MYDIR=`dirname $0`
enable_debug="false"

if [[ $1 && $1 -eq "debug" ]]; then
  enable_debug="true"
fi

function D () {
  if [[ $enable_debug == true ]]; then
    echo "$1"
  fi
}

function install_embedded_ruby () {
  echo "We are going to install an isolated ruby version to"
  echo "/opt/chef - you can remove this version by running the"
  echo -n "uninstall.sh in this directory - proceed? [ y / n ] "
  read answer

  if [[ $answer != y && $answer != Y ]]; then
    echo "Aborting..."
    exit 1
  else
    rpm -ivh $EMBEDDED_RUBY_URL
  fi
}

function check_ruby_version () {
  path_to_ruby=$(which ruby)
  if [ -x "$path_to_ruby" ]; then
    ruby_version=$($path_to_ruby -v)
    if [[ $ruby_version =~ "1.9" ]]; then
      D "Ruby version 1.9 OK!"
      use_system_ruby="true"
    else
      echo "Ruby version is NOT 1.9"
      use_system_ruby="false"
    fi
  else
    use_system_ruby="false"
  fi
}

function check_embedded_ruby () {
  D "Ruby not found - looking for embedded ruby"
  if [ -x $EMBEDDED_RUBY ]; then
    D "Found embedded ruby - proceeding"
    return 1
  else
    D "Embedded ruby missing - installing"
    install_embedded_ruby
  fi
}

function run_versity_verify () {
  if [[ $use_system_ruby == true ]]; then
    ruby $MYDIR/versity-verify.rb
  else
    $EMBEDDED_RUBY $MYDIR/versity-verify.rb
  fi
}

# Check my UID
if [ $USER != "root" ] ; then
  echo "This must be run with root privs"
  exit
fi

# Check ruby version
check_ruby_version
if [[ $use_system_ruby == false ]]; then
  check_embedded_ruby
fi
run_versity_verify

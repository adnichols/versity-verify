#!/bin/bash
# Uninstalls the chef embedded ruby

EMBEDDED_RPM="chef-11.4.4-2.el6.x86_64"

echo -n "This will remove the embedded ruby from /opt/chef - continue? [ y / n ]"
read answer

if [[ $answer == y || $answer == Y ]]; then
  rpm -e $EMBEDDED_RPM
else
  echo "Aborting..."
  exit
fi
versity-verify
==============

Script to validate pre-install for versity

Requirements
============
This script requires ruby 1.9 and is presently ONLY designed for use on CentOS 6
If you are not familiar or comfortable getting ruby 1.9 on your system then
use this installer which will install an isolated version of ruby for use
with this script

<pre>
  # rpm -ivh https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64/chef-11.4.4-2.el6.x86_64.rpm
</pre>

Usage
=====
This script must be run as root. Usage via sudo should be fine. 

1. If running this script using an existing ruby 1.9 install:

<pre>
  $ sudo ruby versity-verify.rb
</pre>

2. If running with the above embedded ruby install

<pre>
  $ sudo /opt/chef/embedded/bin/ruby versity-verify.rb
</pre>

Expected Results
================

Output on a system should look something like this and should tell you if your
pre-requisites are setup correctly:

<pre>
*** Collecting System Information ***
Kernel release 2.6.32-279.el6.x86_64

*** Checking Package information ***
OK: kernel-devel FOUND!
OK: kexec-tools FOUND!
OK: cscope FOUND!
OK: strace FOUND!
FAIL: lsscsi MISSING!
FAIL: mtx MISSING!
FAIL: mt-st MISSING!
FAIL: crash MISSING!
WARN: ksh MISSING!
OK: gcc FOUND!
OK: bzip2 FOUND!
OK: bison FOUND!
OK: byacc FOUND!
OK: python FOUND!
WARN: mercurial MISSING!
OK: perl FOUND!
OK: make FOUND!
OK: gcc-c++ FOUND!
OK: tcsh FOUND!
WARN: mhvtl MISSING!
WARN: kmod-mhvtl MISSING!

*** Checking debug dependencies ***
FAIL: Missing crash kernel for 2.6.32-279.el6.x86_64
WARN: sysctl: kernel.sysrq is not set to 1, Magic Sysrq key will not work to capture kernel core
FAIL: Kdump is not configured correctly, we will be unable to capture core dumps

*** Checking security configuration ***
OK: Firewall disabled
OK: Selinux set to Disabled

*** Checking for CIS scripts ***
WARN: proc-daily-lops MISSING!
WARN: proc-samdump MISSING!
------------- RESULTS ---------------
OK: 15 / WARN: 7 / FAIL: 6
Testing FAILED - 6 outstanding problems
</pre>


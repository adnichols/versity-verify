versity-verify
==============

Script to validate pre-install for versity

Requirements
============
This script requires ruby 1.9 and is presently ONLY designed for use on CentOS 6

The run.sh script will take care of checking for a suitable ruby version and 
install a localized version if ruby is not on the system. There is an uninstall.sh
script which can be used to remove the localized ruby if you no longer want it.

The ruby package installed is provided by OpsCode and is their installer for 
the "chef" configuration management tool. If you have questions or concerns
about the contents of that installer you can view the source here:

https://github.com/opscode/omnibus-chef

Usage
=====
This script must be run as root. Usage via sudo should be fine. 

Run the run.sh script as root

<pre>
$ sudo ./run.sh
</pre>

It will prompt you if it needs to install the localized ruby and you will have
an opportunity to reject that option if you prefer not to do that. If the 
existing ruby is suitable or the localized ruby is already installed, it will
run the versity-check.rb script to validate the system setup. 

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


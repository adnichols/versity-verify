#!/usr/bin/env ruby
#
# Check the state of a system to determine
# if it is setup for debugging by Versity
#

require 'pp'

@failures = 0
@ok = 0
@warn = 0
raise 'This script must be run as root' unless Process.uid == 0

def puts_ok (msg)
  puts "OK: #{msg}"
  @ok += 1
end

def puts_warn (msg)
  puts "WARN: #{msg}"
  @warn += 1
end

def puts_fail (msg)
  puts "FAIL: #{msg}"
  @failures += 1
end

def summary
  puts "------------- RESULTS ---------------"
  puts "OK: #{@ok} / WARN: #{@warn} / FAIL: #{@failures}"
  if @failures > 0
    puts "Testing FAILED - #{@failures} outstanding problems"
  end
end

puts "*** Collecting System Information ***"
kernel_release = %x(uname -r).chomp
puts "Kernel release #{kernel_release}"

puts "*** Checking Package information ***"
# Get our package list
package_list = []
package_list = %x[ rpm -qa].split(/\n/)

# Critical packages
[ 
  'kernel-devel',
  'kexec-tools',
  'cscope',
  'strace',
  'lsscsi',
  'mtx',
  'mt-st',
  'crash'
].each do |pkg|
  if package_list.grep(/^#{pkg}/).empty?
    puts_fail "#{pkg} MISSING!"
  else
    puts_ok "#{pkg} FOUND!"
  end
end

# Warning packages
[ 
  'ksh', 
  'gcc', 
  'bzip2',
  'bison',
  'byacc',
  'python',
  'mercurial',
  'perl', 
  'make', 
  'gcc-c++', 
  'tcsh',
  'mhvtl',
  'kmod-mhvtl'
].each do |pkg|
  if package_list.grep(/^#{pkg}/).empty?
    puts_warn "#{pkg} MISSING!"
  else
    puts_ok "#{pkg} FOUND!"
  end
end

puts "*** Checking debug dependencies ***"
# Check for crashkernel
if File.exists?("/usr/lib/debug/lib/modules/#{kernel_release}/vmlinux")
  puts_ok "Found crash kernel for #{kernel_release}"
else
  puts_fail "Missing crash kernel for #{kernel_release}"
end

if %x(sysctl kernel.sysrq).chomp.split(/\=/)[1] !~ /1/
  puts_warn "sysctl: kernel.sysrq is not set to 1, Magic Sysrq key will not work to capture kernel core"
else
  puts_ok "sysctl: kernel.sysrq set to 1"
end

kdump_status = %x(/sbin/service kdump status)
if kdump_status =~ /Kdump is not operational/
  puts_fail "Kdump is not configured correctly, we will be unable to capture core dumps"
else
  puts_ok "Kdump is operational"
end

puts '*** Checking security configuration ***'
if %x(/sbin/service iptables status) =~ /Firewall is not running/
  puts_ok "Firewall disabled"
else
  puts_warn "IPtables enabled, check rules to make sure it will not interfere with operation"
  puts "--- Firewall rules in place ---"
  puts %x(/sbin/iptables -L -v)
  puts "--- END of Firewall rules ---"
end

puts '*** Checking for CIS scripts ***'
%w( proc-daily-lops proc-samdump).each do |cis_script|
  if File.exists?("/CIS/sbin/#{cis_script}")
    puts_ok "#{cis_script} FOUND!"
  else 
    puts_warn "#{cis_script} MISSING!"
  end
end

se_status = %x(/usr/sbin/getenforce)
if se_status =~ /Enforcing/
  puts_fail "Selinux set to 'Enforcing' which is likely to cause problems"
else
  puts_ok "Selinux set to #{se_status}"
end

summary

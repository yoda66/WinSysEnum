@echo off

FOR /F "tokens=2 delims='='" %%A in ('wmic os get csname /value') do SET csname=%%A

call:datetime
set out=%csname%-%DT%.txt
set version=V20140522-0930
echo [*] Windows System Analysis Script %version%
echo [*] Output file is [%CD%\%out%]

echo [*] %DT%: Writing output to [%out%]
echo [*] ===================================================== >%out%
echo [*] Windows System Analysis Script %version% >>%out%
echo [*] %DT%: Gathering Information from [%csname%] >>%out%
echo [*] ===================================================== >>%out%

call:runcmd %out% arp -a
call:runcmd %out% ipconfig /all
call:runcmd %out% ipconfig /displaydns
call:runcmd %out% net user
call:runcmd %out% net accounts
call:runcmd %out% net view /domain:%userdomain%
call:runcmd %out% net use
call:runcmd %out% net session
call:runcmd %out% net localgroup administrators
call:runcmd %out% net group "Domain Admins" /domain
call:runcmd %out% net group "Enterprise Admins" /domain
call:runcmd %out% net group "Domain Controllers" /domain

call:runcmd %out% sc query
call:runcmd %out% schtasks
call:runcmd %out% netstat -nr
call:runcmd %out% netstat -banov

call:runcmd %out% netsh firewall show state
call:runcmd %out% netsh firewall show config
call:runcmd %out% netsh firewall show logging
call:runcmd %out% netsh firewall show opmode
call:runcmd %out% netsh firewall show portopening

call:runcmd %out% reg query HKLM\Software\Microsoft\Windows\CurrentVersion\Run
call:runcmd %out% reg query HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce
call:runcmd %out% reg query HKLM\Software\Microsoft\Windows NT\CurrentVersion\ProfileList
call:runcmd %out% reg query HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall
call:runcmd %out% reg query HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU
call:runcmd %out% reg query HKLM\SYSTEM\CurrentControlSet\Enum\USBSTOR
call:runcmd %out% reg query HKLM\SYSTEM\CurrentControlSet\Enum\USB
call:runcmd %out% reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\MountPoints2
call:runcmd %out% reg query HKLM\Software\RealVNC\WinVNC4

call:datetime
echo [*] ==========================================
echo [*] %DT%: END OF COMMAND SEQUENCE
echo [*] ==========================================
echo [*] ========================================== >>%out%
echo [*] %DT%: END OF COMMAND SEQUENCE >>%out%
echo [*] ========================================== >>%out%
goto:exitnow

:runcmd
call:datetime
echo [*] %DT%: %2 %3 %4 %5 %6 %7 %8 %9
echo [*] %DT%: %2 %3 %4 %5 %6 %7 %8 %9 >>%1 2>&1
%2 %3 %4 %5 %6 %7 %8 %9 >>%1 2>&1
goto:eof


:datetime
set hour=%time:~0,2%
if "%hour:~0,1%" == " " set hour=0%hour:~1,1%
set min=%time:~3,2%
if "%min:~0,1%" == " " set min=0%min:~1,1%
set secs=%time:~6,2%
if "%secs:~0,1%" == " " set secs=0%secs:~1,1%
set year=%date:~-4%
set month=%date:~-10,2%
if "%month:~0,1%" == " " set month=0%month:~-10,2%
set day=%date:~-7,2%
if "%day:~0,1%" == " " set day=0%day:~-7,2%
set DT=%year%%month%%day%_%hour%%min%%secs%
goto:eof

:exitnow

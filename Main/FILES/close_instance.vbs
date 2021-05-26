Set WshShell = CreateObject("WScript.Shell" )
Set objShell = CreateObject("Wscript.shell")
objShell.run("powershell -ExecutionPolicy Bypass -File C:\WindowsTime\Main\help_sc\kill_pid.ps1")

Set WshShell = Nothing
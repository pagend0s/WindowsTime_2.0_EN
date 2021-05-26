Set WshShell = CreateObject("WScript.Shell" )
Set objShell = CreateObject("Wscript.shell")

WshShell.Run chr(34) & "C:\WindowsTime\Main\shutdown_time.bat" & Chr(34), 0

Set WshShell = Nothing 
Set WshShell = CreateObject("WScript.Shell" )
Set objShell = CreateObject("Wscript.shell")

WshShell.Run "cmd /c start /min  powershell -WindowStyle Hidden -ExecutionPolicy Bypass -File & C:\WindowsTime\Main\shutdown_time.bat" & Chr(34), 0

Set WshShell = Nothing 

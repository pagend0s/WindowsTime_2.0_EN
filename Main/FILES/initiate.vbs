Set WshShell = CreateObject("WScript.Shell" )
Set objShell = CreateObject("Wscript.shell")
objShell.run "cmd /c start /min  powershell -WindowStyle Hidden -ExecutionPolicy Bypass -File C:\WindowsTime\Main\help_sc\initiate_windows.ps1"" " & Chr(34), 0
Set WshShell = Nothing

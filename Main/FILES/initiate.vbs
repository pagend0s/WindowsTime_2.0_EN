Set WshShell = CreateObject("WScript.Shell" )
Set objShell = CreateObject("Wscript.shell")
objShell.run("powershell -WindowStyle Hidden -ExecutionPolicy Bypass -File C:\WindowsTime\Main\help_sc\initiate_windows.ps1")
Set WshShell = Nothing

$process_id = Get-CimInstance Win32_Process | where commandline -match 'shutdown_time.bat'  | Select ProcessId | ForEach-Object {$_ -replace '\D',''}
foreach ($i in $process_id) {
   Stop-Process $i -Force
 }

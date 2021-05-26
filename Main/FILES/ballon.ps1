Function Start-LogoffNotice {
    param (
        $IconPath = (Get-Process -id $pid | Select-Object -ExpandProperty Path),

        [ValidateSet("Info","Warning","Error","None")]
        $BalloonIcon,
        
        $BalloonText,

        $BalloonTitle,
        
        $BalloonTimeout = "900000"
    )

        Add-Type -AssemblyName System.Windows.Forms | Out-Null
        $objNotifyIcon = New-Object System.Windows.Forms.NotifyIcon 

        $objNotifyIcon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($IconPath)
        $objNotifyIcon.BalloonTipIcon = $BalloonIcon
        $objNotifyIcon.BalloonTipText = $BalloonText
        $objNotifyIcon.BalloonTipTitle = $BalloonTitle
        $objNotifyIcon.Visible = $True 
        $objNotifyIcon.ShowBalloonTip($BalloonTimeout)
        
        #This section doesn't seem to do anything.
        Register-ObjectEvent -InputObject $objNotifyIcon -EventName BalloonTipClosed -Action {                     
            Unregister-Event $objNotifyIcon.SourceIdentifier
            Remove-Job $objNotifyIcon.Action
            $objNotifyIcon.Dispose()
        } | Out-Null
    }

  
    $content_noti = Get-Content C:\WindowsTime\Main\Notify\notify2_vbs_notification -First 1
    $content_number = (Get-Content C:\WindowsTime\Main\Notify\notify2_vbs_notification  -TotalCount 2)[1]


#$windowcode = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
#$asyncwindow = Add-Type -MemberDefinition $windowcode -name Win32ShowWindowAsync -namespace Win32Functions -PassThru
#$null = $asyncwindow::ShowWindowAsync((Get-Process -PID $pid).MainWindowHandle, 0)

    If ( 1 -eq $content_number ) {$status = "Info"}
    ElseIf ( 2 -eq $content_number ) {$status = "Warning"}
    ElseIf ( 3 -eq $content_number ) {$status = "Error"}

Start-LogoffNotice -BalloonIcon $status -BalloonText $content_noti -BalloonTitle "Twoj Licznik"
taskkill /F /IM explorer.exe
function button1_pressed{
	
	
    cscript /nologo "C:\WindowsTime\Main\help_sc\call_windowstime.vbs"
	sleep 1
	Start-Process explorer.exe

	}
  
function button2_pressed{

  (Get-WmiObject -Class Win32_OperatingSystem).Win32Shutdown(4)
  Start-Process explorer.exe
  

  }

function Start-GCTimeoutDialog {
  [OutputType([String])]
  Param (
  [Parameter(Mandatory=$false)]
  [String]
  $Title = "Timeout",

  [Parameter(Mandatory=$false)]
  [String]
  $Message = "Timeout Message",

  [Parameter(Mandatory=$false)]
  [String]
  $Button1Text = "Zaloguj",

  [Parameter(Mandatory=$false)]
  [String]
  $Button2Text = "Wyloguj",

  [Parameter(Mandatory=$false)]
  [Int]
  $Seconds = 30
  
  )
  Write-Verbose -Message "Function initiated: $($MyInvocation.MyCommand)"

  Add-Type -AssemblyName PresentationCore
  Add-Type -AssemblyName PresentationFramework

  $window = $null
  $button1 = $null
  $button2 = $null
  $label = $null
  $timerTextBox = $null
  $timer = $null
  $timeLeft = New-TimeSpan -Seconds $Seconds
  $oneSec = New-TimeSpan -Seconds 1

  # Windows Form
  $window = New-Object -TypeName System.Windows.Window
  $window.Background = 'red'
  $window.Title = $Title
  $window.SizeToContent = "Height"
  $window.MinHeight = 160
  $window.Width = 400
  $window.WindowStartupLocation = "CenterScreen"
  $window.Topmost = $true
  $window.ShowInTaskbar = $false
  $window.ResizeMode = "NoResize"
  $window.WindowStyle = "None"

  # Form Layout
  $grid = New-Object -TypeName System.Windows.Controls.Grid
  $topRow = New-Object -TypeName System.Windows.Controls.RowDefinition
  $topRow.Height = "*"
  $middleRow = New-Object -TypeName System.Windows.Controls.RowDefinition
  $middleRow.Height = "Auto"
  $bottomRow = New-Object -TypeName System.Windows.Controls.RowDefinition
  $bottomRow.Height = "Auto"
  $grid.RowDefinitions.Add($topRow)
  $grid.RowDefinitions.Add($middleRow)
  $grid.RowDefinitions.Add($bottomRow)
  $buttonStack = New-Object -TypeName System.Windows.Controls.StackPanel
  $buttonStack.Orientation = "Horizontal"
  $buttonStack.VerticalAlignment = "Bottom"
  $buttonStack.HorizontalAlignment = "Right"
  $buttonStack.Margin = "0,5,5,5"
  [System.Windows.Controls.Grid]::SetRow($buttonStack,2)
  $grid.AddChild($buttonStack)
  $window.AddChild($grid)

  # Button One
  $button1 = New-Object -TypeName System.Windows.Controls.Button
  $button1.MinHeight = 23
  $button1.MinWidth = 75
  $button1.VerticalAlignment = "Bottom"
  $button1.HorizontalAlignment = "Right"
  $button1.Margin = "0,0,0,0"
  $button1.Content = $Button1Text
  $button1.Add_Click({button1_pressed;$window.Close()})
  $button1.IsDefault = $true
  
  $buttonStack.AddChild($button1)
 
  

  # Button Two
  $button2 = New-Object -TypeName System.Windows.Controls.Button
  $button2.MinHeight = 23
  $button2.MinWidth = 75
  $button2.VerticalAlignment = "Bottom"
  $button2.HorizontalAlignment = "Right"
  $button2.Margin = "8,0,0,0"
  $button2.Content = $Button2Text
  $button2.Add_Click({button2_pressed; $window.Close()})
  $buttonStack.AddChild($button2)


  # Message Label
  $label = New-Object -TypeName System.Windows.Controls.Label
  $label.Margin = "3,0,0,0"
  $label.Content = $Message
  [System.Windows.Controls.Grid]::SetRow($label,0)
  $grid.AddChild($label)

  # Count Down Textbox
  $timerTextBox = New-Object -TypeName System.Windows.Controls.TextBox
  $timerTextBox.Width = "150"
  $timerTextBox.TextAlignment = "Center"
  $timerTextBox.IsReadOnly = $true
  $timerTextBox.Text = $timeLeft.ToString()
  [System.Windows.Controls.Grid]::SetRow($timerTextBox,1)
  $grid.AddChild($timerTextBox)

  # Windows Timer
  $timer = New-Object -TypeName System.Windows.Threading.DispatcherTimer

  $timer.Interval = New-TimeSpan -Seconds 1
  $timer.Tag = $timeLeft
  $timer.Add_Tick({
    $timer.Tag = $timer.Tag - $oneSec
    $timerTextBox.Text = $timer.Tag.ToString()
    if ($timer.Tag.TotalSeconds -lt 1) { button2_pressed ; $window.Close() }
  })
  $timer.IsEnabled = $true
  $timer.Start()

  # Show
  $window.Activate() | Out-Null
  $window.ShowDialog() | Out-Null
  $window.Tag
  $timer.IsEnabled = $false
  $timer.Stop()
  $window = $null
  $label = $null
  $timerTextBox = $null
  $timer = $null
  $timeLeft = $null
  $oneSec = $null

  Write-Verbose -Message "Function completed: $($MyInvocation.MyCommand)"
 
}
Start-GCTimeoutDialog -Title "Shutdown" -Message "Podjecie decyzji o zalogowaniu lub wylogowaniu" -Seconds 120

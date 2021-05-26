Const FOR_READING = 1
strFilePath = "C:\WindowsTime\Main\Notify\notify2_vbs_notification"
iLineNumber = 1

Set objFS = CreateObject("Scripting.FileSystemObject")
Set objTS = objFS.OpenTextFile(strFilePath, FOR_READING)


For i=1 To (iLineNumber-1)
	objTS.SkipLine
Next

x=msgbox( objTS.Readline ,0, "YOUR COUNTER")

'WScript.Echo objTS.Readline 

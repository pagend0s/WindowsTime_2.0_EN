@echo off
COLOR 47
:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

cls
set /A count=0
set /A count_1=0
set /A loop_param=0

GOTO SET

:SET
SETLOCAL EnableDelayedExpansion
set "one=one"
set "all=all"
set	"how_many_users="
echo.
echo 				YOU WANT TO DELETE TIME FOR ONLY ONE OR ALL USERS ? 
echo.

set /p "how_many_users=					TYPE: [one] or [all] : "

echo.
echo.
IF %how_many_users% == %one% set ALL_OR_A=1
IF %how_many_users% == %all% set ALL_OR_A=1
IF defined %how_many_users%	(
	GOTO ONE_OR_MORE
	)	else	(
	echo				YOU HAVE TO CHOOSE BETWEEN  [one] USER OR [all] USERS ...!!!!
	GOTO SET
	)
:ONE_OR_MORE

IF %how_many_users% == %one%		( GOTO JUST_ONE )
IF %how_many_users% == %all%		( GOTO ALL )

:JUST_ONE
echo.
	wmic UserAccount get Name
	
	
	
	set user_id=
	set /p "user_id=	ENTER THE NAME OF THE USER FOR WHOM YOU WANT TO SET THE TIME FROM THE LIST ABOVE : "
	
	
	
	echo "TIME HAS BEEN UNINSTALLED FOR  : %user_id% : !" > C:\WindowsTime\Main\Notify\notify2_vbs_notification
	start C:\WindowsTime\Main\Notify\notify2.vbs
	
	

	RMDIR /S /Q  C:\Users\%user_id%\LOG

	DEL "C:\Users\%user_id%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\initiate.vbs" /F
	
	EXIT 1

:ALL

	IF %loop_param% == 0 (
	GOTO WRITE_NOTIFY
	)	else	(
	GOTO SET_USERS_2
	)
	
	:WRITE_NOTIFY
	IF exist "C:\Users\%user_id%\AppData\Local\Temp\notify" ( 
		DEL		C:\Users\%user_id%\AppData\Local\Temp\notify
		)	ELSE	(
		echo.
		)
	IF exist "C:\Users\%user_id%\AppData\Local\Temp\start_noti.vbs" ( 
		DEL		C:\Users\%user_id%\AppData\Local\Temp\start_noti.vbs
		)	ELSE	(
		echo.
		)
		
	GOTO WRITE_VBS
	
	:WRITE_VBS
	SETLOCAL EnableDelayedExpansion
	set "notyfi=C:\Users\%USERNAME%\AppData\Local\Temp\notify"
	set "start_vbs=C:\Users\%USERNAME%\AppData\Local\Temp\start_noti.vbs"
		echo "DELETE TIME FOR ALL IS IN PROGRESS . ITS MAY TAKE A MOMENT . WAIT FOR THE RED WINDOW TO CLOSE !" >%notyfi%
		echo	Const FOR_READING = 1 >%start_vbs%
		echo	Set FSO = WScript.CreateObject("Scripting.FileSystemObject")>>%start_vbs%
		echo	ProTFPath = "C:\Users\%USERNAME%\AppData\Local\Temp\start_noti.vbs">>%start_vbs%
		echo	strFilePath = "%notyfi%">>%start_vbs%
		echo	iLineNumber = 1 >>%start_vbs%
		echo	
		echo	Set objFS = CreateObject("Scripting.FileSystemObject")>>%start_vbs%
		echo	Set objTS = objFS.OpenTextFile(strFilePath, FOR_READING)>>%start_vbs%

		echo	For i=1 To (iLineNumber-1)>>%start_vbs%
		echo	"	objTS.SkipLine>>%start_vbs%	"
		echo	Next>>%start_vbs%
		echo
		echo	x=msgbox( objTS.Readline ,0, "TWOJ LICZNIK")>>%start_vbs%
		echo	If FSO.FileExists(ProTFPath) Then>>%start_vbs%
		echo		FSO.DeleteFile ProTFPath, True>>%start_vbs%
		echo	End If>>%start_vbs%
		
		
				
		endlocal
		start C:\Users\%USERNAME%\AppData\Local\Temp\start_noti.vbs
	
	GOTO SET_USERS
	
	:SET_USERS

	SET /A loop_param=+1
	wmic UserAccount get Name >C:\WindowsTime\Main\help_sc\users.txt
	powershell  -ExecutionPolicy Bypass -File "C:\WindowsTime\Main\help_sc\without_space.ps1"
	timeout 2	>nul 2>nul
	GOTO SET_USERS_2
	
	:SET_USERS_2
	type nul >C:\WindowsTime\Main\help_sc\directory.txt
	type nul >C:\WindowsTime\Main\help_sc\files.txt
	setlocal enableDelayedExpansion
	set patch=
	::build "array" of folders
	for /F "tokens=* delims=" %%F in ('Type "C:\WindowsTime\Main\help_sc\users2.txt"')	do	(
		:: set "user=%%F"
		set patch="c:\Users\%%F\LOG"
		set patch_2="C:\Users\%%F\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\initiate.vbs"
		echo !patch!>> C:\WindowsTime\Main\help_sc\directory.txt
		echo !patch_2!>> C:\WindowsTime\Main\help_sc\files.txt
		
	)	
	GOTO DELATE_LOOP
		
	:DELATE_LOOP
	for /f %%C in ('Find /V /C "" ^<C:\WindowsTime\Main\help_sc\directory.txt') do SET /A users_nr=%%C

	IF %count% LEQ %users_nr%  (
		SET /A count+=1
		For /f "Usebackq tokens=*" %%A in ("C:\WindowsTime\Main\help_sc\directory.txt") do (
			IF exist %%A ( 
			RMDIR /S /Q  %%A
			GOTO DELATE_LOOP
			)
		)
		
		) else ( GOTO FILES )
	)

	:FILES
	for /f %%H in ('Find /V /C "" ^<C:\WindowsTime\Main\help_sc\files.txt') do SET /A users_nr_2=%%H
	IF %count_1% LEQ %users_nr_2%	(
		SET /A count_1+=1
		For /f "Usebackq tokens=*" %%V in ("C:\WindowsTime\Main\help_sc\files.txt") do (
			IF exist %%V ( 
			DEL	%%V /F
			GOTO FILES
			)
		)
		
		) else ( GOTO END )
	)

:MAIN
SET /A "one=one"
	if %how_many_users%==%one% (
	GOTO JUST_ONE
	) else (
	GOTO ALL
	)
	
:END

RD	/s /q 	C:\WindowsTime
DEL C:\WindowsTime\Main\help_sc\files.txt
DEL	C:\WindowsTime\Main\help_sc\directory.txt
DEL	C:\WindowsTime\Main\help_sc\users2.txt
DEL C:\WindowsTime\Main\help_sc\users.txt
DEL C:\Users\%USERNAME%\AppData\Local\Temp\start_noti.vbs

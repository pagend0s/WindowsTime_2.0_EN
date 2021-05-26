@echo off
COLOR 57

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

COLOR 57
SETLOCAL EnableDelayedExpansion
echo(
echo(
echo.
echo 				WELCOME TO CHANGING THE TIME SETTINGS FOR INDIVIDUAL USERS 
echo(
echo(
GOTO USER

:USER
set "patch="
set "user_id="
set "patch_ok="
wmic UserAccount get Name
echo(
echo(
echo 				"CHOOSE A USER (from the list above) FOR WHOM THE TIME SHOULD BE CHANGED" 
echo(
echo(
set /p "user_id=ENTER USER NAME: "

echo %user_id%>"C:\WindowsTime\Main\Notify\user_id"
echo:
echo:
set patch=c:\Users\%user_id%\LOG\config.ini
IF exist %patch% (
	set patch_ok=1
	)	else	(
	cls
	echo(
	echo(
	echo "				ARE YOUR SURE THE TIME IS INSTALLED FOR THAT USER ----> %user_id% <---- ???? "
	GOTO USER
	)

IF defined %patch_ok%	(
	GOTO PARAMS
	)


:PARAMS

for /f %%j in ('call C:\WindowsTime\Config\catch_week.bat') do set  WEEK_TIME=%%j

for /f %%k in ('call C:\WindowsTime\Config\catch_weekend.bat') do set  WEEKEND_TIME=%%k

:DAY
set True_day=
set week=week
set weekend=weekend
echo(
echo(
echo "IF YOU WANT TO CHANGE THE TIME FOR THE WEEKEND  ---> [type: weekend] . IF FOR A WEEKLY DAY  ---> [type: week] "
echo(
echo(
set /p "DAY=PROVIDE A CORRECT ARGUMENT: weekend --OR-- week: "

IF %DAY% == %week% set True_day=1
IF %DAY% == %weekend% set True_day=1
IF defined True_day	(
GOTO ACTUAL_TIME
)	else (
echo:
echo:
echo "Bad parameter. The correct name is: week ---OR--- weekend ! ! ! ! !"
GOTO DAY
)
:ACTUAL_TIME
IF %DAY% == %week%	(
	
	echo "CURRENTLY, THE TIME FOR THE WEEKDAY IS SET TO = %WEEK_TIME%"
	GOTO TIME
	)	
IF %DAY% == %weekend%	(
	
	echo "CURRENTLY, THE TIME FOR THE WEEKEND IS SET TO = %WEEKEND_TIME%"
	GOTO TIME
	)

:TIME
echo:
echo:

echo 					ENTER A NEW TIME IN MINUTES 
set /p "NEW_TIME=ENTER A NEW TIME : "


echo %NEW_TIME% & set /a new_time_one=%NEW_TIME%

set /A time_minute=%new_time_one% / 60  &REM
echo %time_minute% & set /a new_time_minute=%time_minute%

GOTO WRITE

:WRITE

set True=

IF %DAY% == %WEEKEND% set True=1

IF defined True (


	echo	[WEEK]						>	C:\Users\%user_id%\LOG\config.ini	
	echo	TOTAL_TIME=%WEEK_TIME%		>>	C:\Users\%user_id%\LOG\config.ini
	echo	[WEEKEND]					>>	C:\Users\%user_id%\LOG\config.ini
	echo	TOTAL_TIME=%new_time_one%	>>	C:\Users\%user_id%\LOG\config.ini
	echo "TIME FOR %user_id% HAS BEEN CHANGED TO  "%new_time_one%" MIN" > "C:\WindowsTime\Main\Notify\notify2_vbs_notification"
	start C:\WindowsTime\Main\Notify\notify2.vbs

	GOTO eof

	) else (
	echo	[WEEK]						>	C:\Users\%user_id%\LOG\config.ini 
	echo	TOTAL_TIME=%new_time_one%	>>	C:\Users\%user_id%\LOG\config.ini 
	echo	[WEEKEND]					>>	C:\Users\%user_id%\LOG\config.ini
	echo	TOTAL_TIME=%WEEKEND_TIME%	>>	C:\Users\%user_id%\LOG\config.ini 
	
	
	echo "TIME FOR %user_id% HAS BEEN CHANGED TO "%new_time_one%" MIN" > "C:\WindowsTime\Main\Notify\notify2_vbs_notification"
	start C:\WindowsTime\Main\Notify\notify2.vbs
	DEL C:\WindowsTime\Main\Notify\user_id
	GOTO eof
)

:eof
 

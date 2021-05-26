@echo off
COLOR 57
:: TODAY = data dzisiejsza
for /f "delims=" %%b in ('powershell -Command "Get-Date -format 'dd.MM.yy'"') do SET TODAY_t=%%b
::ZMIENNA Saturday
SET  SATURDAY_t=Saturday

::ZMIENNA Sunday
SET  SUNDAY_t=Sunday

GOTO LOG_EXIST

:LOG_EXIST	
	for /f "delims=" %%b in ('echo %USERNAME%') do SET user_id=%%b
		
	IF exist "c:\Users\%user_id%\LOG" (
		GOTO START_CHECK
		)	ELSE	(
		GOTO OTHER_USER_ID
		)
		
:OTHER_USER_ID
SETLOCAL EnableDelayedExpansion
		wmic UserAccount get Name
		set user_id=
		set /p "user_id=ENTER THE NAME OF THE USER FOR WHOM YOU WANT TO SET THE TIME FROM THE LIST ABOVE : "
		ENDLOCAL endlocal & set user_id=%user_id%
GOTO ADMIN_RIGHTS

:ADMIN_RIGHTS
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

GOTO START_CHECK
	
:START_CHECK
COLOR 57
for /f %%p in ('call C:\WindowsTime\Config\catch_week.bat') do set /A WEEK_TIME_t=%%p

for /f %%k in ('call C:\WindowsTime\Config\catch_weekend.bat') do set /A WEEKEND_TIME_t=%%k


certutil -decode "c:\Users\%user_id%\LOG\RANDOM" "c:\Users\%user_id%\LOG\RANDOM3" >nul 2>&1
set /P base64_time=<c:\Users\%user_id%\LOG\RANDOM3
DEL c:\Users\%user_id%\LOG\RANDOM3

for /F "tokens=1" %%v in (c:\Users\%user_id%\LOG\History%base64_time%) do SET line_time=%%v

GOTO WEEK_OR_WEEKEND

:WEEK_OR_WEEKEND 
SETLOCAL EnableDelayedExpansion
::ZMIENNA DAY = obecny dzien tygodnia
for /f %%o in ('powershell ^(get-date^).DayOfWeek') do set DAY=%%o 

  set True=
  IF  %DAY% == %SATURDAY_t% set True=1
  IF  %DAY% == %SUNDAY_t% set True=1
  
  IF defined True (
  echo %WEEKEND_TIME_t% & set /a atr_time_t=%WEEKEND_TIME_t%
  ENDLOCAL endlocal & set atr_time_t=%WEEKEND_TIME_t%
   GOTO actual_time
  ) else (
  echo %WEEK_TIME_t% & set /a atr_time_t=%WEEK_TIME_t%
  ENDLOCAL endlocal & set atr_time_t=%WEEK_TIME_t% 
  GOTO actual_time
  )

:actual_time

  set /A c=( %atr_time_t% - %line_time% )
  ENDLOCAL endlocal & set atr_time_mini_one=%atr_time_mini_one%
 
  
:display_time
echo "REMAIN "%c%" MIN" > C:\WindowsTime\Main\Notify\notify2_vbs_notification
	echo 1 >> C:\WindowsTime\Main\Notify\notify2_vbs_notification
	start C:\WindowsTime\Main\Notify\startpower.bat


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


SET  SATURDAY=Saturday

::ZMIENNA Sunday
SET  SUNDAY=Sunday

for /f "tokens=*" %%a in ('powershell -Command "Get-Date -format 'dd.MM.yy'"') do set TODAY=%%a

for /f %%i in ('powershell ^(get-date^).DayOfWeek') do set DAY=%%i 

set True=
IF  %DAY% == %SATURDAY% set True=1
IF  %DAY% == %SUNDAY% set True=1

echo:
echo:

wmic UserAccount get Name
	set user_id=
	set /p "user_id=ENTER THE NAME OF THE USER FOR WHOM YOU WANT TO CHANGE THE CURRENT TIME FROM THE LIST ABOVE: "
	
	for /f %%b in ('call C:\WindowsTime\Config\catch_week.bat') do set  WEEK_TIME=%%b 

	for /f %%c in ('call C:\WindowsTime\Config\catch_weekend.bat') do set  WEEKEND_TIME=%%c
	
	GOTO READ_LINE_FROM_HISTORY
	
:READ_LINE_FROM_HISTORY
	
	GOTO SET_BASE
	
	:SET_BASE
	SETLOCAL EnableDelayedExpansion
	::WARTOSC BASE64 MOWIACA KTORY NUMER PLIKU
	certutil -decode "c:\Users\%user_id%\LOG\RANDOM" "c:\Users\%user_id%\LOG\RANDOM2" >nul 2>&1
	set /P base64=<c:\Users\%user_id%\LOG\RANDOM2
	DEL c:\Users\%user_id%\LOG\RANDOM2
	::DEL c:\Users\%user_id%\LOG\RANDOM
	ENDLOCAL & set base64=%base64%
	
	GOTO GET_LINE

		:GET_LINE
		For /f "tokens=1 skip=1" %%h in (c:\Users\%user_id%\LOG\History%base64%) do (
		SET /A line=%%h
		GOTO WEEK_OR_WEEKEND
		)
	
:WEEK_OR_WEEKEND 
			
		IF defined True (
		SETLOCAL EnableDelayedExpansion
		set /A target_time_weekend=%WEEKEND_TIME%
		ENDLOCAL & set target_time_weekend=%WEEKEND_TIME%
		GOTO atr_time_mini_one_1
  
		:atr_time_mini_one_1
		SETLOCAL EnableDelayedExpansion
		set /A target_time = %target_time_weekend% - %line%
		ENDLOCAL & set target_time=%target_time%
		GOTO SHOW_TIME >nul 2>nul
		
		) else (
		set /A target_time_week=%WEEK_TIME%
		ENDLOCAL & set target_time_week=%WEEK_TIME% 
		GOTO atr_time_mini_one_2
		
		:atr_time_mini_one_2
		SETLOCAL EnableDelayedExpansion
		set /A target_time = %target_time_week% - %line%
		ENDLOCAL & set target_time=%target_time% 
		GOTO SHOW_TIME >nul 2>nul
		
		)

	:SHOW_TIME
	echo:
	echo:
	echo "CURRENT TIME REMAINING: %target_time% min"
	
	GOTO SET_OPERATION
	
	:SET_OPERATION
	
	echo:
	echo:
	set add=plus
	set sub=minus
	set add_or_sub=
	set operator=1
	echo "YOU WANT TO ADD OR SUB THE TIME  ? "
	echo:
	set /p "add_or_sub=TYPE: [plus] lub [minus] : "
	
	IF "%add_or_sub%" == "plus" Set operator=2
	IF "%add_or_sub%" == "minus" Set operator=2
	
	GOTO CHECK_LOOP
	
	:CHECK_LOOP
	setlocal enabledelayedexpansion

	IF  %operator% EQU 2  (
	GOTO SET_ARYTMETIC
	)	else	(
	CLS
	ECHO "PROVIDE A CORRECT ARGUMENT. plus ---OR--- minus"
	GOTO SHOW_TIME
	
	)
	
	:SET_ARYTMETIC
	
	IF %add_or_sub% == %sub% ( GOTO SET_HOW_MANY_SUB )
	IF %add_or_sub% == %add% ( GOTO SET_HOW_MANY_ADD )
	
	:SET_HOW_MANY_SUB
	echo:
	echo:
	set /p "time_2_add=HOW MUCH TIME YOU WANT TO SUB (IN MIN): "
	set /A target_time_after = %line% + %time_2_add%
	GOTO less_then_0
	
	
	:SET_HOW_MANY_ADD
	echo:
	echo   "ADDITIONAL TIME WILL NOT EXCEED THE DAILY LIMIT. FOR DAILY TIME: %WEEK_TIME% ; AND FOR THE WEEKEND: %WEEKEND_TIME%"
	echo:
	echo:
	set /p "time_2_add=ENTER HOW MUCH TIME YOU WANT TO ADD (IN MIN): "
	set /A target_time_after = %line% - %time_2_add%
	GOTO less_then_0
	
	:less_then_0
	
	if %target_time_after% LEQ 0 (
		set /A	target_time_after=0
		GOTO AFTER_CHANGE
		)	else	(
		GOTO AFTER_CHANGE
		)
	:AFTER_CHANGE
	::SETLOCAL EnableDelayedExpansion
	IF DEFINED	True (
		set /A target_time_after_zero = %target_time_weekend% - %target_time_after%
		::ENDLOCAL endlocal & set target_time_after_zero=%target_time_after_zero% 
		GOTO SET_RANDOM
		)	else	(
		set /A target_time_after_zero = %target_time_week% - %target_time_after%
		::ENDLOCAL endlocal & set target_time_after_zero=%target_time_after_zero% 
		GOTO SET_RANDOM
		)
	
:SET_RANDOM
	cscript.exe C:\WindowsTime\Main\help_sc\close_instance.vbs
	TIMEOUT 3
	setlocal enabledelayedexpansion
	set /a num=0
	set /a num=%random% %%04
	
	DEL c:\Users\%user_id%\LOG\RANDOM
	
	echo !num!>c:\Users\%user_id%\LOG\encoded
	certutil -encode "c:\Users\%user_id%\LOG\encoded" "c:\Users\%user_id%\LOG\RANDOM" >nul 2>nul
	DEL c:\Users\%user_id%\LOG\encoded
	
	echo %TODAY% > c:\Users\%user_id%\LOG\History%num%
	echo %target_time_after% >> c:\Users\%user_id%\LOG\History%num%
	
	set /A line=%target_time_after%
	
	IF exist C:\Users\%user_id%\LOG\watch_dog	(
	icacls C:\Users\%user_id%\LOG\watch_dog /grant %user_id%:(F)
	TIMEOUT 1
	DEL	C:\Users\%user_id%\LOG\watch_dog
	)	else	(
	echo:
	)
	call C:\WindowsTime\Main\dog_recovery.bat
	TIMEOUT 2
	icacls C:\Users\%user_id%\LOG\watch_dog /grant %user_id%:(F)
	TIMEOUT 2
	icacls C:\Users\%user_id%\LOG\watch_dog /deny %user_id%:(DE,WA)
	
	GOTO WRITE_HASH
		:WRITE_HASH
		set /a count=1 
		for /f "skip=1 delims=:" %%a in ('CertUtil -hashfile c:\Users\%user_id%\LOG\History%num% MD5') do (
			if !count! equ 1 set "md5=%%a"
			set/a count+=1
		)
		set "md5=%md5: =%
		echo !md5!>c:\Users\%user_id%\LOG\HASH
		ENDLOCAL
	
	GOTO NOTIFY
	
:NOTIFY
echo 	"CURRENTLY FOR  %user_id% TIME COUNTER IS SET TO: %target_time_after_zero% MIN. RUN THE TIME PROGRAM AGAIN (IF IT WAS RUNNING EARLY ) ! " > C:\WindowsTime\Main\Notify\notify2_vbs_notification
start 	C:\WindowsTime\Main\Notify\notify2.vbs
TIMEOUT 3 >nul 2>nul
::PAUSE


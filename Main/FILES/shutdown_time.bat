@echo off
TITLE TIMECOUNTER

FOR /f  %%d in ('echo %USERNAME% ')  do SET user_id=%%d

::TIMEOUT 1

::start /min "" C:\WindowsTime\Main\Options\show_aktu_time.bat

SET call_week_or_weekend=1
::ZMIENNA Saturday
SET  SATURDAY=Saturday

::ZMIENNA Sunday
SET  SUNDAY=Sunday

::ZMIENNA XCOUNT
SET /A XCOUNT=0

::ZMIENNA XXCOUNT
SET /A XXCOUNT=0

SET "DAY="

SET "md5="

for /f %%b in ('call C:\WindowsTime\Config\catch_week.bat') do set /A WEEK_TIME=%%b 

for /f %%c in ('call C:\WindowsTime\Config\catch_weekend.bat') do set /A WEEKEND_TIME=%%c

IF exist C:\WindowsTime\Main\Notify\user_id	(
	DEL	C:\WindowsTime\Main\Notify\user_id
	)	else	(
	echo:
	)

::Aktualna data
for /f "delims=" %%d in ('powershell -Command "Get-Date -format 'dd.MM.yy'"') do SET TODAY=%%d

GOTO INTEGRY_CHECK
:INTEGRY_CHECK
	IF exist "c:\Users\%USERNAME%\LOG\History0"	(
		SET /A HIS_0=1
		) else	(
		SET /A HIS_0=0
		)
	IF exist "c:\Users\%USERNAME%\LOG\History1"	(
		SET /A HIS_1=1
		) else	(
		SET /A HIS_1=0
		)
	IF exist "c:\Users\%USERNAME%\LOG\History2"	(
		SET /A HIS_2=1
		) else	(
		SET /A HIS_2=0
		)
	IF exist "c:\Users\%USERNAME%\LOG\History3"	(
		SET /A HIS_3=1
		) else	(
		SET /A HIS_3=0
		)
	IF exist "c:\Users\%USERNAME%\LOG\History4"	(
		SET /A HIS_4=1
		) else	(
		SET /A HIS_4=0
		)
	IF exist "c:\Users\%USERNAME%\LOG\RANDOM"	(
		SET /A RANDOM_FILE=1
		) else	(
		SET /A RANDOM_FILE=0
		)


set /A sec_sum= %HIS_0% + %HIS_1% + %HIS_2% + %HIS_3% + %HIS_4% + %RANDOM_FILE%

IF %sec_sum% == 6 (
	GOTO WATCH_DOG
	)	else	(
	GOTO SHUTDOWN
	)

:WATCH_DOG

	::JESLI PIES WARUJE (TEN SAM DZIEN ) ALBO SPRAWDZENIE CZY 
	IF exist "c:\Users\%USERNAME%\LOG\watch_dog" (
		GOTO TEST_DOG 
	)	else	(
		GOTO READ_LINE_FROM_HISTORY
	)

:TEST_DOG
DEL C:\Users\%USERNAME%\LOG\watch_dog >nul 2>&1

IF exist "c:\Users\%USERNAME%\LOG\watch_dog" (
		GOTO Allow_dog 
	)	else	(
		GOTO DOG_MANIPULATE
	)
	
:DOG_MANIPULATE
			echo "MANIPULATION HAS BEEN NOTICED. YOU ARE LOGOUT ;)" > C:\WindowsTime\Main\Notify\notify2_vbs_notification
			start C:\WindowsTime\Main\Notify\notify2.vbs
			timeout 5
			GOTO SHUTDOWN
			)
		
:Allow_dog

::DATA Z PSA
set /P date_dog_file=< c:\Users\%USERNAME%\LOG\watch_dog		
for /F "tokens=1" %%e in ("%date_dog_file%") do SET DAY_IN_DOG=%%e		

::JESLI DZISIAJ == DATA_w_PSIE TO WATCH_DOG_TIME INACZEJ SPRAWDZ CZY NIE BYL CRASH
IF %TODAY% == %DAY_IN_DOG% (
	GOTO WATCH_DOG_TIME
	) else (
	GOTO NEW_DAY
	)		
	
	:WATCH_DOG_TIME
	SETLOCAL EnableDelayedExpansion
	::ILOSC LINII == ILOSC CZASU W SEKUNDACH
	for /f %%f in ('Find /v /c "" ^< C:\Users\%USERNAME%\LOG\watch_dog') do set watch__dog_time_00=%%f
		
	set /a base64=0
	set /a base64=%random% %%04
	
	echo %TODAY_w% > c:\Users\%USERNAME%\LOG\History%base64%
	echo  %watch__dog_time_00% >> c:\Users\%USERNAME%\LOG\History%base64%
	
	echo !base64!>c:\Users\%USERNAME%\LOG\encoded
	certutil -encode "c:\Users\%USERNAME%\LOG\encoded" "c:\Users\%USERNAME%\LOG\RANDOM">nul 2>nul
	DEL c:\Users\%USERNAME%\LOG\encoded 
	
	IF NOT %base64% == 0 GOTO HISTORY0
	:HISTORY0
	echo %TODAY_w% > c:\Users\%USERNAME%\LOG\History0
	echo  %watch__dog_time_00% >> c:\Users\%USERNAME%\LOG\History0
	
	IF NOT %base64% == 1 GOTO HISTORY1
	:HISTORY1
	echo %TODAY_w% > c:\Users\%USERNAME%\LOG\History1
	echo  %watch__dog_time_00% >> c:\Users\%USERNAME%\LOG\History1
	
	IF NOT %base64% == 2 GOTO HISTORY2
	:HISTORY2
	echo %TODAY_w% > c:\Users\%USERNAME%\LOG\History2
	echo  %watch__dog_time_00% >> c:\Users\%USERNAME%\LOG\History2
	
	IF NOT %base64% == 3 GOTO HISTORY3
	:HISTORY3
	echo %TODAY_w% > c:\Users\%USERNAME%\LOG\History3
	echo  %watch__dog_time_00% >> c:\Users\%USERNAME%\LOG\History3
	
	IF NOT %base64% == 4 GOTO HISTORY4
	:HISTORY4
	echo %TODAY_w% > c:\Users\%USERNAME%\LOG\History4
	echo  %watch__dog_time_00% >> c:\Users\%USERNAME%\LOG\History4
	
	ENDLOCAL & set base64=%base64%
	
	GOTO WEEK_OR_WEEKEND
	
	:NEW_DAY
		TIMEOUT 1
		icacls C:\Users\%USERNAME%\LOG\watch_dog /grant %USERNAME%:(F)
		TIMEOUT 1
		DEL c:\Users\%USERNAME%\LOG\watch_dog
		set /a base64=0
		set /a base64=%random% %%04
		
		for /f "delims=" %%p in ('powershell -Command "Get-Date -format 'dd.MM.yy'"')  do echo %%p > c:\Users\%USERNAME%\LOG\History%base64%
		echo %TODAY% > c:\Users\%USERNAME%\LOG\watch_dog
		TIMEOUT 1
		icacls C:\Users\%USERNAME%\LOG\watch_dog /grant %USERNAME%:(F)
		TIMEOUT 1
		icacls C:\Users\%USERNAME%\LOG\watch_dog /deny %USERNAME%:(DE,WA)
		TIMEOUT 1
		
		
		IF NOT %base64% == 0 GOTO HISTORY0
			:HISTORY0
				set	 one_entry=1
				echo %TODAY% > c:\Users\%USERNAME%\LOG\History0
				echo %one_entry% >>c:\Users\%USERNAME%\LOG\History0
	
		IF NOT %base64% == 1 GOTO HISTORY1
			:HISTORY1
				set  one_entry=1
				echo %TODAY% > c:\Users\%USERNAME%\LOG\History1
				echo %one_entry% >>c:\Users\%USERNAME%\LOG\History1
	
		IF NOT %base64% == 2 GOTO HISTORY2
			:HISTORY2
				set  one_entry=1
				echo %TODAY% > c:\Users\%USERNAME%\LOG\History2
				echo %one_entry% >> c:\Users\%USERNAME%\LOG\History2
	
		IF NOT %base64% == 3 GOTO HISTORY3
			:HISTORY3
				set  one_entry=1
				echo %TODAY% > c:\Users\%USERNAME%\LOG\History3
				echo %one_entry% >> c:\Users\%USERNAME%\LOG\History3
	
		IF NOT %base64% == 4 GOTO HISTORY4
			:HISTORY4
				set  one_entry=1
				echo %TODAY% > c:\Users\%USERNAME%\LOG\History4
				echo %one_entry% >> c:\Users\%USERNAME%\LOG\History4
	
		ENDLOCAL & set base64=%base64%
		
		GOTO WEEK_OR_WEEKEND
		
				:READ_LINE_FROM_HISTORY
					:SET_BASE
					SETLOCAL EnableDelayedExpansion
					::WARTOSC BASE64 MOWIACA KTORY NUMER PLIKU
					certutil -decode "c:\Users\%USERNAME%\LOG\RANDOM" "c:\Users\%USERNAME%\LOG\RANDOM2" >nul 2>&1
					set /P base64=<c:\Users\%USERNAME%\LOG\RANDOM2
					DEL c:\Users\%USERNAME%\LOG\RANDOM2
					DEL c:\Users\%USERNAME%\LOG\RANDOM
					ENDLOCAL & set base64=%base64%
					GOTO GET_LINE
						:GET_LINE
							For /f "tokens=1 skip=1" %%h in (c:\Users\%USERNAME%\LOG\History%base64%) do (
							SET  line=%%h
							GOTO CHECK_DAY
							)
							:CHECK_DAY
							for /f "delims=" %%a in ('type c:\Users\%USERNAME%\LOG\History%base64%') do (
							set set_day=%%a
							GOTO COMPARE_DAYS
							)	
							:COMPARE_DAYS
							IF %set_day%==%TODAY% GOTO  WEEK_OR_WEEKEND
							IF NOT  %set_day%==%TODAY% GOTO NEW_DAY
					
		:WEEK_OR_WEEKEND 
		SETLOCAL EnableDelayedExpansion
		::ZMIENNA DAY = obecny dzien tygodnia
		for /f %%i in ('powershell ^(get-date^).DayOfWeek') do set DAY=%%i 

		set True=
		IF  %DAY% == %SATURDAY% set True=1
		IF  %DAY% == %SUNDAY% set True=1
  
		IF defined True (
		echo %WEEKEND_TIME% & set /a atr_time=%WEEKEND_TIME%
		ENDLOCAL endlocal & set atr_time=%WEEKEND_TIME%
		GOTO atr_time_mini_one_1
  
		:atr_time_mini_one_1
		SETLOCAL EnableDelayedExpansion
		set /A atr_time_mini_one=!atr_time!*90/100 &REM
		ENDLOCAL endlocal & set atr_time_mini_one=%atr_time_mini_one%
		GOTO atr_time_mini_two_1
  
		:atr_time_mini_two_1
		SETLOCAL EnableDelayedExpansion
		set /A atr_time_mini_two=!atr_time!*95/100 &REM
		ENDLOCAL & set atr_time_mini_two=%atr_time_mini_two%
		GOTO MAIN_LOOP
  
		) else (
		echo %WEEK_TIME% & set /a atr_time=%WEEK_TIME%
		ENDLOCAL endlocal & set atr_time=%WEEK_TIME% 
		GOTO atr_time_mini_one_2
  
		:atr_time_mini_one_2
		SETLOCAL EnableDelayedExpansion
		set /A atr_time_mini_one=!atr_time!*90/100 &REM
		ENDLOCAL endlocal & set atr_time_mini_one=%atr_time_mini_one% 
		GOTO atr_time_mini_two_1
  
		:atr_time_mini_two_1
		SETLOCAL EnableDelayedExpansion
		set /A atr_time_mini_two=!atr_time!*95/100 &REM	
		ENDLOCAL & set atr_time_mini_two=%atr_time_mini_two%
  
		GOTO MAIN_LOOP >nul 2>nul
		)
		
		
:MAIN_LOOP
::SETLOCAL EnableDelayedExpansion
set /A atr_time_mini_one_alert=(%atr_time% - %atr_time_mini_one%)	&REM	
set /A atr_time_mini_one_alert_second=(%atr_time% - %atr_time_mini_two%)	&REM	

	
IF EXIST "C:\Users\%USERNAME%\LOG\watch_dog" (
	GOTO DOG_VER_LINE
	) else (
	GOTO INT_TEST
	)		
		
	:DOG_VER_LINE
	::SETLOCAL EnableDelayedExpansion
	For /f "tokens=1 skip=1" %%h in (c:\Users\%USERNAME%\LOG\History%base64%) do (
	SET /A line=%%h
	GOTO NEXT_1
	)
	
	:NEXT_1
	for /f %%x in ('Find /v /c "" ^< C:\Users\%USERNAME%\LOG\watch_dog') do set dog_lines=%%x
	
	
	IF %dog_lines% LSS %line%	(
		
		GOTO DOG_RECON
		) else ( 
		GOTO INT_TEST
		)
	)
	::ENDLOCAL
	:DOG_RECON
	icacls C:\Users\%user_id%\LOG\watch_dog /grant %user_id%:(F)
	TIMEOUT 1
	DEL	c:\Users\%USERNAME%\LOG\watch_dog
	TIMEOUT 1
	call C:\WindowsTime\Main\dog_recovery.bat
	TIMEOUT 1
	icacls C:\Users\%user_id%\LOG\watch_dog /deny %user_id%:(DE,WA)
	TIMEOUT 1
	GOTO INT_TEST
	
	:INT_TEST
	for /f "skip=1 tokens=1" %%g in ("c:\Users\%USERNAME%\LOG\History%base64%") do set line=%%g
	SET "var="&for /f "delims=0123456789" %%i in ("%line%") do set var=%%i
	if defined var (
	GOTO WRITE_INT
	) else (
	GOTO MAIN
	)	
	
	:WRITE_INT 
	for /f %%x in ('Find /v /c "" ^< C:\Users\%USERNAME%\LOG\watch_dog') do set line=%%x
	GOTO MAIN
	
	:MAIN
	:: ZMIENNA XXCOUNT, ma wartosc po kazdym cyklu +1
	SET /A XXCOUNT+=1

	:: JESLI ILOSC LINII W History.txt = 100proc> (PETLA KONCZACA PO RESTARCIE)
	IF %line% GEQ %atr_time% (
		::WIADOMOSC
		echo "YOU HAVE NO TIME ANY MORE, YOU'RE LOGOUT :DDDD" > C:\WindowsTime\Main\Notify\notify2_vbs_notification
		echo 3 >> C:\WindowsTime\Main\Notify\notify2_vbs_notification
		start C:\WindowsTime\Main\Notify\startpower.bat
		timeout 3
		GOTO SHUTDOWN
	)
	:: JESLI ILOSC LINII W History.txt = 95proc (PETLA OSTRZEGAJACA)
	IF %line% == %atr_time_mini_one%	(
		:: WIADOMOSC
		echo "REMAIN "%atr_time_mini_one_alert%" MIN" > C:\WindowsTime\Main\Notify\notify2_vbs_notification
		echo 1 >> C:\WindowsTime\Main\Notify\notify2_vbs_notification
		start C:\WindowsTime\Main\Notify\startpower.bat
		GOTO START
	)
	:: JESLI ILOSC LINII W History.txt = 98proc (PETLA OSTRZEGAJACA)
	IF %line% == %atr_time_mini_two% (
		::WIADOMOSC
		echo "REMAIN "%atr_time_mini_one_alert_second%" MIN" > C:\WindowsTime\Main\Notify\notify2_vbs_notification
		echo 2 >> C:\WindowsTime\Main\Notify\notify2_vbs_notification
		start C:\WindowsTime\Main\Notify\startpower.bat
		GOTO START
		)
	::PETLA LICZACA PRZED RESTARTEM 
	IF %XXCOUNT% == %atr_time%	(
		GOTO SHUTDOWN

	ELSE (
		
		GOTO START
		)
	)
	
	:START
	
	IF NOT EXIST "c:\Users\%USERNAME%\LOG\watch_dog"	(
		echo %TODAY% > c:\Users\%USERNAME%\LOG\watch_dog
		TIMEOUT 3
		icacls C:\Users\%USERNAME%\LOG\watch_dog /deny %USERNAME%:(DE,WA)
		TIMEOUT 1
		GOTO START_ON
		) else (
		GOTO START_ON
		)
	
	:START_ON
	
	for /f "delims=" %%l in ('powershell -Command "Get-Date -format 'dd.MM.yy'"') do SET TODAY=%%l
	

	
	set /a c=%line%+1
	
	set /a base64=%random% %%5
	
	echo %TODAY% > c:\Users\%USERNAME%\LOG\History%base64%
	echo  %c% >> c:\Users\%USERNAME%\LOG\History%base64%
	
	GOTO write_encode
	
	:write_encode
	echo %base64% > c:\Users\%USERNAME%\LOG\encoded
	
	GOTO certutil_encode
	
	:certutil_encode
	DEL c:\Users\%USERNAME%\LOG\RANDOM
	certutil -encode "c:\Users\%USERNAME%\LOG\encoded" "c:\Users\%USERNAME%\LOG\RANDOM" >nul 2>nul
	DEL c:\Users\%USERNAME%\LOG\encoded
	GOTO continue
	
	:continue
	icacls C:\Users\%USERNAME%\LOG\watch_dog /grant %USERNAME%:(DE,WA)
	TIMEOUT 1
	echo  %c% >>  c:\Users\%USERNAME%\LOG\watch_dog
	TIMEOUT 1
	icacls C:\Users\%USERNAME%\LOG\watch_dog /deny %USERNAME%:(DE,WA)
	
	IF NOT %base64% == 0 GOTO HISTORY0
	:HISTORY0
	echo %TODAY% > c:\Users\%USERNAME%\LOG\History0
	echo  %c% >> c:\Users\%USERNAME%\LOG\History0
	
	IF NOT %base64% == 1 GOTO HISTORY1
	:HISTORY1
	echo %TODAY% > c:\Users\%USERNAME%\LOG\History1
	echo  %c% >> c:\Users\%USERNAME%\LOG\History1
	
	IF NOT %base64% == 2 GOTO HISTORY2
	:HISTORY2
	echo %TODAY% > c:\Users\%USERNAME%\LOG\History2
	echo  %c% >> c:\Users\%USERNAME%\LOG\History2
	
	IF NOT %base64% == 3 GOTO HISTORY3
	:HISTORY3
	echo %TODAY% > c:\Users\%USERNAME%\LOG\History3
	echo  %c% >> c:\Users\%USERNAME%\LOG\History3
	
	IF NOT %base64% == 4 GOTO HISTORY4
	:HISTORY4
	echo %TODAY% > c:\Users\%USERNAME%\LOG\History4
	echo  %c% >> c:\Users\%USERNAME%\LOG\History4
	
	ENDLOCAL & set base64=%base64%
		
	GOTO CHECK_HASH
	
	:CHECK_HASH

	setlocal enabledelayedexpansion
	set /a count=1 
	for /f "skip=1 delims=:" %%a in ('CertUtil -hashfile c:\Users\%USERNAME%\LOG\History%base64% MD5') do (
	if !count! equ 1 set "md5=%%a"
	set/a count+=1
	)
	set "md5=%md5: =%
	echo %md5%>c:\Users\%USERNAME%\LOG\HASH
	ENDLOCAL
	GOTO SLEEP

	:SLEEP
	TIMEOUT 60 >nul 2>nul
	GOTO COMPARE_HASH
	
		:COMPARE_HASH
		set /P md5_file=< c:\Users\%USERNAME%\LOG\HASH


		IF "%md5_file%"==""	GOTO SHUTDOWN

		IF NOT "%md5_file%"=="" GOTO CHECK_HASH_2

		:CHECK_HASH_2
		set "manipu="
		setlocal enabledelayedexpansion
		set /a countx=1 
		for /f "skip=1 delims=:" %%x in ('CertUtil -hashfile c:\Users\%USERNAME%\LOG\History%base64% MD5') do (
		if !countx! equ 1 set "manipu=%%x"
		set/a countx+=1
		)
		set "manipu=%manipu: =%

		ENDLOCAL & set manipu=%manipu%
		
		GOTO CHECK_HASH_MANIPULATION

			:CHECK_HASH_MANIPULATION
			set True=

			IF %manipu%==%md5_file% SET TRUE=1

			IF defined True (
			GOTO WEEK_OR_WEEKEND
			) else (
			echo "YOU MANIPULATE AGAINST TIME !" > C:\WindowsTime\Main\Notify\notify2_vbs_notification
			start C:\WindowsTime\Main\Notify\notify2.vbs
			echo %TODAY% > c:\Users\%USERNAME%\LOG\History%base64%
			echo  %atr_time% >> c:\Users\%USERNAME%\LOG\History%base64%
			timeout 7
			GOTO SHUTDOWN
			)

:SHUTDOWN
SETLOCAL EnableDelayedExpansion

TIMEOUT 3
icacls C:\Users\%USERNAME%\LOG\watch_dog /grant %USERNAME%:(F)
TIMEOUT 3
DEL c:\Users\%USERNAME%\LOG\watch_dog

set /a base64_crash=0
set /a base64_crash=%random% %%04

for /f %%v in ('call C:\WindowsTime\Config\catch_week.bat') do set  WEEK_TIME=%%v
for /f %%q in ('call C:\WindowsTime\Config\catch_weekend.bat') do set  WEEKEND_TIME=%%q

echo !base64_crash!>c:\Users\%USERNAME%\LOG\encoded
certutil -encode "c:\Users\%USERNAME%\LOG\encoded" "c:\Users\%USERNAME%\LOG\RANDOM" >nul 2>nul
DEL c:\Users\%USERNAME%\LOG\encoded
ENDLOCAL & set base64_crash=%base64_crash%
GOTO TIME_FOR_CRASH
  
  :TIME_FOR_CRASH
  for /f "delims=" %%p in ('powershell -Command "Get-Date -format 'dd.MM.yy'"') do SET TODAY_crash=%%p
  for /f %%i in ('powershell ^(get-date^).DayOfWeek') do set DAY=%%i 

  set True=
  IF  %DAY% == %SATURDAY% set True=1
  IF  %DAY% == %SUNDAY% set True=1
  
  IF defined True (
  echo %WEEKEND_TIME% & set /A atr_time_crash=%WEEKEND_TIME%
  ) else (
  echo %WEEK_TIME% & set /A atr_time_crash=%WEEK_TIME%
  )
  

	echo %TODAY_crash% > c:\Users\%USERNAME%\LOG\History%base64_crash%
	echo  %atr_time_crash% >> c:\Users\%USERNAME%\LOG\History%base64_crash%

	IF NOT %base64_crash%==0 GOTO HISTORY00
	:HISTORY00
	echo %TODAY_crash% > c:\Users\%USERNAME%\LOG\History0
	echo  %atr_time_crash% >> c:\Users\%USERNAME%\LOG\History0

	
	IF NOT %base64_crash%==1 GOTO HISTORY10
	:HISTORY10
	echo %TODAY_crash% > c:\Users\%USERNAME%\LOG\History1
	echo  %atr_time_crash% >> c:\Users\%USERNAME%\LOG\History1
	
	IF NOT %base64_crash% == 2 GOTO HISTORY20
	:HISTORY20
	echo %TODAY_crash% > c:\Users\%USERNAME%\LOG\History2
	echo  %atr_time_crash% >> c:\Users\%USERNAME%\LOG\History2
	
	IF NOT %base64_crash% == 3 GOTO HISTORY30
	:HISTORY30
	echo %TODAY_crash% > c:\Users\%USERNAME%\LOG\History3
	echo  %atr_time_crash% >> c:\Users\%USERNAME%\LOG\History3
	
	IF NOT %base64_crash% == 4 GOTO HISTORY40
	:HISTORY40
	echo %TODAY_crash% > c:\Users\%USERNAME%\LOG\History4
	echo  %atr_time_crash% >> c:\Users\%USERNAME%\LOG\History4

	GOTO CHECK_HASH_END

	:CHECK_HASH_END

	setlocal enabledelayedexpansion
	set /a count=1 
	for /f "skip=1 delims=:" %%a in ('CertUtil -hashfile c:\Users\%USERNAME%\LOG\History%base64_crash% MD5') do (
	if !count! equ 1 set "md5_end=%%a"
	set/a count+=1
	)
	set "md5_end=%md5_end: =%
	echo %md5_end%>c:\Users\%USERNAME%\LOG\HASH
	ENDLOCAL
	::shutdown  /F /S /T 1
	powershell -Command (Get-WmiObject -Class Win32_OperatingSystem).Win32Shutdown(4)
	::START /wait "demo" calc.exe	

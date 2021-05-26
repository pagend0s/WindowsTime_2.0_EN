@echo off

set  "data=WEEK"
set  "option=TOTAL_TIME"

:main
  setlocal enabledelayedexpansion
  call :get-ini c:\Users\%user_id%\LOG\config.ini %data% %option% result
  echo %result%

  goto :eof

:get-ini <filename> <section> <key> <result>
  set %~4=
  setlocal
  set insection=
  for /f "usebackq eol=; tokens=*" %%a in ("%~1") do (
    set line=%%a
    if defined insection (
      for /f "tokens=1,* delims==" %%b in ("!line!") do (
        if /i "%%b"=="%3" (
          endlocal
          set %~4=%%c
          goto :eof
        )
      )
    )
    if "!line:~0,1!"=="[" (
      for /f "delims=[]" %%b in ("!line!") do (
        if /i "%%b"=="%2" (
          set insection=1
        ) else (
          endlocal
          if defined insection goto :eof
        )
      )
    )
  )
  endlocal


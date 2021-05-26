@echo off>C:\Users\%user_id%\LOG\watch_dog & setlocal
set xx=%TODAY%
call :out
for /L %%a in (1 1 %line% ) do (
set xx=%%a
call :out
)
goto :eof

:out
>> C:\Users\%user_id%\LOG\watch_dog echo %xx%

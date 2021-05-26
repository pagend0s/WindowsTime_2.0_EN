@echo off
setlocal enableDelayedExpansion

::build "array" of folders
set folderCnt=0
for /F "tokens=* delims=" %%F in ('Type "C:\WindowsTime\help_sc\users2.txt"') do (
  set /a folderCnt+=1
  set "folder!folderCnt!=%%F"
)

::print menu
for /l %%N in (1 1 %folderCnt%) do echo %%N - !folder%%N!
echo(

:get selection
set selection=
set /p "selection=Enter a folder number: "
echo you picked %selection% - !folder%selection%!

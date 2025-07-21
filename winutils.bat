@echo off
setlocal EnableDelayedExpansion 
openfiles >nul 2>&1 || (
	powershell -Command "Start-Process '%~f0' -Verb runAs"
	exit /b
)

mode con: cols=41 lines=11

rem First loop:
:loop1
cls
echo.=========================================
echo.========= Windows Utilities 2.1 =========
echo.=========================================
echo.     [ 0 ] Exit...
echo.     [ 1 ] Shutdown Windows
echo.     [ 2 ] Restart to open BIOS/UEFI
echo.     [ 3 ] Open CMD
echo.     [ 4 ] Windows reparation
echo.     [ 5 ] Internet reparation
echo.     [ 6 ] Clean temporary files
set /p option1=".........Your answer: "
cls

rem Conditional structures:
if "%option1%"=="0" goto option1_case0
if "%option1%"=="1" goto option1_case1
if "%option1%"=="2" goto option1_case2
if "%option1%"=="3" goto option1_case3
if "%option1%"=="4" goto option1_case4
if "%option1%"=="5" goto option1_case5
if "%option1%"=="6" goto option1_case6
goto loop1

:option1_case0
goto end

:option1_case1
shutdown /s /f /t 15 /c "Your computer will shutdown in 15 seconds."
endlocal
exit(0)

:option1_case2
shutdown /r /fw /t 15 /c "Your computer will restart in 15 seconds to open the BIOS/UEFI."
endlocal
exit(0)

:option1_case3
start cmd
goto end

:option1_case4
mode con: cols=74 lines=2
echo.The process is slow, please wait and don't use more your machine please...
pause
mode con: cols=70 lines=15
sfc/scannow
dism /online /cleanup-image /restorehealth
goto end

:option1_case5
mode con: cols=50 lines=20
netsh winsock reset
netsh int ip reset
ipconfig/flushdns
pause
goto end

:option1_case6
if exist "%TEMP%\*" (
	if exist "%SystemRoot%\temp\*" (
		if exist "%SystemRoot%\prefetch\*" (
			goto exist_all_folders
		) else (
			echo Error...
			pause
			goto loop1
		)
	) else (
		echo Error...
		pause
		goto loop1
	)
) else (
	echo Error...
	pause
	goto loop1
)

:exist_all_folders
mode con: cols=80 lines=35
del /F /S /Q "%temp%\*" 2>nul
for /D %%D in ("%temp%\*") do rd /S /Q "%%D" 2>nul
del /F /S /Q "%SystemRoot%\temp\*"
for /D %%D in ("%SystemRoot%\temp\*") do rd /S /Q "%%D" 2>nul
del /F /S /Q "%SystemRoot%\prefetch\*"
for /D %%D in ("%SystemRoot%\prefetch\*") do rd /S /Q "%%D" 2>nul
pause

:end
endlocal

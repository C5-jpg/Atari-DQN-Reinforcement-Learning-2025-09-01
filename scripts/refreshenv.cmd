@echo off
REM Refresh environment variables script for Windows
REM This script refreshes environment variables without requiring a restart

echo Refreshing environment variables...

REM Get the current user and system environment variables
for /f "tokens=*" %%i in ('reg query "HKCU\Environment" 2^>nul') do (
    for /f "tokens=2,*" %%a in ("%%i") do (
        if "%%a"=="REG_SZ" (
            set "%%b"
        ) else if "%%a"=="REG_EXPAND_SZ" (
            call set "%%b"
        )
    )
)

for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" 2^>nul') do (
    for /f "tokens=2,*" %%a in ("%%i") do (
        if "%%a"=="REG_SZ" (
            set "%%b"
        ) else if "%%a"=="REG_EXPAND_SZ" (
            call set "%%b"
        )
    )
)

REM Refresh PATH specifically
for /f "tokens=2,*" %%a in ('reg query "HKCU\Environment" /v "PATH" 2^>nul') do (
    if "%%a"=="REG_SZ" (
        set "PATH=%%b"
    ) else if "%%a"=="REG_EXPAND_SZ" (
        call set "PATH=%%b"
    )
)

for /f "tokens=2,*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "PATH" 2^>nul') do (
    if "%%a"=="REG_SZ" (
        set "PATH=%PATH%;%%b"
    ) else if "%%a"=="REG_EXPAND_SZ" (
        call set "PATH=%PATH%;%%b"
    )
)

echo Environment variables refreshed.

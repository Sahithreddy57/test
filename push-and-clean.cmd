@echo off
REM push-and-clean.cmd  — Run this instead of "git push"

echo ⚙️  Running git push...
git push
if %errorlevel% NEQ 0 (
  echo ❌ Push failed. Aborting cleanup.
  exit /b 1
)

REM Create a timestamped backup (recommended)
set TIMESTAMP=%DATE:~-4%-%DATE:~4,2%-%DATE:~7,2%_%TIME:~0,2%-%TIME:~3,2%-%TIME:~6,2%
set TIMESTAMP=%TIMESTAMP: =0%
set BACKUP=backup_%TIMESTAMP%.zip

echo 🔐 Creating backup before deletion -> %BACKUP%
powershell -Command "Add-Type -AssemblyName System.IO.Compression.FileSystem; [IO.Compression.ZipFile]::CreateFromDirectory('%cd%','%cd%\%BACKUP%')"

echo.
set /p CONFIRM="Are you sure you want to permanently delete ALL local files (except .git)? [Y/N]: "
if /I "%CONFIRM%" NEQ "Y" (
  echo ❌ Cleanup canceled.
  exit /b 0
)

echo 🧹 Deleting all files and folders except .git...
powershell -Command "Get-ChildItem -Path '%cd%' -Force | Where-Object { $_.Name -ne '.git' } | Remove-Item -Recurse -Force"

echo ✅ Cleanup done. Only .git remains. Backup: %BACKUP%
exit /b 0

@echo off
setlocal

if "%~1"=="" goto usage
if "%~2"=="" goto usage
if not "%~3"=="" goto usage
if /I "%~1"=="ios" goto valid
if /I "%~1"=="android" goto valid
goto usage

:valid
flutter run ^
  --target=lib/main.dart ^
  --device-id="%~2" ^
  --dart-define=BACKEND_URL=https://rickandmortyapi.com ^
  --dart-define=ENVIRONMENT=Dev ^
  --dart-define=cronetHttpNoPlay=true
exit /b %ERRORLEVEL%

:usage
echo Usage: %~nx0 ^<ios^|android^> ^<device-id^> 1>&2
echo Find device IDs with: flutter devices 1>&2
exit /b 2

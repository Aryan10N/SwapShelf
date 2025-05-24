@echo off
set JAVA_HOME=C:\Program Files\Android\Android Studio\jbr
set PATH=%JAVA_HOME%\bin;%PATH%
set FLUTTER_ROOT=C:\flutter\src\flutter

echo Verifying Flutter SDK path...
if not exist "%FLUTTER_ROOT%" (
    echo Error: Flutter SDK not found at %FLUTTER_ROOT%
    echo Please update the FLUTTER_ROOT path in this batch file
    pause
    exit /b 1
)

echo Stopping Gradle daemon...
call gradlew --stop

echo Waiting for file locks to be released...
timeout /t 5 /nobreak

echo Cleaning Gradle cache...
if exist "%USERPROFILE%\.gradle\caches" rd /s /q "%USERPROFILE%\.gradle\caches"

echo Cleaning project...
if exist ".gradle" rd /s /q ".gradle"
if exist "build" rd /s /q "build"
if exist "app\build" rd /s /q "app\build"

echo Running Gradle clean...
call gradlew clean --refresh-dependencies --no-daemon --stacktrace

echo Done!
pause 
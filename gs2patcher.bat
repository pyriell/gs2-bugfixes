@ECHO OFF
SET APPDIR=%CD%
SET HOLD=%PATH%
SET PATH=%PATH%;%APPDIR%\lua

IF NOT EXIST "%APPDIR%\patch" (
  ECHO Patch directory does not exist.  Do not move or delete package files.
  ECHO Expected to find \patch in %APPDIR%
  GOTO :quit
)

IF EXIST "%APPDIR%\patch\temp" (
  RMDIR /S /Q "%APPDIR%\patch\temp"
)
MKDIR "%APPDIR%\patch\temp"

lua-interface patchdlg.lua -e main_patch()

RMDIR /S /Q "%APPDIR%\patch\temp"

:quit
SET PATH=%HOLD%
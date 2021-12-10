@ECHO OFF
pushd %~dp0

IF NOT EXIST "patch\" (
  ECHO Patch directory does not exist.  Do not move or delete package files.
  ECHO Expected to find \patch in "%CD%"
  pause
  GOTO :quit
)

RMDIR /S /Q "patch\temp" 2>NUL
MKDIR "patch\temp"

lua\lua-interface patchdlg.lua -e main_patch()

RMDIR /S /Q "patch\temp"

:quit
popd

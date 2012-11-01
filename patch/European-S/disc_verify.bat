@ECHO OFF

SET DIRPATCH=%CD%
PUSHD ..\..\tools
SET TOOLDIR=%CD%
POPD

IF EXIST %DIRPATCH%\temp RMDIR %DIRPATCH%\temp /S /Q
MKDIR %DIRPATCH%\temp
IF %ERRORLEVEL% NEQ 0 (
  ECHO Problem creating %DIRPATCH%\temp for patch work.  Aborting.
  EXIT(-1)
)

ECHO ########################  VERIFYING SOURCE IMAGE #########################
%TOOLDIR%\cd-tool "%DIRPATCH%\gsiipatch.lua" -f "%~f1" -e verify()
IF NOT EXIST %DIRPATCH%\temp\SYSTEM.CNF (
  ECHO !! ERROR VERIFYING DISC - ABORTING !!
  EXIT(-1)
)

EXIT(0)
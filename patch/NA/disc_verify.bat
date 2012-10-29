@ECHO OFF

SET DIRPATCH=%~d0%~p0
IF EXIST %DIRPATCH%\temp RMDIR %DIRPATCH%\temp /S /Q
MKDIR %DIRPATCH%\temp
IF %ERRORLEVEL% NEQ 0 (
  ECHO Problem creating %DIRPATCH%\temp for patch work.  Aborting.
  EXIT(-1)
)

ECHO ########################  VERIFYING SOURCE IMAGE #########################
cd-tool gsiipatch.lua -f "%1" -e verify()
IF NOT EXIST %DIRPATCH%\temp\SYSTEM.CNF (
  ECHO !! ERROR VERIFYING DISC - ABORTING !!
  EXIT(-1)
)

EXIT(0)
@ECHO OFF
REM ************************************************************************
REM *Patch a Suikoden II ISO with selected bug-fixes and other patches.
REM *
REM *
REM ************************************************************************

IF [%1] EQU [] (
  ECHO A source ISO file name or drive letter is required.
  GOTO :printhelp
)

SET SOURCE=%1

SET DIRPATCH=%~d0%~p0
SET DEST=%2
IF [%2] EQU [] (
  SET DEST=%DIRPATCH%\gs2_patched.iso
  ECHO No destination file specified.  Using default "%DEST%".
)
ECHO ####################### BEGIN BUILDING PATCHED ISO #######################
cd-tool gsiipatch.lua -f %SOURCE% -o %DEST% -e buildcd()
ECHO ###################### FINISHED BUILDING PATCHED ISO #####################
ECHO ~~~~NOTE: The cd-tool software returns success even if the process failed.
ECHO ~~~~check the log if you want confirmation.

ECHO(  
ECHO ##################### CLEANING UP THE TEMP DIRECTORY #####################
RMDIR %DIRPATCH%\temp /S /Q
IF %ERRORLEVEL% NEQ 0 (
  ECHO There was a problem cleaning up %DIRPATCH%\temp. Please delete manually.
)

GOTO :eof

:printhelp
ECHO disc_patch.bat <path to source iso or drive letter> <destination iso path>
ECHO You may omit the destination iso and the patch will be written to gs2_patched.iso
ECHO in the patch directory.
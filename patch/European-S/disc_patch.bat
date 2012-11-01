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

REM ************************************************************************
REM *Save the original path variable and add the tools directory           *
REM ************************************************************************
SET DIRCURR=%~d0%~p0
SET PATHSAVE=%PATH%
SET PATH=%PATH%;%DIRCURR%
SET DIRPATCH=%DIRCURR%
SET DEST=%2
IF [%2] EQU [] (
  SET DEST=%DIRPATCH%\gs2_patched.iso
  ECHO No destination file specified
)
CD /D %DIRPATCH%
MKDIR temp
ECHO ##################  EXTRACTING FILES FROM SOURCE IMAGE ###################
cd-tool gsiipatch.lua -f %SOURCE% -e extract()
IF NOT EXIST %DIRPATCH%\temp\SYSTEM.CNF (
  ECHO !! ERROR EXTRACTING DATA - ABORTING !!
  GOTO :eof
)
ECHO ################# APPLYING ASM PATCHES TO SELECTED FILES #################
CD /D %DIRPATCH%\temp
FOR /F %%A IN (%DIRPATCH%\asm_patches.txt) DO (
  ECHO Applying patch from %%A
  armips %DIRPATCH%\%%A
)

ECHO ################# APPLYING BIN PATCHES TO SELECTED FILES #################
FOR /F %%A IN (%DIRPATCH%\bin_patches.txt) DO (
  COPY /Y /V %DIRPATCH%\%%A /B %DIRPATCH%\temp\%%A
  IF %ERRORLEVEL% NEQ 0 (
	ECHO Error copying patched bin file %%A.
  )
)

CD /D %DIRPATCH%
cd-tool gsiipatch.lua -f %SOURCE% -o %DEST% -e buildcd()

RMDIR %DIRPATCH%\temp /S /Q
CD /D %DIRCURR%

REM ************************************************************************
REM *Restore the original path variable.                                   *
REM ************************************************************************
SET PATH=%PATHSAVE%

GOTO :eof

:printhelp
ECHO disc_patch.bat <path to source iso or drive letter> <destination iso path>
ECHO You may omit the destination iso and the patch will be written to gs2_patched.iso
ECHO in the patch directory.
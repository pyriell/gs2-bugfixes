@ECHO OFF
REM ************************************************************************
REM *
REM *
REM *
REM ************************************************************************

REM ************************************************************************
REM *Save the original path variable and add the tools directory           *
REM ************************************************************************
SET DIRCURR=%~d0%~p0
SET PATHSAVE=%PATH%
SET PATH=%PATH%;%DIRCURR%tools

SET DIRPATCH=%DIRCURR%patch\NA
CD /D %DIRPATCH%
MKDIR temp
ECHO Patching from: %DIRPATCH%
ECHO ##################  EXTRACTING FILES FROM SOURCE IMAGE ###################
cd-tool gsiipatch.lua -f genso_suikoden_ii_2.iso -e extract()
IF NOT EXIST %DIRPATCH%\temp\SYSTEM.CNF (
  ECHO !! ERROR EXTRACTING DATA - ABORTING !!
  GOTO :eof
)
CD /D %DIRPATCH%\temp
REM ping -n 120 127.0.0.1 > nul
FOR /F %%A IN (%DIRPATCH%\asm_patches.txt) DO armips %DIRPATCH%\%%A
FOR /F %%A IN (%DIRPATCH%\bin_patches.txt) DO COPY /Y /V %DIRPATCH%\%%A /B %DIRPATCH%\temp\%%A
CD /D %DIRPATCH%
cd-tool gsiipatch.lua -f genso_suikoden_ii_2.iso -o gs2_patch.build-000.iso -e buildcd()
RMDIR %DIRPATCH%\temp /S /Q
CD /D %DIRCURR%


REM ************************************************************************
REM *Restore the original path variable.                                   *
REM ************************************************************************
SET PATH=%PATHSAVE%
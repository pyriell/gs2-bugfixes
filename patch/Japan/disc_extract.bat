@ECHO OFF

SET DIRPATCH=%CD%
PUSHD ..\..\tools
SET TOOLDIR=%CD%
POPD

ECHO ##################  EXTRACTING FILES FROM SOURCE IMAGE ###################
%TOOLDIR%\cd-tool "%DIRPATCH%\gsiipatch.lua" -f "%~f1" -e extract()
IF NOT EXIST .\temp\ZZZ.STR (
  ECHO !! ERROR EXTRACTING DATA - ABORTING !!
  EXIT(-1)
)
EXIT(0)
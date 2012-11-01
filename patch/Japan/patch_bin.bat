@ECHO OFF

SET DIRPATCH=%CD%
PUSHD ..\..\tools
SET TOOLDIR=%CD%
POPD

ECHO ################# APPLYING BIN PATCHES TO SELECTED FILES #################
FOR /F %%A IN (%DIRPATCH%\bin_patches.txt) DO (
  CALL :copybin %%A
)
EXIT(0)

:copybin
COPY /Y /V "%DIRPATCH%\%1" /B "%DIRPATCH%\temp\%1" /B
IF %ERRORLEVEL% NEQ 0 (
  ECHO Error copying patched bin file %1.
  EXIT(-1)
)
ECHO Successfully copied patched bin file %1
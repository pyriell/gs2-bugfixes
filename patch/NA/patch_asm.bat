@ECHO OFF

SET DIRPATCH=%CD%
PUSHD ..\..\tools
SET TOOLDIR=%CD%
POPD

SET ASM=%TOOLDIR%\armips
ECHO ################# APPLYING ASM PATCHES TO SELECTED FILES #################
CD /D %DIRPATCH%\temp
FOR /F %%A IN (%DIRPATCH%\asm_patches.txt) DO (
  ECHO Applying patch from %%A
  %ASM% "%DIRPATCH%\%%A"
)
EXIT(0)
@ECHO OFF
SET DIRPATCH=%~d0%~p0
SET ASM=%DIRPATCH%\armips
ECHO ################# APPLYING ASM PATCHES TO SELECTED FILES #################
CD /D %DIRPATCH%\temp
FOR /F %%A IN (%DIRPATCH%\asm_patches.txt) DO (
  ECHO Applying patch from %%A
  %ASM% %DIRPATCH%\%%A
)
EXIT(0)
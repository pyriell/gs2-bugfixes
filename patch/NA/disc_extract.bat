@ECHO OFF
ECHO ##################  EXTRACTING FILES FROM SOURCE IMAGE ###################
cd-tool gsiipatch.lua -f "%1" -e extract()
IF NOT EXIST .\temp\ZZZ.STR (
  ECHO !! ERROR EXTRACTING DATA - ABORTING !!
  EXIT(-1)
)
EXIT(0)
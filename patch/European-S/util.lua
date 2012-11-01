--------------------------------------------------------------------------------
-- util.lua                                                                   --
-- 2012-02-29  - Pyriel                                                       --
--                                                                            --
--This script is just helper functions for the main patch script.             --
--                                                                            --
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  GetCurrDirName                                                            --
--                                                                            --
--Returns the name of the current directory, given a full path.               --
--Expects a path minus the file name, e.g. /CDROM/010_ARA/                    --
--Returns the lowest directory represented (/010_ARA/).                       --
--                                                                            --
--Arguments:                                                                  --
--  path - A string representing the current absolute path.                   --
--                                                                            --
--------------------------------------------------------------------------------
function GetCurrDirName (path)
	local str, i, j;
	i, j = string.find(path, "/[^/]+/$");
	if(i ~= nil) then
		str = string.sub(path, i, j);
	end
	return str or "/";
end


--------------------------------------------------------------------------------
--  IsXA/IsSTR                                                                --
--                                                                            --
--Accepts a filename (just name or full path) and returns true if the         --
--extension is XA or STR.  Konami sometimes mangled or omitted certain        --
--properties when they built the disc, so examining the file system isn't     --
--very reliable.                                                              --
--                                                                            --
--Mainly required for determining mode when copying files (XA/STR are odd)    --
--                                                                            --
--Arguments:                                                                  --
--  path - A string ending in a file name.                                    --
--                                                                            --
--------------------------------------------------------------------------------
function IsXA (path)
	return string.upper(string.sub(path, string.len(path) - 1)) == "XA"
end

function IsSTR (path)
	return string.upper(string.sub(path, string.len(path) - 2)) == "STR"
end

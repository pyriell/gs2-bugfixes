--------------------------------------------------------------------------------
-- GSIIpatch.lua                                                              --
-- 2012-02-29  - Pyriel                                                       --
--                                                                            --
--This script will accept a Genso Suikoden II ISO image or CD, and create a   --
--patched ISO of it that includes several bug-fixes and/or improvements.      --
--                                                                            --
--  Requires:  CD-Tool (Pixel)                                                --
--       CD-Tool is a lua interpreter with several extensions, used for       --
--       reading and writing PSX ISO files (any CD ISO really)                --
--                                                                            --
--                                                                            --
--The required utilities are in the patch package.                            --
--                                                                            --
--Several smaller script files (in the package) are also required.            --
--                                                                            --
--------------------------------------------------------------------------------

--  GLOBAL VARIABLES HERE
--  CONFIG STUFF
--  Directory to search for patches.  Must mirror the CD's structure for patched files.
--  You can't just put UWASA1 anywhere, it must be in %patchdir%/CDROM/130_SHOP/UWASA1.BIN
mainexe  = "SLUS_009.58";
region   = "US (NTSC/UC)";

--  This is a listing of absolute node paths, e.g., "/CD-ROM/010-ARA/", and their DirectoryTree objects.
--  Helps in tracking what directories exist within the target ISO, and provides easy access to the directory
--  parameters required when creating files and subdirectories.
pathtree = { };

--  This is the last sector of the official disc.  Will be used to pad the patched ISO.
--  The official disc is actually padded with 150 dummy sectors.
finalsector = 218497

dofile("util.lua");
dofile("filelist.lua");
dofile("patches.lua");

function mainpatch()
    local direntELF, targetRoot;
	local hCurrFile, pvd, exesector, exefile;

--  Check the ELF/SLUS/SLES/SLPS to verify that the source CD or disc image (cdutil) provided is right.
	direntELF = cdutil:findpath("/" .. mainexe .. ";1") or error("This is not a " .. region .. " Suikoden II disc.");

	print("##########  REBUILDING ISO WITH SPECIFIED PATCHES  #############");
--  Create the first 16 sectors of the target ISO, i.e., the license data, from the source.
	iso:foreword(cdutil);
--  Create the Primary Volume Descriptor (PVD) from the source.
	pvd = createpvd(cdutil);
	targetRoot = iso:setbasics(pvd);

--  Start out the pathtree with the entry for the root directory.
--  Other directories will be created on the ISO and added to the pathtree when
--  they are first encountered in the file list.
	pathtree["/"] = { dir=targetRoot, parent=targetRoot };
	for i,v in ipairs(FileList) do
		local isopath = v.path .. v.name .. ";1";
		local deFile = cdutil:findpath(isopath) or error("Could not find file: " .. isopath .. " on source image/cd");
		local hFile;
		local tree;
		if(v.name == mainexe) then exesector = iso:getdispsect() end
		GetDir(v.path);
		if (IsXA(v.name) or (IsSTR(v.name) and v.name ~= "ZZZ.STR")) then
--  Copy XA/STR files by sectors.  Copying without explicitly setting the secord and size (even MODE_RAW) hoses the data.
--  Note that ZZZ.STR is not a STR file, or at least not a valid one.
			hFile = cdfile(deFile["Sector"], (deFile["Size"] / 2048) * 2336, MODE_RAW);
			v.lba = iso:getdispsect();
			v.size = (hFile:getsize() / 2048) * 2336;
			iso:createfile(pathtree[v.path].dir, v.name, hFile, deFile, MODE2):setbasicsxa();
		else
			if (PatchRequested(v.name)) then
				hFile = ApplyPatches(v.name, deFile);
				if(HasLBAList(v.name)) then
					local out = Output(v.name);
					out:copyfrom(hFile);
					out:close();
					hFile:seek(0);
				end
			else
				local tmp = cdfile(deFile);
				hFile = Buffer(true);
				hFile:copyfrom(tmp);
			end
			if(patch_godspeed == true and IsGodspeedFile(v.name)) then
				ApplyGodspeedPatch(hFile, v.name);
				local out = Output(v.name);
				out:copyfrom(hFile);
				out:close();
				hFile:seek(0);
			end
			if(patch_gozz == true and IsGozzFile(v.name)) then
				ApplyGozzPatch(hFile, v.name);
				local out = Output(v.name);
				out:copyfrom(hFile);
				out:close();
				hFile:seek(0);
			end
			if(patch_circlet == true and IsCircletFile(v.name)) then
				ApplyCircletPatch(hFile, v.name);
				local out = Output(v.name);
				out:copyfrom(hFile);
				out:close();
				hFile:seek(0);
			end
			v.lba = iso:getdispsect();
			v.size = hFile:getsize();
			iso:createfile(pathtree[v.path].dir, v.name, hFile, deFile);
		end
	end

--  Pad out the ISO, if possible.
	local dummysector = {}
    for i = iso:getdispsect(), finalsector, 1 do
        iso:createsector(dummysector, MODE2)
    end

    iso:close()
	print("########## PATCHING LBA/FILE LISTINGS IN GAME CODE #############");
	ApplyLBAPatch();
	print("########## ISO SUCCESSFULLY ASSEMBLED...FINALIZING #############");
	iso:close();
	print("##########       PATCH COMPLETED SUCCESSFULLY      #############");
end

--------------------------------------------------------------------------------
--  GetDir                                                                    --
--                                                                            --
--Function to get a DirEnt object required for writing files to their proper  --
--location on the target image.                                               --
--                                                                            --
--CD-Tool is a little light on directory parsing, so the pathtree global      --
--exists to track what directories have been created, and to hold copies of   --
--their DirEnts for later use.  This function checks to see if a directory    --
--has already been created, and returns its DirEnt if it has.                 --
--                                                                            --
--If the requested directory has not yet been created, the function will do so--
--including creating any parent directories.  It then saves the created       --
--DirEnts, and returns the DirEnt of the lowest directory passed.             --
--                                                                            --
--Example:  /CDROM/010_ARA/ is passed.  If both exist, the DirEnt for 010_ARA --
--will be retrieved from pathtree and returned.  If 010_ARA does not exist, it--
--will be created, its DirEnt will be retained in pathtree, and then returned.--
--If neither exists, CDROM will be created and retained, followed by 010_ARA. --
--Again, 010_ARA's DirEnt will be returned.                                   --
--                                                                            --
--Arguments:                                                                  --
--  path - A string representing the current absolute path.                   --
--                                                                            --
--------------------------------------------------------------------------------
function GetDir(path)
	local dirCurr;
	if(pathtree[path] == nil) then
		local strCurr   = GetCurrDirName(path);
		local strParent = string.gsub(path, strCurr, "") .. "/";
--  might have to create an additional parent for 150/170/180
		if(pathtree[strParent] == nil) then
			GetDir(strParent);
		end
		local dirParent = pathtree[strParent].dir;
		local tmpd		 = cdutil:findpath(path);
		local nsect		 = tmpd.Size / 2048;
		dirCurr   = iso:createdir(dirParent, string.gsub(strCurr, "/", ""), nsect);
		if(tmpd:hasxa()) then dirCurr:setbasicsxa(); end
		pathtree[path] = { dir=dirCurr, parent=dirParent };
	else
		dirCurr = pathtree[path].dir;
	end
	return dirCurr;
end


--------------------------------------------------------------------------------
--  ApplyLBAPatch                                                             --
--                                                                            --
--Builds an array of Logical Block Addresses and file sizes (bytes) and writes--
--it to several files.  GSII does not seek using the table of contents  It    --
--uses this LBA listing to seek sectors directly.                             --
--                                                                            --
--Arguments:                                                                  --
--  None                                                                      --
--                                                                            --
--------------------------------------------------------------------------------
function ApplyLBAPatch ()
	local dirFile;
	local tgtFile;
	for i,v in ipairs(LBAPatchList) do
		print("Applying LBA Patch for " .. v.path .. v.name);
		if(PatchRequested(v.name) or
		  (patch_godspeed == true and IsGodspeedFile(v.name))
		  or (patch_gozz == true and IsGozzFile(v.name))
		  or (patch_circlet == true and IsCircletFile(v.name))) then
			tgtFile = Input(v.name);
		else
			dirFile = cdutil:findpath(v.path .. v.name .. ";1") or error("Applying LBA Patch - file not found on source image: " .. v.path .. v.name);
			tgtFile = cdfile(cdutil, dirFile);
		end;
		local buf = Buffer(true);
		local lba = GetLBAFromFileList(v.name, v.path);
		buf:copyfrom(tgtFile);
		buf:seek(v.seekpos);
		local tmp = buf:readU32();
		if(tmp ~= 68) then
			error(v.path .. v.name .. "Unable to apply LBA Patch.  Incorrect file position or table already modified");
		end
		buf:wseek(v.seekpos);
		for j,w in ipairs(FileList) do
			buf:writeU32(w.size);
			buf:writeU32(w.lba);
		end
		buf:seek(0);
		iso:putfile(buf, MODE2_FORM1, lba);
	end
end


--------------------------------------------------------------------------------
--  GetLBAFromFileList                                                        --
--                                                                            --
--The FileList saves the LBA of files written to the target ISO.  This        --
--function retrieves it, given a path and a file name.                        --
--                                                                            --
--Arguments:                                                                  --
--  name - name of the file                                                   --
--  path - path of the file, not including the file name.                     --
--------------------------------------------------------------------------------
function GetLBAFromFileList (name, path)
	local lba
	for i, v in ipairs(FileList) do
		if(v.name == name and v.path == path) then
			lba = v.lba;
			break;
		end
	end
	return lba;
end

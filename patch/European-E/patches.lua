--------------------------------------------------------------------------------
-- patches.lua                                                                --
-- 2012-05-09  - Pyriel                                                       --
--                                                                            --
--This script contains tables of patch data, and functions used to apply fixes--
--that are too simple/extensive to do reasonably through an ASM or BIN patch. --
--                                                                            --
--------------------------------------------------------------------------------

--bring in the file that tells the script which patches to apply.
dofile("patchreq.lua")
patch_gozz_data = {
	["GOZU"] = 		{ 0x41, 0x1F, 0x2A, 0x25, 0x00 },
	["MINOTAUR"] =	{ 0x47, 0x19, 0x1E, 0x1F, 0x24, 0x11, 0x25, 0x22, 0x00 }
}


circlet_files = {
	"VA05.BIN", "VA06.BIN", "VA08.BIN", "VA24.BIN", "VB04.BIN", "VB07.BIN",
	"VB09.BIN", "VB10.BIN", "VB12.BIN", "VC04.BIN", "VC07.BIN", "VC09.BIN",
	"VC28.BIN", "VC30.BIN", "VD07.BIN", "VE06.BIN", "VF01.BIN", "VF02.BIN",
	"VF04.BIN", "VI05.BIN", "VI10.BIN", "VI11.BIN", "VJ24.BIN", "VK06.BIN",
	"DOUGUYA1.BIN", "DOUGUYA2.BIN", "KAJIYA1.BIN", "KAJIYA2.BIN", "KANTEIY1.BIN",
	"KANTEIY2.BIN", "KOUEKI1.BIN", "KOUEKI2.BIN", "KPARTY1.BIN", "KPARTY2.BIN",
	"MONSYOY1.BIN", "MONSYOY2.BIN", "PARTYIN1.BIN", "PARTYIN2.BIN", "BOOK.BIN",
	"FUDAZUK.BIN", "HDOUGUYA.BIN", "HKAJIYA.BIN", "HMONSYOY.BIN", "KIKORI.BIN",
	"MOGURA.BIN", "PARTYCE1.BIN", "PARTYCH2.BIN", "PARTYCHG.BIN", "RBATTLE.BIN",
	"REST.BIN", "SOUKO.BIN", "STONE.BIN", "SYUGOITM.BIN", "VB19PIN.BIN",
	"VG08PIN.BIN", "BP0_AFT.BIN", "BOOT.BIN", "G1LOAD.BIN", "OVER.BIN", "BOGU.BIN"
}

--60 out of 1,100 files require the godspeed patch.
godspeed_files = {
	"VA05.BIN", "VA06.BIN", "VA08.BIN", "VA24.BIN", "VB04.BIN", "VB07.BIN",
	"VB09.BIN", "VB10.BIN", "VB12.BIN", "VC04.BIN", "VC07.BIN", "VC09.BIN",
	"VC28.BIN", "VC30.BIN", "VD07.BIN", "VE06.BIN", "VF01.BIN", "VF02.BIN",
	"VF04.BIN", "VI05.BIN", "VI10.BIN", "VI11.BIN", "VJ24.BIN", "VK06.BIN",
	"DOUGUYA1.BIN", "DOUGUYA2.BIN", "KAJIYA1.BIN", "KAJIYA2.BIN", "KANTEIY1.BIN",
	"KANTEIY2.BIN", "KOUEKI1.BIN", "KOUEKI2.BIN", "KPARTY1.BIN", "KPARTY2.BIN",
	"MONSYOY1.BIN", "MONSYOY2.BIN", "PARTYIN1.BIN", "PARTYIN2.BIN", "FUDAZUK.BIN",
	"HDOUGUYA.BIN", "HKAJIYA.BIN", "HMONSYOY.BIN", "KIKORI.BIN", "MOGURA.BIN",
	"PARTYCE1.BIN", "PARTYCH2.BIN", "PARTYCHG.BIN", "RBATTLE.BIN", "REST.BIN",
	"SOUKO.BIN", "STONE.BIN", "SYUGOITM.BIN", "TANTEI.BIN","VB19PIN.BIN",
	"VG08PIN.BIN", "BP0_AFT.BIN", "BOOT.BIN", "G1LOAD.BIN", "OVER.BIN", "EMBL.BIN"
}

--61 out of 1,100 files require the gozz patch.
gozz_files = {
	"VA05.BIN", "VA06.BIN", "VA08.BIN", "VA24.BIN", "VB04.BIN", "VB07.BIN",
	"VB09.BIN", "VB10.BIN", "VB12.BIN", "VC04.BIN", "VC07.BIN", "VC09.BIN",
	"VC28.BIN", "VC30.BIN", "VD07.BIN", "VE06.BIN", "VF01.BIN", "VF02.BIN",
	"VF04.BIN", "VG11.BIN", "VI05.BIN", "VI10.BIN", "VI11.BIN", "VJ24.BIN",
	"VK06.BIN",	"DOUGUYA1.BIN", "DOUGUYA2.BIN", "KAJIYA1.BIN", "KAJIYA2.BIN", "KANTEIY1.BIN",
	"KANTEIY2.BIN", "KOUEKI1.BIN", "KOUEKI2.BIN", "KPARTY1.BIN", "KPARTY2.BIN",
	"MONSYOY1.BIN", "MONSYOY2.BIN", "PARTYIN1.BIN", "PARTYIN2.BIN", "FUDAZUK.BIN",
	"HDOUGUYA.BIN", "HKAJIYA.BIN", "HMONSYOY.BIN", "KIKORI.BIN", "MOGURA.BIN",
	"PARTYCE1.BIN", "PARTYCH2.BIN", "PARTYCHG.BIN", "RBATTLE.BIN", "REST.BIN",
	"SOUKO.BIN", "STONE.BIN", "SYUGOITM.BIN", "VB19PIN.BIN", "VG08PIN.BIN",
	"BP0_AFT.BIN", "BOOT.BIN", "G1LOAD.BIN", "OVER.BIN", "EMBL.BIN", "MAGI.BIN",
}

function PatchRequested(name)
	local i, v;
	for i, v in ipairs(patchreq) do
		if(v.file == name) then
			return true;
		end
	end
	return false;
end

function ApplyPatch(patch, file)
	local i, j, v, patchbyte;
	for j, v in pairs(patch) do
		for i, patchbyte in ipairs(v) do
			file[j + i - 1] = patchbyte;
		end
	end
end

function ApplyPatches(name, deFile)
	local i, v;
	local touched = false;
	local file = Buffer(true);
	for i, v in ipairs(patchreq) do
		if(v.file == name) then
			if(v.patch == nil) then
				if(touched == true) then error("Cannot replace file from HDD after another patch has been applied.  Check patch order.") end
				print("PATCHER: Loading " .. name .. " from pre-patched file on HDD for " .. v.name);
				local tmp = Input(name);
				file:copyfrom(tmp);
				touched = true;
			else
				if(touched == false) then
					print("PATCHER:  Loading " .. name .. " from source disc.");
					local tmp = cdfile(deFile);
					file:copyfrom(tmp);
					touched = true;
				end
				print("PATCHER: Updating " .. name .. " with " .. v.name);
				ApplyPatch(v.patch, file);
			end
		end
	end
	if(touched == false) then
		print("No patches found for file " .. name .. " copying from source disc.");
		file = cdfile(deFile);
	end
	return file;
end

function IsGodspeedFile(name)
	for i, v in ipairs(godspeed_files) do
		if (v==name) then
			return true
		end
	end
	return false;
end

function ApplyGodspeedPatch(file, name)
	local i, touched = false;
	i = 0
	while (i < file:getsize()) do
		if(file[i] == 0x4E
		 and file[i + 1] == 0x22
		 and file[i + 2] == 0x25
		 and file[i + 3] == 0x15
		 and file[i + 4] == 0x10
		 and file[i + 5] == 0x42
		 and file[i + 6] == 0x1F
		 and file[i + 7] == 0x1C
		 and file[i + 8] == 0x29) then
			file:wseek(i)
			file:writeU32(0x23141F41);
			file:writeU32(0x14151520);
			file:writeU8(0);
			i = file:seek(file:wtell());
			touched = true;
		end
		i=i+1;
	end
	file:seek(file:wseek(0));
	if(touched == true) then print("PATCHER: Applied Godspeed Patch to "..name); end
end

function IsGozzFile(name)
	for i, v in ipairs(gozz_files) do
		if (v==name) then
			return true
		end
	end
	return false;
end

function ApplyGozzPatch(file, name)
	local i, touched = false;
	i = 0
	while (i < file:getsize()) do
		if(file[i] == 0x41
		 and file[i + 1] == 0x1F
		 and file[i + 2] == 0x2A
		 and file[i + 3] == 0x2A
		 and file[i + 4] == 0x00) then
			local tmp_patch = { [i] = patch_gozz_data[patch_gozz_type] };
			ApplyPatch(tmp_patch, file);
			i = i + 5;
			touched = true;
		end
		i=i+1;
	end
	file:seek(file:wseek(0));
	if(touched == true) then print("PATCHER: Applied Gozz Rune Patch to "..name); end
end

function IsCircletFile(name)
	for i, v in ipairs(circlet_files) do
		if (v==name) then
			return true
		end
	end
	return false;
end

function ApplyCircletPatch(file, name)
	local i, touched = false;
	i = 0
	while (i < file:getsize()) do
		if(file[i] == 0x3D
		 and file[i + 1] == 0x19
		 and file[i + 2] == 0x22
		 and file[i + 3] == 0x13
		 and file[i + 4] == 0x25
		 and file[i + 5] == 0x22
		 and file[i + 6] == 0x15
		 and file[i + 7] == 0x24
		 and file[i + 8] == 0x00) then
			file:wseek(i)
			file:writeU32(0x1322193D);
			file:writeU32(0x0024151C);
			file:writeU8(0);
			i = file:seek(file:wtell());
			touched = true;
		end
		i=i+1;
	end
	file:seek(file:wseek(0));
	if(touched == true) then print("PATCHER: Applied Circlet Patch to "..name); end
end

function IsSearchPatchFile(name)
	return (IsCircletFile(name) or IsGodspeedFile(name) or IsGozzFile(name));
end

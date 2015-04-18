loadmodule "lualibs"
loadmodule "luahandle"
loadmodule "luacd"
loadmodule "luaiup"

--dofile("patchlist.lua")
dofile("patcher.lua")

strMargin			= "10x10"
strGapStandard		= "10"
strApplicationName	= PackageInfo.ShortName .. " v" .. PackageInfo.Version .. " - " .. PackageInfo.Date
strTextBoxWidth		= "300"
strListSize			= "180x110"
strDescSize			= "200x30"
strDescFontSize		= "7"
strSourceImageName  = nil
strTargetImageName  = nil
intGameIdx			= 1
intAvailableId		= 1
intSelectedId		= 2
iso					= nil
cdutil				= nil
strPatchStatus		= "Verifying Disc..."
intPatchProgress	= 0
intMaxProgress		= 2800
coproc				= nil
pathtree 			= { }
finalsector 		= 218497
stdprint			= print
logfile				= Output("gs2patch.log")
workdir				= ".\\patch\\temp"
patchdir			= ""

------------------------------------------------------------------------------------------------------------------
-- INTERFACE OBJECTS                                                                                            --
------------------------------------------------------------------------------------------------------------------

--Game Selection
lblPatchGame		= iup.label { title = "Patch Game:", tip = "Name and version of the game to be patched." }
lstPatchGame		= iup.list { dropdown="YES", value=intGameIdx}

--Source/Original ISO image
lblOriginalImage	= iup.label { title = "Original Image:", tip = "The source ISO for patching." }
txtOriginalImage	= iup.text { size = strTextBoxWidth, readonly = "YES"}
btnOriginalImage	= iup.button { title = "Browse...", action=SourceImageFileDlg }

--Target/Patched ISO image
lblPatchedImage		= iup.label { title = "Patched Image:", tip = "The target ISO that will contain the patches." }
txtPatchedImage		= iup.text { size = strTextBoxWidth, readonly = "YES"}
btnPatchedImage		= iup.button { title = "Browse...", action=TargetImageFileDlg}

--Available, unselected patches
lblPatchAvailable 	= iup.label { title = "Available Patches:", tip = "Click patches to select them."}
lstPatchAvailable 	= iup.list { multiple="YES", size=strListSize }
txtPatchAvailable 	= iup.label { title = "Patch Description", size=strDescSize, fontsize=strDescFontSize, alignment="ALEFT", wordwrap = "YES" }

--Selected patches
lblPatchSelected  	= iup.label { title = "Selected Patches:", tip = "These patches will be applied."}
lstPatchSelected  	= iup.list { multiple="YES", size=strListSize }
txtPatchSelected  	= iup.label { title = "Patch Description", size=strDescSize, fontsize=strDescFontSize, alignment="ALEFT", wordwrap = "YES" }

--Toggle buttons for patches
btnPatchActivate	= iup.button { title = "> >", tip = "Activate patches."}
btnPatchDeactivate	= iup.button { title = "< <", tip = "Deactivate patches."}

btnPatchApply		= iup.button { title = "Apply Patch", tip = "Build target image with selected patches."}

--Progress Bar
pbPatchProgress  	= iup.progressbar { max=intMaxProgress, dashed = "NO", value = intPatchProgress, size="400x20"}
lblPatchProgress 	= iup.label { title=strPatchStatus, size = "400x10" }
boxPatchProgress 	= iup.vbox { lblPatchProgress, pbPatchProgress; alignment="ALEFT", gap="2" }

------------------------------------------------------------------------------------------------------------------
-- END INTERFACE OBJECTS                                                                                        --
------------------------------------------------------------------------------------------------------------------
function print(...)
	res = ""
	aargs = {...}
	for i, v in ipairs(aargs) do
		res = res .. tostring(v) .. " "
	end
	res = res .. "\r\n"
	logfile:write(res)
end


function btnOriginalImage:action ()
	--iup.Message("Testing...", "Test Succeeded")
	local FileDlg = iup.filedlg { dialogtype="OPEN", title="Select Source Image",
								   extfilter="CD Image Files|*.img;*.bin;*.iso|All Files|*.*|" }
	FileDlg:popup(IUP_CENTER, IUP_CENTER)
	local ret = FileDlg.status
	if ( ret ~= "0" ) then
		txtOriginalImage.value = nil
		strSourceImageName = nil
	else
		if ( FileDlg.value == strTargetImageName) then
			iup.Message("File Error", "Source and patched images cannot be the same file!")
			txtOriginalImage.value = nil
			strSourceImageName = nil
		else
			txtOriginalImage.value = FileDlg.value
			strSourceImageName = FileDlg.value
		end
	end
	return iup.DEFAULT
end

function btnPatchedImage:action ()
	local FileDlg = iup.filedlg { dialogtype="SAVE", title="Patched Image",
								   extfilter="CD Image Files|*.img;*.bin;*.iso|All Files|*.*|" }
	FileDlg:popup(IUP_CENTER, IUP_CENTER)
	local ret = FileDlg.status
	if ( ret == "-1" ) then
		txtPatchedImage.value = nil
		strTargetImageName = nil
	else
		if ( FileDlg.value == strSourceImageName) then
			iup.Message("File Error", "Source and patched images cannot be the same file!")
			txtPatchedImage.value = nil
			strTargetImageName = nil
		else
			txtPatchedImage.value = FileDlg.value
			strTargetImageName = FileDlg.value
		end
	end
	return iup.DEFAULT
end

function idle_cb()
	if not coroutine.resume(coproc) then
		return iup.DEFAULT
	end
	if (intPatchProgress == 0 or intPatchProgress == intMaxProgress) then
		return iup.DEFAULT
	end

	pbPatchProgress.value = intPatchProgress
	lblPatchProgress.title = strPatchStatus
	print("Progress: " .. tostring(intPatchProgress) .. "\t:" .. strPatchStatus)

	return iup.DEFAULT
end

function CreatePatchedImage ()
	print("Preparing to create patch from: " .. strSourceImageName)
	print("Writing patch to: " .. strTargetImageName)
	print("Retrieving file and LBA listings from patch configuration.")
	FileList	 = GetFileList(intGameIdx)
	LBAPatchList = GetLBAList(intGameIdx)
	print("Got listings.")

	local iso_in = cdabstract(strSourceImageName)
	cdutil = cdutils(iso_in)
	cdutil.iso_in = iso_in
	local ret = verify(cdutil, GetMainExeName(intGameIdx), workdir)
	if(not ret) then
		dlgPatchProgress:hide()
		--dlgPatchProgress:destroy()
		iup.Message("Wrong Disc", "This is not a " .. GetRegionInfo(intGameIdx) .. " Suikoden II disc.")
		print("ERROR: Disc supplied is for the wrong region.  Region " .. GetRegionInfo(intGameIdx) .. " specified.")
		return iup.DEFAULT
	end
	intPatchProgress = 25
	strPatchStatus = "Disc verified.  Beginning patch process..."
	coroutine.yield()

	extract(cdutil, workdir)
	intPatchProgress = intPatchProgress + 10
	strPatchStatus = "Disc extraction completed. Applying selected patches..."
	coroutine.yield()

	patchdir = ".\\" .. GetPatchDir(intGameIdx)

	ret = ApplyPatches(GetPatches(intGameIdx), workdir, patchdir)
	if(ret ~= 0) then
		print("Aborting patch process on failure.")
		cdutil.iso_in:close()
		dlgPatchProgress:hide()
		dlgPatchProgress:destroy()
		iup.Message("Failure", "Failed applying one or more patches with code: " .. tostring(ret))
		return iup.DEFAULT
	end

	local iso_out_file = Output(strTargetImageName)
	local iso = isobuilder(iso_out_file)
	iso.iso_out_file = iso_out_file
	buildcd(cdutil, iso, workdir)
	iso:close()
	iso_out_file:close()
	cdutil.iso_in:close()

	intPatchProgress = intMaxProgress
	strPatchStatus = "Patch process completed!"
	coroutine.yield()
	dlgPatchProgress:hide()
	dlgPatchProgress:destroy()

	--Leave the dialog open so patch list can be reviewed, but render it useless.
	btnPatchApply.Active = "NO"
	btnPatchActivate.Active = "NO"
	btnPatchDeactivate.Active = "NO"
	btnOriginalImage.Active = "NO"
	btnPatchedImage.Active = "NO"
	lstPatchGame.Active = "NO"
	iup.Message("Success!", "Patch process completed successfully.")
end

function CreateMainDialog ()
	local id = 0
	for i,v in ipairs(PackageInfo.Games) do
		local tmp = v.Name .. " - " .. v.Region .. " (" .. v.Language .. ")"
		id = id + 1
		lstPatchGame[id] = tmp
	end

	boxPatchGame		= iup.hbox { lblPatchGame, lstPatchGame; gap = 25, margin = strMargin, alignment="ACENTER"}
	boxOriginalImage	= iup.hbox { lblOriginalImage, txtOriginalImage, btnOriginalImage; gap = strGapStandard, margin = strMargin, alignment="ACENTER"}
	boxPatchedImage		= iup.hbox { lblPatchedImage, txtPatchedImage, btnPatchedImage; gap = strGapStandard, margin = strMargin, alignment="ACENTER"}
	boxToggleActive		= iup.vbox { btnPatchActivate, btnPatchDeactivate; alignment="ACENTER", margin="20x50", gap="40" }
	boxPatchAvailable 	= iup.vbox { lblPatchAvailable, lstPatchAvailable, txtPatchAvailable, btnPatchApply; alignment="ALEFT"}
	boxPatchSelected  	= iup.vbox { lblPatchSelected, lstPatchSelected, txtPatchSelected; alignment="ALEFT"}
	boxSelection		= iup.hbox { boxPatchAvailable, boxToggleActive, boxPatchSelected; gap = strGapStandard, margin = strMargin }
	boxInterface		= iup.vbox { boxPatchGame, boxOriginalImage, boxPatchedImage, boxSelection; alignment="ALEFT"}
	dlg					= iup.dialog { boxInterface; title = strApplicationName, size = "470x280" }
	dlgPatchProgress 	= iup.dialog { boxPatchProgress; alignment="ALEFT", resize="NO", maxbox="NO", topmost="YES",
									minbox="NO", menubox="NO", border="YES", resize="NO", parentdialog=dlg, bringfront="YES" }
	dlg:show()
	LoadPatchListBoxes(intGameIdx)
	iup.MainLoop()
end

function LoadPatchListBoxes (gameidx)
	--clear both lists
	lstPatchAvailable[1] = nil
	lstPatchSelected[1] = nil

	local aidx = 1
	local sidx = 1
	for i,v in ipairs(PackageInfo.Games[gameidx].Patches) do
		if (v.Active == 1) then
			lstPatchSelected[sidx] = v.Name
			sidx = sidx + 1
		else
			lstPatchAvailable[aidx] = v.Name
			aidx = aidx + 1
		end
		v.Toggle = 0
	end
end

function lstPatchGame:action(t, i, v)
	if v > 0 then
		LoadPatchListBoxes(i)
		intGameIdx = i
	end
	return iup.DEFAULT
end

function ClearDescriptions()
	txtPatchAvailable["title"] = nil
	txtPatchSelected["title"] = nil
end

function lstPatchAvailable:action (t, i, v)
	if(v == 1) then
		TogglePatch(intGameIdx, intAvailableId, t, v)
		local tmp = GetPatch(intGameIdx, t)
		local desc = tmp.Description
		if(tmp.Excludes ~= nil) then
			desc = desc .. "\nExcludes: "
			for i, v in ipairs(tmp.Excludes) do
				desc = desc .. v .. ", "
			end
			desc = string.sub(desc, 1, string.len(desc) - 2)
		end
		txtPatchAvailable["title"] = desc
	else
		TogglePatch(intGameIdx, 0, t, v)
	end
	return iup.DEFAULT
end

function lstPatchSelected:action (t, i, v)
	if(v == 1) then
		TogglePatch(intGameIdx, intSelectedId, t, v)
		local tmp = GetPatch(intGameIdx, t)
		txtPatchSelected["title"] = tmp.Description
	else
		TogglePatch(intGameIdx, 0, t, v)
	end
	return iup.DEFAULT
end

function btnPatchActivate:action()
	UpdatePatchStatuses(intGameIdx, intAvailableId)
	LoadPatchListBoxes(intGameIdx)
	ClearDescriptions()
	return iup.DEFAULT
end

function btnPatchDeactivate:action()
	UpdatePatchStatuses(intGameIdx, intSelectedId)
	LoadPatchListBoxes(intGameIdx)
	ClearDescriptions()
	return iup.DEFAULT
end

function SpawnPatchRoutine()
	coproc = coroutine.create(CreatePatchedImage)
	iup.SetIdle(idle_cb)
	dlgPatchProgress:show()
end

function btnPatchApply:action()
    if(strSourceImageName == nil or strSourceImageName == '') then
		iup.Message("Error", "You must choose a source image to apply the patch.")
		print("ERROR: Source ISO path invalid.")
		return iup.DEFAULT
	end
	if(strTargetImageName == nil or strTargetImageName == '') then
		iup.Message("Error", "You must specify a target image to apply the patch.")
		print("ERROR: Target ISO path invalid.")
		return iup.DEFAULT
	end
	if(not HasActivePatches(intGameIdx)) then
		iup.Message("Error", "At least one patch must be selected.")
		print("ERROR: No patches selected.")
		return iup.DEFAULT
	end
	SpawnPatchRoutine()
	return iup.DEFAULT
end

function main_patch ()
  print("Setting up patch dialog")
  CreateMainDialog()
end

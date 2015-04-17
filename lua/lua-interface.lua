 ------------------
-- misc functions --
 ------------------

function extract_file(source, dest, mode)
    if (mode == nil) then
	source = cdfile(source)
    else
	source = cdfile(source, mode)
    end
    dest = Output(dest)
    source:copyto(dest)
end

function insert_file(source, dest, mode)
    if (type(source) == "string") then
        source = Input(source)
    end
    if (type(dest) == "string") then
	dest = findpath(dest)
    end
    if (mode == nil) then
	writefile(source, -1, dest.Sector)
    else
	writefile(source, -1, dest.Sector, mode)
    end
end

function display(inp, n)
    local i
    if (type(inp) == "string") then
        inp = Input(inp)
    elseif (type(inp) ~= "table") then
        error("Display needs a string or an Input object")
    end
    
    i = 0
    
    while(not inp:isclosed()) do
	i = i + 1
        print(inp:read())
	if ((n ~= nil) and (i >= n)) then
	    return
	end
    end
end

function pchar(n)
    if (not ((n >= 32) and (n <= 127))) then
        n = 46 -- aka '.' or 0x2e
    end
    return hex(n, "%c")
end

function hexdump(inp, from, to, width)
    local size, nlines, remaining, data_array, line, byte, outstring
    
    if (type(inp) == "string") then
        inp = Input(inp)
    elseif (type(inp) ~= "table") then
        error("Hexdump needs a string or an Input object")
    end
    
    size = inp:getsize()

    if (from == nil) then
        from = 0
    end
    
    if (to == nil) then
        to = size
    end
    
    if (to > size) then
        to = size
    end
    
    size = to - from
    
    if (width == nil) then
        width = 16
    end
    
    nlines = math.floor(size / width)
    remaining = math.mod(size, width)
    inp:seek(from)
    data_array = inp:read(size)
    
    for line = 0, nlines - 1, 1 do
        outstring = hex(line * width + from, "%08x   ")
        for byte = 0, width - 1, 1 do
            outstring = outstring .. hex(data_array[line * 16 + byte]) .. " "
        end
        outstring = outstring .. "  "
        for byte = 0, width - 1, 1 do
            outstring = outstring .. pchar(data_array[line * 16 + byte])
        end
        print(outstring)
    end
    
    if (remaining == 0) then
        return
    end
    
    outstring = hex(nlines * width + from, "%08x   ");
    for byte = 0, remaining - 1, 1 do
        outstring = outstring .. hex(data_array[nlines * 16 + byte]) .. " "
    end
    for byte = remaining + 1, width - 1, 1 do
        outstring = outstring .. "   "
    end
    outstring = outstring .. "  "
    for byte = 0, remaining - 1, 1 do
        outstring = outstring .. pchar(data_array[nlines * 16 + byte])
    end

    print(outstring)
end


 --------------------------
-- cdutil object wrappers --
 --------------------------

function check_cdutil()
    if (cdutil == nil) then error "cdutil object non existant" end
end

function cdfile(arg1, arg2, arg3, arg4)    
    local cdutil_implied = false
    
    if ((type(arg1) ~= "table") or (arg1.cdfile == nil)) then
	check_cdutil()
        cdutil_implied = true
	if (type(arg1) == "string") then
	    arg1 = findpath(arg1)
	end
    else
	if (type(arg2) == "string") then
	    arg2 = findpath(arg2)
	end
    end
    
    if ((arg2 == nil) and (arg3 == nil) and (arg4 == nil)) then
        return cdutil:cdfile(arg1)
    elseif ((arg3 == nil) and (arg4 == nil)) then
        if (cdutil_implied) then
            return cdutil:cdfile(arg1, arg2)
        else
            return arg1:cdfile(arg2)
        end
    elseif (arg4 == nil) then
        if (cdutil_implied) then
            return cdutil:cdfile(arg1, arg2, arg3)
        else
            return arg1:cdfile(arg2, arg3)
        end
    else
        return arg1:cdfile(arg2, arg3, arg4)
    end
end

function setisow(iso_w)
    check_cdutil()
    return cdutil:setisow(iso_w)
end

function guessmode(sect)
    check_cdutil()
    if (sect == nil) then
        return cdutil:guessmode()
    else
        return cdutil:guessmode(sect)
    end
end

function sectorseek(sect)
    check_cdutil()
    return cdutil:sectorseek(sect)
end

function readsector(sect, mode)
    check_cdutil()
    if (sect == nil) then
        return cdutil:readsector()
    elseif (mode == nil) then
        return cdutil:readsector(sect)
    else
        return cdutil:readsector(sect, mode)
    end
end

function readdatas(size, sector, mode)
    check_cdutil()
    if (sect == nil) then
        return cdutil:readdatas(size)
    elseif (mode == nil) then
        return cdutil:readdatas(size, sect)
    else
        return cdutil:readdatas(size, sect, mode)
    end
end

function readfile(handle, size, sector, mode)
    check_cdutil()
    if (sect == nil) then
        return cdutil:readfile(handle, size)
    elseif (mode == nil) then
        return cdutil:readfile(handle, size, sect)
    else
        return cdutil:readfile(handle, size, sect, mode)
    end
end

function writesector(array, sector, mode)
    check_cdutil()
    if (sector == nil) then
        return cdutil:writesector(array, sector)
    elseif (mode == nil) then
        return cdutil:writesector(array, sector, mode)
    end
end

function writedatas(array, size, sector, mode)
    check_cdutil()
    if (sector == nil) then
        return cdutil:writedatas(array, size)
    elseif (mode == nil) then
        return cdutil:writedatas(array, size, sector)
    else
        return cdutil:writedatas(array, size, sector, mode)
    end
end

function writefile(handle, size, sector, mode)
    check_cdutil()
    if (size == nil) then
        return cdutil:writefile(handle)
    elseif (sector == nil) then
        return cdutil:writefile(handle, size)
    elseif (mode == nil) then
        return cdutil:writefile(handle, size, sector)
    else
        return cdutil:writefile(handle, size, sector, mode)
    end
end

function findpath(path)
    check_cdutil()
    if (findpath == nil) then
	return cdutil:findpath "/"
    else
	return cdutil:findpath(path)
    end
end

function findparent(path)
    check_cdutil()
    return cdutil:findparent(path)
end

function finddirectory(dir, path)
    check_cdutil()
    return cdutil:finddirectory(dir, path)
end


 -----------------------
-- iso object wrappers --
 -----------------------

function check_iso()
    if (iso == nil) then error "iso object non existant" end
end

function foreword(lcdutil)
    check_iso()
    if ((lcdutil == nil) and (cdutil == nil)) then error "cdutil object non existant" end
    if (lcdutil == nil) then
        return iso:foreword(cdutil)
    else
        return iso:foreword(lcdutil)
    end
end

function foreword_handle(handle, mode)
    check_iso()
    if (mode == nil) then
        return iso:foreword_handle(handle)
    else
        return iso:foreword_handle(handle, mode)
    end
end

function foreword_array(array, mode)
    check_iso()
    if (mode == nil) then
        return iso:foreword_array(array)
    else
        return iso:foreword_array(array, mode)
    end
end

function getdispsect()
    check_iso()
    return iso:getdispsect()
end

function putfile(handle, mode, sector)
    check_iso()
    if (mode == nil) then
        iso:putfile(handle)
    elseif (sector == nil) then
        iso:putfile(handle, mode)
    else
        iso:putfile(handle, mode, sector)
    end
end

function putdatas(array, size, mode, sector)
    check_iso()
    if (mode == nil) then
        iso:putdatas(array, size)
    elseif (sector == nil) then
        iso:putdatas(array, size, mode)
    else
        iso:putdatas(array, size, mode, sector)
    end
end

function createsector(array, mode, sector)
    check_iso()
    if (mode == nil) then
        iso:createsector(array)
    elseif (sector == nil) then
        iso:createsector(array, mode)
    else
        iso:createsector(array, mode, sector)
    end
end

function setEOF()
    check_iso()
    iso:setEOF()
end

function clearEOF()
    check_iso()
    iso:clearEOF()
end

function setbasics(pvd, rootsize, ptsize, nvd, rootsect)
    check_iso()
    if (rootsize == nil) then
        iso:setbasics(pvd)
    elseif (ptsize == nil) then
        iso:setbasics(pvd, rootsize)
    elseif (nvd == nil) then
        iso:setbasics(pvd, rootsize, ptsize)
    elseif (rootsect) then
        iso:setbasics(pvd, rootsize, ptsize, nvd)
    else
        iso:setbasics(pvd, rootsize, ptsize, nvd, rootsect)
    end
end

function createdir(dirtree, name, size, direntry, mode)
    check_iso()
    if (size == nil) then
        iso:createdir(dirtree, name)
    elseif (mode == nil) then
        iso:createdir(dirtree, name, size, direntry)
    else
        iso:createdir(dirtree, name, size, direntry, mode)
    end
end

function createfile(dirtree, name, size, direntry, mode)
    check_iso()
    if (mode == nil) then
        iso:createfile(dirtree, name, size, direntry)
    else
        iso:createfile(dirtree, name, size, direntry, mode)
    end
end

function copydir(dirtree, cdutils, direntry, mode)
    check_iso()
    if (mode == nil) then
        iso:copydir(dirtree, cdutils, direntry)
    else
        iso:copydir(dirtree, cdutils, direntry, mode)
    end
end

function close(cuefile, mode, nsectors)
    check_iso()
    if (cuefile == nil) then
        iso:close()
    elseif (mode == nil) then
        iso:close(cuefile)
    elseif (nsectors == nil) then
        iso:close(cuefile, mode)
    else
        iso:close(cuefile, mode, nsectors)
    end
end

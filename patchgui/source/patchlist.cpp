#include "patchlist.h"

cPatchFile::cPatchFile(wstring name, wstring type)
{
	m_Name = name;
	transform(type.begin(), type.end(), type.begin(), ::toupper);
	if(type == L"ASM")
		m_Type = PFT_ASSEMBLY;
	else if(type == L"BIN")
		m_Type = PFT_BINARY;
	else
		m_Type = PFT_UNKNOWN;
};

cPatchFile::cPatchFile(wstring name, unsigned char type)
{
	m_Name = name;
	m_Type = type > PFT_LAST_TYPE ? PFT_UNKNOWN : type;
}

cPatchFile & cPatchFile::operator=(const cPatchFile &file)
{
	m_Name = file.m_Name;
	m_Type = file.m_Type;
	return *this;
}

cPatchSearch::cPatchSearch(wstring oldvalue, wstring newvalue, wstring varqual, bool sensitive)
{
	m_NewValue = newvalue;
	m_OldValue = oldvalue;
	m_VarQual = varqual;
	m_CaseSensitive = sensitive;
}

cPatchSearch::cPatchSearch(wstring oldvalue, wstring newvalue, wstring varqual, wstring sensitive)
{
	m_NewValue = newvalue;
	m_OldValue = oldvalue;
	m_VarQual = varqual;
	transform(sensitive.begin(), sensitive.end(), sensitive.begin(), ::toupper);
	m_CaseSensitive = sensitive == L"TRUE" ? true : false;
}

cPatchSearch & cPatchSearch::operator=(const cPatchSearch &search)
{
	m_NewValue = search.m_NewValue;
	m_OldValue = search.m_OldValue;
	m_CaseSensitive = search.m_CaseSensitive;
	return *this;
}

cPatchRef::cPatchRef(wstring name)
{
	m_PatchName = name;
	m_pPatch = NULL;
}

cPatchRef::cPatchRef(cPatch& patch)
{
	m_PatchName = patch.m_Name;
	m_pPatch = &patch;
}

wstring cPatchRef::PatchName()
{
	return m_PatchName;
}

cPatch * cPatchRef::Patch()
{
	return m_pPatch;
}

cPatch::cPatch(wstring name, wstring desc, bool active)
{
	m_Name = name;
	m_Description = desc;
	m_Active = active;
}

cPatch::cPatch(wstring name, wstring desc, wstring active)
{
	m_Name = name;
	m_Description = desc;
	transform(active.begin(), active.end(), active.begin(), ::toupper);
	m_Active = active == L"TRUE" ? true : false;
}

bool cPatch::AddPatchFile(cPatchFile& file)
{
	//TODO: handle alloc exception?
	m_PatchFile.push_back(file);
	return true;
}

bool cPatch::AddPatchFile(wstring name, wstring type)
{
	cPatchFile file(name, type);
	return AddPatchFile(file);
}

cPatchFile cPatch::PatchFile(wstring name)
{
	for(cPatchFileIterator iter = m_PatchFile.begin(); iter != m_PatchFile.end(); iter++)
	{
		if(iter->m_Name == name) return *iter;
	}
	return cPatchFile(L"", L"");
}

cPatchFile cPatch::PatchFile(int idx)
{
	return m_PatchFile[idx];
}

/*
cPatchFile cPatch::NextPatchFile(bool restart)
{
	static cPatchFileIterator iterPatchFile = m_PatchFile.begin();
	if(restart) iterPatchFile = m_PatchFile.begin();
	if(iterPatchFile == m_PatchFile.end()) return cPatchFile("", "");
	cPatchFile file = *iterPatchFile;
	iterPatchFile++;
	return file;
}
*/
bool cPatch::AddPatchSearch(cPatchSearch& search)
{
	//TODO: handle alloc exception?
	m_PatchSearch.push_back(search);
	return true;
}

bool cPatch::AddPatchSearch(wstring oldvalue, wstring newvalue, wstring varqual, wstring sensitive)
{
	cPatchSearch search(oldvalue, newvalue, sensitive, varqual);
	return AddPatchSearch(search);
}

cPatchSearch cPatch::PatchSearch(int idx)
{
	return m_PatchSearch[idx];
}

bool cPatch::AddExclusion(wstring exclusion)
{
	cPatchRef ref(exclusion);
	m_Exclusion.push_back(ref);
	return true;
}

cPatchRef & cPatch::Exclusion(int idx)
{
	return m_Exclusion[idx];
}

bool cPatch::AddRequirement(wstring requirement)
{
	cPatchRef ref(requirement);
	m_Requirement.push_back(ref);
	return true;
}

cPatchRef & cPatch::Requirement(int idx)
{
	return m_Requirement[idx];
}

cGame::cGame(wstring name, wstring region, wstring language, wstring serial, wstring patchdir)
{
	m_Name = name;
	m_Region = region;
	m_Language = language;
	m_Serial = serial;
	m_PatchDir = patchdir;
}

bool cGame::AddPatch(cPatch& patch)
{
	m_PatchList.push_back(patch);
	return true;
}
#ifndef _PATCHLIST_H_
#define _PATCHLIST_H_

#include <string>
#include <vector>
#include <list>
#include <algorithm>
using namespace std;

enum PatchFileType {
	PFT_UNKNOWN,
	PFT_ASSEMBLY,
	PFT_BINARY,
	PFT_LAST_TYPE = PFT_BINARY
};

class cPatchFile
{
public:
	wstring m_Name;
	unsigned char m_Type;

	cPatchFile() {};
	cPatchFile(wstring name, wstring type);
	cPatchFile(wstring name, unsigned char type);
	cPatchFile & operator=(const cPatchFile &file);
};

class cPatchSearch
{
public:
	wstring m_OldValue;
	wstring m_NewValue;
	wstring m_VarQual;
	bool m_CaseSensitive;

	cPatchSearch() {};
	cPatchSearch(wstring oldvalue, wstring newvalue, wstring varqual, bool sensitive=false);
	cPatchSearch(wstring oldvalue, wstring newvalue, wstring varqual, wstring sensitive=L"false");
	cPatchSearch & operator=(const cPatchSearch &search);
};

class cPatch;

class cPatchRef
{
public:
	wstring m_PatchName;
	cPatch *m_pPatch;

	cPatchRef() {};
	cPatchRef(cPatch& patch);
	cPatchRef(wstring name);
	wstring PatchName();
	cPatch * Patch();
};

class cPatch
{
public:
	wstring m_Name;
	wstring m_Description;
	bool m_Active;
	vector<cPatchFile> m_PatchFile;
	vector<cPatchSearch> m_PatchSearch;
	vector<cPatchRef> m_Exclusion;
	vector<cPatchRef> m_Requirement;

	cPatch() {};
	cPatch(wstring name, wstring desc, bool active=false);
	cPatch(wstring name, wstring desc, wstring active=L"false");
	bool AddPatchFile(cPatchFile& file);
	bool AddPatchFile(wstring name, wstring type);
	cPatchFile PatchFile(wstring name);
	cPatchFile PatchFile(int idx);
	bool AddPatchSearch(cPatchSearch &search);
	bool AddPatchSearch(wstring oldvalue, wstring newvalue, wstring varqual, wstring sensitive);
	cPatchSearch PatchSearch(int idx);
	bool AddExclusion(wstring exclusion);
	bool AddExclusion(cPatch& patch);
	cPatchRef & Exclusion(int idx);
	cPatchRef & Exclusion(wstring name);
	bool AddRequirement(wstring requirement);
	bool AddRequirement(cPatch& patch);
	cPatchRef & Requirement(int idx);
	cPatchRef & Requirement(wstring name);
};

typedef vector<cPatchFile>::iterator cPatchFileIterator;
typedef vector<cPatchSearch>::iterator cPatchSearchIterator;
typedef vector<cPatchRef>::iterator cPatchRefIterator;
typedef list<cPatch>::iterator cPatchIterator;

class cGame
{
public:
	wstring m_Name;
	wstring m_Region;
	wstring m_Language;
	wstring m_Serial;
	wstring m_PatchDir;
	list<cPatch> m_PatchList;

	cGame() {};
	cGame(wstring name, wstring region, wstring language, wstring serial, wstring patchdir);
	bool AddPatch(cPatch& patch);
	//bool AddPatch(wstring name, wstring desc, wstring active);
	cPatch Patch(wstring name);
	cPatch Patch(int idx);
	//cPatch NextPatch(bool restart=false);
};

struct PatchByName: public std::binary_function< cPatch, wstring, bool >
{
	bool operator () ( const cPatch &patch, const wstring &name ) const
	{
	  return patch.m_Name == name;
    }
};

#endif //_PATCHLIST_H_

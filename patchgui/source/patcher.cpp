/*
 * patcher.cpp -- Main project file
 *
 * Copyright (C) 2012 Pyriel
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 */

/*
 *  This file does all the fun, user-facing tasks, like parsing input text
 *  and deciding how to deal with it.
 */
#define UNICODE
#include <windows.h>
#include <windowsx.h>
#include <commctrl.h>
#include <Shlwapi.h>
#include <stdio.h>
#include <malloc.h>
#include "pugixml.hpp"
#include "patchlist.h"
#include "runbatch.h"
#include "resource.h"

#define PS_PAGES 3
#define ID_BUTTON1 111
#define IDM_EXIT 104
#define IDM_ABOUT 300

//WINDOWS CRAP
static	HINSTANCE g_hInstance;
static  HWND   Form1;
static  HWND   Button1;
static  wchar_t  AppName[20];
static  PROPSHEETPAGE  psp[PS_PAGES];
static  PROPSHEETHEADER  psh;
static  HWND   hWndPropCtrl;
static  HWND   hWndPicture;
static  HWND   hWindow;
static  RECT   btmrect;
static  DWORD  width;
static  DWORD  height;

//Patchlist globals
static wstring g_PackageName=L"";
static wstring g_PackageVersion=L"";
static wstring g_PackageDate=L"";
static list<cGame> g_Game;
static cGame* g_CurrentGame;
static wchar_t szInputFileName[MAX_PATH] = { 0 }, szOutputFileName[MAX_PATH] = { 0 };

static wstring g_SourceIso;
static wstring g_TargetIso;


void ParsePatchFiles(pugi::xml_node PatchNode, cPatch *patch)
{
	for(pugi::xml_node child = PatchNode.child(L"FILE"); child; child = child.next_sibling(L"FILE"))
	{
		wstring FileType = child.attribute(L"type").as_string();
		wstring FileName = child.child_value();
		cPatchFile PatchFile(FileName, FileType);
		patch->AddPatchFile(PatchFile);
	}
}

void ParsePatchSearches(pugi::xml_node PatchNode, cPatch *patch)
{
	for(pugi::xml_node child = PatchNode.child(L"SEARCH"); child; child = child.next_sibling(L"SEARCH"))
	{
		wstring OldValue		= child.attribute(L"value").as_string();
		wstring NewValue		= child.attribute(L"replace").as_string();
		wstring CaseSensitive	= child.attribute(L"case").as_string();
		wstring VarQual			= child.attribute(L"varqual").as_string();
		cPatchSearch PatchSearch(OldValue, NewValue, VarQual, CaseSensitive);
		patch->AddPatchSearch(PatchSearch);
	}
}

void ParsePatchExclusions(pugi::xml_node PatchNode, cPatch *patch)
{
	for(pugi::xml_node child = PatchNode.child(L"EXCLUDES"); child; child = child.next_sibling(L"EXCLUDES"))
	{
		wstring PatchName = child.child_value();
		patch->AddExclusion(PatchName);
	}
}

void ParsePatchRequirements(pugi::xml_node PatchNode, cPatch *patch)
{
	for(pugi::xml_node child = PatchNode.child(L"REQUIRES"); child; child = child.next_sibling(L"REQUIRES"))
	{
		wstring PatchName = child.child_value();
		patch->AddRequirement(PatchName);
	}
}

void ParsePatchGame(pugi::xml_node GameNode, cGame *game)
{
	for(pugi::xml_node child = GameNode.first_child(); child; child = child.next_sibling())
	{
		wstring tagname = child.name();
		if(tagname != L"PATCH")
		{
			//THROW
			return;
		}
		wstring PatchName	= child.attribute(L"name").as_string();
		wstring PatchDesc	= child.attribute(L"description").as_string();
		wstring PatchActive	= child.attribute(L"active").as_string();
		cPatch patch(PatchName, PatchDesc, PatchActive);
		ParsePatchFiles(child, &patch);
		ParsePatchSearches(child, &patch);
		ParsePatchExclusions(child, &patch);
		ParsePatchRequirements(child, &patch);
		game->AddPatch(patch);
	}
}

void ParsePatchList(const wchar_t *pFileName)
{
	if(!pFileName) return;
	pugi::xml_document doc;
	pugi::xml_parse_result result = doc.load_file(pFileName);
	if(result.status != pugi::status_ok)
	{
		//throw
		return;
	}

	for(pugi::xml_node child = doc.first_child().first_child(); child; child = child.next_sibling())
	{
		wstring name = child.name();
		if(name == L"SHORTNAME") g_PackageName = child.child_value();
		else if(name == L"VERSION") g_PackageVersion = child.child_value();
		else if(name == L"DATE") g_PackageDate = child.child_value();
		else if(name == L"GAME")
		{
			wstring gamename	= child.attribute(L"name").as_string();
			wstring region		= child.attribute(L"region").as_string();
			wstring language	= child.attribute(L"language").as_string();
			wstring serial		= child.attribute(L"serial").as_string();
			wstring patchdir	= child.attribute(L"patchdir").as_string();
			cGame game(gamename, region, language, serial, patchdir);
			ParsePatchGame(child, &game);
			g_Game.push_back(game);
		}
	}

		//Now fill in the patch pointers in the exclusions and requirements.
	//This relies on lists not shuffling.
	list<cGame>::iterator iterGame;
	for(iterGame = g_Game.begin(); iterGame != g_Game.end(); iterGame++)
	{
		for(list<cPatch>::iterator CurrentPatch = iterGame->m_PatchList.begin(); CurrentPatch != iterGame->m_PatchList.end(); CurrentPatch++)
		{
			cPatchRefIterator iterRef;
			for(iterRef = CurrentPatch->m_Exclusion.begin(); iterRef != CurrentPatch->m_Exclusion.end(); iterRef++)
			{
				list<cPatch>::iterator TempPatch = iterGame->m_PatchList.begin();
				TempPatch = find_if(TempPatch, iterGame->m_PatchList.end(), std::bind2nd( PatchByName(), iterRef->m_PatchName ));
				if(TempPatch == iterGame->m_PatchList.end())
				{
					;
					//throw
				}
				else
				{
					iterRef->m_pPatch = &(*TempPatch);
				}
			}

			for(iterRef = CurrentPatch->m_Requirement.begin(); iterRef != CurrentPatch->m_Requirement.end(); iterRef++)
			{
				list<cPatch>::iterator TempPatch = iterGame->m_PatchList.begin();
				TempPatch = find_if(TempPatch, iterGame->m_PatchList.end(), std::bind2nd( PatchByName(), iterRef->m_PatchName ));
				if(TempPatch == iterGame->m_PatchList.end())
				{
					;
					//throw
				}
				else
				{
					iterRef->m_pPatch = &(*TempPatch);
				}
			}
		}
	}
}

HWND CreatePropSheet (HWND hWndParent);

void FormLoad (HWND hInst)
{
    Form1=CreateWindow(AppName,L"Main Window",WS_CAPTION|WS_SYSMENU|WS_MINIMIZEBOX|WS_POPUP,100,100,780,500,NULL,(HMENU)NULL,g_hInstance,NULL);
    //Button1=CreateWindowEx(0,L"button",L"Button1",WS_CHILD|WS_TABSTOP|BS_PUSHBUTTON|WS_VISIBLE,399,1,70,30,Form1,(HMENU)ID_BUTTON1,g_hInstance,NULL);
    hWndPicture=CreateWindowEx(0,L"static",L"",WS_CHILD|WS_VISIBLE,5,5,750,500,Form1,NULL,g_hInstance,NULL);

    GetWindowRect(hWndPicture,&btmrect);
    width=btmrect.right - btmrect.left;
    height=btmrect.bottom - btmrect.top;

    SendMessage(Button1,(UINT)WM_SETFONT,(WPARAM)GetStockObject(DEFAULT_GUI_FONT),(LPARAM)MAKELPARAM(FALSE,0));
    UpdateWindow(Form1);
    ShowWindow(Form1,SW_SHOWNORMAL);
    hWndPropCtrl=CreatePropSheet(Form1);

    SetParent(hWndPropCtrl,hWndPicture);
    SetWindowPos(hWndPropCtrl,NULL,-5,-25,width+15,height+40,SWP_NOZORDER|SWP_NOACTIVATE);
    SetWindowLong(hWndPropCtrl, GWL_STYLE,GetWindowLong(hWndPropCtrl,GWL_STYLE)|WS_CHILD);
    SetWindowLong(hWndPicture, GWL_EXSTYLE,GetWindowLong(hWndPicture,GWL_EXSTYLE)|WS_EX_CONTROLPARENT);
}

void InitOfn(OPENFILENAME *ofn, HWND hwnd, wchar_t *szFileName, wchar_t *szTitleName)
{
	static const wchar_t szFilter[] = \
		L"Supported Image Files (*.iso;*.bin;*.img)\0*.iso;*.bin;*.img\0" \
		L"ISO Files (*.iso)\0*.iso\0" \
		L"BIN Files (*.bin)\0*.bin\0" \
		L"IMG Files (*.img)\0*.img\0" \
		L"All Files (*.*)\0*.*\0" \
		L"\0";

	ofn->lStructSize	= sizeof(OPENFILENAME);
	ofn->hwndOwner		= hwnd;
	ofn->hInstance		= NULL;
	ofn->lpstrFilter	= szFilter;
	ofn->lpstrCustomFilter	= NULL;
	ofn->nMaxCustFilter	= 0;
	ofn->nFilterIndex	= 0;
	ofn->lpstrFile		= szFileName;
	ofn->nMaxFile		= MAX_PATH;
	ofn->lpstrFileTitle	= szTitleName;
	ofn->nMaxFileTitle	= MAX_PATH;
	ofn->lpstrInitialDir	= NULL;
	ofn->lpstrTitle		= NULL;
	ofn->Flags		= 0;
	ofn->nFileOffset	= 0;
	ofn->nFileExtension	= 0;
	ofn->lpstrDefExt	= L"txt";
	ofn->lCustData		= 0L;
	ofn->lpfnHook		= NULL;
	ofn->lpTemplateName	= NULL;
}

BOOL FileOpenDlg(OPENFILENAME *ofn)
{
     ofn->Flags = OFN_FILEMUSTEXIST | OFN_HIDEREADONLY | OFN_NOCHANGEDIR;

     return GetOpenFileName(ofn);
}

BOOL FileSaveDlg(OPENFILENAME *ofn)
{
     ofn->Flags = OFN_OVERWRITEPROMPT;

     return GetSaveFileName(ofn);
}

void LoadPatchesToListBoxes(HWND hWnd)
{
	HWND lboAvailable = GetDlgItem(hWnd, IDC_LIST_PATCH_AVAILABLE);
	HWND lboSelected = GetDlgItem(hWnd, IDC_LIST_PATCH_SELECTED);
	SendMessage(lboSelected, LB_RESETCONTENT, 0, 0);
	SendMessage(lboAvailable, LB_RESETCONTENT, 0, 0);
	list<cPatch>::iterator currpatch;
	for(currpatch = g_CurrentGame->m_PatchList.begin(); currpatch != g_CurrentGame->m_PatchList.end(); currpatch++)
	{
		LRESULT listidx;
		if(currpatch->m_Active)
		{
			listidx = SendMessage(lboSelected, LB_ADDSTRING, 0, reinterpret_cast<LPARAM>((LPWSTR)currpatch->m_Name.c_str()));
			SendMessage(lboSelected, LB_SETITEMDATA, (WPARAM)listidx, (LPARAM)&(*currpatch));
		}
		else
		{
			listidx = SendMessage(lboAvailable, LB_ADDSTRING, 0, reinterpret_cast<LPARAM>((LPWSTR)currpatch->m_Name.c_str()));
			SendMessage(lboAvailable, LB_SETITEMDATA, (WPARAM)listidx, (LPARAM)&(*currpatch));
		}
	}
}

void TogglePatchStatus (int SourceID, HWND hWnd)
{
	//Determine which controls should be acted upon initially.
	int TargetID	 = SourceID == IDC_LIST_PATCH_AVAILABLE ? IDC_LIST_PATCH_SELECTED : IDC_LIST_PATCH_AVAILABLE;
	int SourceDescID = SourceID == IDC_LIST_PATCH_AVAILABLE ? IDC_STATIC_DESC_AVAILABLE : IDC_STATIC_DESC_SELECTED;
	int TargetDescID = SourceID == IDC_LIST_PATCH_AVAILABLE ? IDC_STATIC_DESC_SELECTED : IDC_STATIC_DESC_AVAILABLE;
	HWND lboSource = GetDlgItem(hWnd, SourceID);
	HWND lboTarget = GetDlgItem(hWnd, TargetID);

	//Get patch acted upon.
	int idxSource = SendMessage(lboSource, LB_GETCURSEL, 0 , 0);
	if(idxSource == LB_ERR) return;

	//Save the selection in the other list, if any.
	int idxTarget = SendMessage(lboTarget, LB_GETCURSEL, 0 , 0);

	LRESULT pItem = SendMessage(lboSource, LB_GETITEMDATA, (WPARAM)idxSource, 0);
	if(pItem != LB_ERR)
	{
		//If there is a valid selection, toggle the patch status and clear the descriptions.
		((cPatch*)pItem)->m_Active ^= 1;
		SetDlgItemText(hWnd, SourceDescID, L"");
		SetDlgItemText(hWnd, TargetDescID, L"");

		//Activate required or deactivate excluded packages.
		for(cPatchRefIterator iterRef = ((cPatch*)pItem)->m_Requirement.begin(); iterRef != ((cPatch*)pItem)->m_Requirement.end(); iterRef++)
		{
			list<cPatch>::iterator TempPatch = g_CurrentGame->m_PatchList.begin();
			TempPatch = find_if(TempPatch, g_CurrentGame->m_PatchList.end(), std::bind2nd( PatchByName(), iterRef->m_PatchName ));
			if(TempPatch != g_CurrentGame->m_PatchList.end() && ((cPatch*)pItem)->m_Active) TempPatch->m_Active = 1;
		}

		for(cPatchRefIterator iterRef = ((cPatch*)pItem)->m_Exclusion.begin(); iterRef != ((cPatch*)pItem)->m_Exclusion.end(); iterRef++)
		{
			if(((cPatch*)pItem)->m_Active) iterRef->m_pPatch->m_Active = 0;
		}

		//Reload the lists.
		LoadPatchesToListBoxes(hWnd);
	}
}

void WriteAsciiFile(HANDLE hFile, wstring str)
{
	DWORD dwBytesWritten;
	int len = str.length();
	char *buf = new char[len + 3];
	wchar_t *tmp = new wchar_t[len + 3];
	swprintf(tmp, L"%s\r\n\0", str.c_str());
	WideCharToMultiByte(CP_ACP, 0, tmp, -1, buf, len + 3, NULL, FALSE);
	WriteFile(hFile, buf, len + 2 * sizeof(char), &dwBytesWritten, NULL);
	delete [] buf;
	delete [] tmp;
}

void WriteAsciiSearchFile(HANDLE hFile, cPatchSearch &search)
{
	DWORD dwBytesWritten;
	char *buf = new char[200];
	wchar_t *tmp = new wchar_t[200];
	int len = swprintf(tmp, L"patch_%s=true;\r\npatch_%s_type=\"%s\";\r\n\0"
				, search.m_VarQual.c_str()		//patch_<varqual>=true
				, search.m_VarQual.c_str()		//patch_<varqual>_type=
				, search.m_NewValue.c_str());	//<newvalue>
	WideCharToMultiByte(CP_ACP, 0, tmp, -1, buf, len + 1, NULL, FALSE);
	WriteFile(hFile, buf, len * sizeof(char), &dwBytesWritten, NULL);
	delete [] buf;
	delete [] tmp;
}

int ApplyPatch(HWND hwLog, HWND hwProgress, HWND hwStep)
{
	int ret = 0;
	wchar_t szModuleDir[MAX_PATH];
	GetModuleFileName(NULL, szModuleDir, MAX_PATH);
	PathRemoveFileSpec(szModuleDir);
	wstring strModuleDir = szModuleDir;
	wstring strPatchDir = strModuleDir + L"\\" + g_CurrentGame->m_PatchDir;

	wstring strFileName = strPatchDir + L"\\asm_patches.txt";
	HANDLE hAsm = CreateFile(strFileName.c_str(), GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, 0, NULL);
	strFileName = strPatchDir + L"\\bin_patches.txt";
	HANDLE hBin = CreateFile(strFileName.c_str(), GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, 0, NULL);
	strFileName = strPatchDir + L"\\patchreq.lua";
	HANDLE hSearch = CreateFile(strFileName.c_str(), GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, 0, NULL);

	SetWindowText(hwStep, L"Generating patch list...");
	for (cPatchIterator iterPatch = g_CurrentGame->m_PatchList.begin(); iterPatch != g_CurrentGame->m_PatchList.end(); iterPatch++)
	{
		if(iterPatch->m_Active)
		{
			for(cPatchFileIterator iterFile = iterPatch->m_PatchFile.begin(); iterFile != iterPatch->m_PatchFile.end(); iterFile++)
			{
				if(iterFile->m_Type == PFT_ASSEMBLY)
				{
					WriteAsciiFile(hAsm, iterFile->m_Name);
				}
				else if(iterFile->m_Type == PFT_BINARY)
				{
					WriteAsciiFile(hBin, iterFile->m_Name);
				}
			}
			for(cPatchSearchIterator iterSearch = iterPatch->m_PatchSearch.begin(); iterSearch != iterPatch->m_PatchSearch.end(); iterSearch++)
			{
				WriteAsciiSearchFile(hSearch, *iterSearch);
			}
		}
	}
	CloseHandle(hAsm);
	CloseHandle(hBin);
	CloseHandle(hSearch);
	SendMessage(hwProgress, PBM_SETPOS, 5, 0);

	SetWindowText(hwStep, L"Verifying disc image...");
	wstring strCmdLine = strPatchDir + L"\\disc_verify.bat \"" + szInputFileName + L"\"";
	ret = RunBatch(hwLog, strCmdLine, strPatchDir);
	if(ret)
	{
		AppendText(hwLog, L"\r\n\r\nFAILURE: Step 01 - \"Disc Verification\" failed.  Halting\r\n");
		return ret;
	}
	SendMessage(hwProgress, PBM_SETPOS, 12, 0);

	SetWindowText(hwStep, L"Extracting data from disc...");
	strCmdLine = strPatchDir + L"\\disc_extract.bat \"" + szInputFileName + L"\"";
	ret = RunBatch(hwLog, strCmdLine, strPatchDir);
	if(ret)
	{
		AppendText(hwLog, L"\r\n\r\nFAILURE: Step 02 - \"Disc Extraction\" failed.  Halting\r\n");
		return ret;
	}
	SendMessage(hwProgress, PBM_SETPOS, 30, 0);

	SetWindowText(hwStep, L"Applying selected patches (.asm)...");
	strCmdLine = strPatchDir + L"\\patch_asm.bat";
	ret = RunBatch(hwLog, strCmdLine, strPatchDir);
	if(ret)
	{
		AppendText(hwLog, L"\r\n\r\nFAILURE: Step 03 - \"Apply ASM Patches\" failed.  Halting\r\n");
		return ret;
	}
	SendMessage(hwProgress, PBM_SETPOS, 50, 0);

	SetWindowText(hwStep, L"Applying selected patches (.bin)...");
	strCmdLine = strPatchDir + L"\\patch_bin.bat";
	ret = RunBatch(hwLog, strCmdLine, strPatchDir);
	if(ret)
	{
		AppendText(hwLog, L"\r\n\r\nFAILURE: Step 04 - \"Apply BIN Patches\" failed.  Halting\r\n");
		return ret;
	}
	SendMessage(hwProgress, PBM_SETPOS, 60, 0);

	SetWindowText(hwStep, L"Applying search patches and rebuilding disc...");
	strCmdLine = strPatchDir + L"\\disc_rebuild.bat \"" + szInputFileName + L"\" \"" + szOutputFileName + L"\"";
	ret = RunBatch(hwLog, strCmdLine, strPatchDir);
	if(ret)
	{
		AppendText(hwLog, L"\r\n\r\nFAILURE: Step 04 - \"Apply BIN Patches\" failed.  Halting\r\n");
		return ret;
	}
	SendMessage(hwProgress, PBM_SETPOS, 100, 0);

	SetWindowText(hwStep, L"Patch process completed.");

	return ret;
}

void CheckApplyPatch(HWND hWnd)
{
	HWND lboSelected = GetDlgItem(hWnd, IDC_LIST_PATCH_SELECTED);
	HWND btnApply = GetDlgItem(hWnd, IDC_BUTTON_APPLY);
	int count = SendMessage(lboSelected, LB_GETCOUNT, 0, 0);
	int lin   = wcslen(szInputFileName);
	int lout  = wcslen(szOutputFileName);

	if(count > 0 && lin > 0 && lout > 0)
	{
		EnableWindow(btnApply, true);
	}
	else
	{
		EnableWindow(btnApply, false);
	}
}

LRESULT CALLBACK PropSheetSetupProc (HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam)
{
	HWND cboPatchVersion;
	list<cGame>::iterator iterGame;
	static wchar_t szTitleName[MAX_PATH];

    switch(Msg)
    {
        case WM_INITDIALOG:
        {
        	cboPatchVersion = GetDlgItem(hWnd, IDC_COMBO_PATCH_VERSION);
        	for(iterGame = g_Game.begin(); iterGame != g_Game.end(); iterGame++)
        	{
				wstring tmp = iterGame->m_Name + L" - " + iterGame->m_Region + L"(" + iterGame->m_Language + L")";
				SendMessage(cboPatchVersion, CB_ADDSTRING, 0, reinterpret_cast<LPARAM>((LPWSTR)tmp.c_str()));
			}

			HFONT hFont=CreateFont (12, 0, 0, 0, FW_DONTCARE, FALSE, FALSE, FALSE, ANSI_CHARSET,
				OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY,
				DEFAULT_PITCH | FF_SWISS, L"Arial");
			SendDlgItemMessage(hWnd, IDC_STATIC_DESC_AVAILABLE, WM_SETFONT, (WPARAM)hFont,FALSE);
			SendDlgItemMessage(hWnd, IDC_STATIC_DESC_SELECTED, WM_SETFONT, (WPARAM)hFont,FALSE);

            return 1;
		}
        case WM_NOTIFY:
            switch(((LPNMHDR)lParam)->code)
            {
                case PSN_SETACTIVE:
                    break;
                case PSN_RESET:
                    break;
                case PSN_QUERYCANCEL:
                    break;
                case PSN_KILLACTIVE:
                    break;
            }
            break;
        case WM_COMMAND:
        {
        	switch(LOWORD(wParam))
        	{
				case IDC_COMBO_PATCH_VERSION:
				{
					switch(HIWORD(wParam))
					{
						case CBN_SELCHANGE:
						{
							cboPatchVersion = GetDlgItem(hWnd, IDC_COMBO_PATCH_VERSION);
							LRESULT idx = SendMessage(cboPatchVersion, CB_GETCURSEL, 0, 0);
							g_CurrentGame = NULL;
							int count = 0;
							for(iterGame = g_Game.begin(); iterGame != g_Game.end(); iterGame++)
							{
								if(count == idx) {
									g_CurrentGame = &(*iterGame);
									break;
								}
								count++;
							}

							if(idx != CB_ERR && g_CurrentGame)
							{
								LoadPatchesToListBoxes(hWnd);
							}

							CheckApplyPatch(hWnd);

							break;
						}
					}
					break;
				}

				case IDC_LIST_PATCH_AVAILABLE:
				{
					switch(HIWORD(wParam))
					{
						case LBN_SELCHANGE:
						{
							HWND lboAvailable = GetDlgItem(hWnd, IDC_LIST_PATCH_AVAILABLE);
							SetDlgItemText(hWnd, IDC_STATIC_DESC_AVAILABLE, L"");
							int idx;
							idx = SendMessage(lboAvailable, LB_GETCURSEL, 0 , 0);
							LRESULT pItem = SendMessage(lboAvailable, LB_GETITEMDATA, (WPARAM)idx, 0);
							if(pItem != LB_ERR)
							{
								wstring desc = ((cPatch*)pItem)->m_Description.c_str();
								int countEx = 0;
								for (cPatchRefIterator iterRef = ((cPatch*)pItem)->m_Exclusion.begin();
										iterRef != ((cPatch*)pItem)->m_Exclusion.end(); iterRef++)
								{
									if(countEx)
										desc += L", ";
									else
										desc += L"\r\n\r\nExcludes: ";
									desc += iterRef->m_PatchName;
									countEx++;
								}

								int countReq = 0;
								for (cPatchRefIterator iterRef = ((cPatch*)pItem)->m_Requirement.begin();
										iterRef != ((cPatch*)pItem)->m_Requirement.end(); iterRef++)
								{
									if(countEx) desc += L"\r\n";
									if(countReq)
										desc += L", ";
									else
										desc += L"\r\nRequires: ";
									desc += iterRef->m_PatchName;
									countEx++;
								}

								SetDlgItemText(hWnd, IDC_STATIC_DESC_AVAILABLE, desc.c_str());

							}

							break;
						}
					}

					break;
				}

				case IDC_LIST_PATCH_SELECTED:
				{
					switch(HIWORD(wParam))
										{
						case LBN_SELCHANGE:
						{
							HWND lboSelected = GetDlgItem(hWnd, IDC_LIST_PATCH_SELECTED);
							SetDlgItemText(hWnd, IDC_STATIC_DESC_SELECTED, L"");
							int idx;
							idx = SendMessage(lboSelected, LB_GETCURSEL, 0 , 0);
							LRESULT pItem = SendMessage(lboSelected, LB_GETITEMDATA, (WPARAM)idx, 0);
							if(pItem != LB_ERR)
							{
								wstring desc = ((cPatch*)pItem)->m_Description.c_str();
								int countEx = 0;
								for (cPatchRefIterator iterRef = ((cPatch*)pItem)->m_Exclusion.begin();
										iterRef != ((cPatch*)pItem)->m_Exclusion.end(); iterRef++)
								{
									if(countEx)
										desc += L", ";
									else
										desc += L"\r\n\r\nExcludes: ";
									desc += iterRef->m_PatchName;
									countEx++;
								}

								int countReq = 0;
								for (cPatchRefIterator iterRef = ((cPatch*)pItem)->m_Requirement.begin();
										iterRef != ((cPatch*)pItem)->m_Requirement.end(); iterRef++)
								{
									if(countEx) desc += L"\r\n";
									if(countReq)
										desc += L", ";
									else
										desc += L"\r\nRequires: ";
									desc += iterRef->m_PatchName;
									countEx++;
								}

								SetDlgItemText(hWnd, IDC_STATIC_DESC_SELECTED, desc.c_str());

							}

							break;
						}
					}

					break;
				}

				case IDC_BUTTON_PATCH_SELECT:
				{
					TogglePatchStatus(IDC_LIST_PATCH_AVAILABLE, hWnd);
					CheckApplyPatch(hWnd);
					break;
				}

				case IDC_BUTTON_PATCH_DESELECT:
				{
					TogglePatchStatus(IDC_LIST_PATCH_SELECTED, hWnd);
					CheckApplyPatch(hWnd);
					break;
				}

				case IDC_BUTTON_BROWSE_INPUT:
				{
					OPENFILENAME ofn;
					InitOfn(&ofn, hWnd, szInputFileName, szTitleName);
					if(FileOpenDlg(&ofn))
					{
						if(wcscmp(szOutputFileName, szInputFileName))
							SetDlgItemText(hWnd, IDC_EDIT_INPUT, szInputFileName);
						else
						{
							if(wcslen(szInputFileName) > 0)
							{
								MessageBox(hWnd, L"The patched file (output) cannot be the original disc image.", L"Input Error", MB_OK);
								ZeroMemory(szInputFileName, MAX_PATH * sizeof(wchar_t));
							}
							SetDlgItemText(hWnd, IDC_EDIT_INPUT, L"");
						}
					}

					CheckApplyPatch(hWnd);

					break;
				}

				case IDC_BUTTON_BROWSE_OUTPUT:
				{
					OPENFILENAME ofn;
					InitOfn(&ofn, hWnd, szOutputFileName, szTitleName);
					if (FileSaveDlg(&ofn))
					{
						if(wcscmp(szOutputFileName, szInputFileName))
							SetDlgItemText(hWnd, IDC_EDIT_OUTPUT, szOutputFileName);
						else
						{
							if(wcslen(szOutputFileName) > 0)
							{
								MessageBox(hWnd, L"The patched file (output) cannot be the original disc image.", L"Output Error", MB_OK);
								ZeroMemory(szOutputFileName, MAX_PATH * sizeof(wchar_t));
							}
							SetDlgItemText(hWnd, IDC_EDIT_OUTPUT, L"");
						}

					}

					CheckApplyPatch(hWnd);

					break;
				}

				case IDC_BUTTON_APPLY:
				{
					SendMessage(hWndPropCtrl, PSM_SETCURSEL, (WPARAM)1, 0);
					break;
				}

				case IDC_BUTTON_BACK:
				{
					SendMessage(hWndPropCtrl, PSM_SETCURSEL, (WPARAM)0, 0);
					break;
				}
			}
            break;
		}
    }
    return DefWindowProc(hWnd,Msg,wParam,lParam);
}

LRESULT CALLBACK PropSheetInstallProc (HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam)
{
	switch(Msg)
	{
		case WM_INITDIALOG:
		{
			HWND hwEdit = GetDlgItem(hWnd, IDC_EDIT_LOG);
			SendMessage(hwEdit, EM_SETLIMITTEXT, (WPARAM)(1024 * 1024 * 8), 0);
			SetTimer(hWnd, IDT_DLG_TIMER, 100, (TIMERPROC) NULL);
			return 1;
		}
		case WM_NOTIFY:
			switch(((LPNMHDR)lParam)->code)
			{
				case PSN_SETACTIVE:
					break;
				case PSN_RESET:
					break;
				case PSN_QUERYCANCEL:
					break;
				case PSN_KILLACTIVE:
					break;
			}
			break;
		case WM_COMMAND:
		{
			switch(LOWORD(wParam))
			{
				case ID_MY_MESSAGE:
				{
					HWND hwLog = GetDlgItem(hWnd, IDC_EDIT_LOG);
					HWND hwProgress = GetDlgItem(hWnd, IDC_PROGRESS);
					HWND hwStep = GetDlgItem(hWnd, IDC_STATIC_PROGRESS);
					ApplyPatch(hwLog, hwProgress, hwStep);
					HWND btnDone = GetDlgItem(hWnd, IDC_BUTTON_DONE);
					EnableWindow(btnDone, true);

					break;
				}
				case IDC_BUTTON_DONE:
				{
					PostQuitMessage(0);
					break;
				}
			}
			break;
		}
		case WM_TIMER:
		{
			switch(wParam)
			{
				case IDT_DLG_TIMER:
				{
					PostMessage(hWnd, WM_COMMAND, MAKEWPARAM(ID_MY_MESSAGE, 0), 0);
					KillTimer(hWnd, IDT_DLG_TIMER);
					return 0;
				}
			}
		}
	}
    return DefWindowProc(hWnd,Msg,wParam,lParam);
}

HWND CreatePropSheet (HWND hWndParent)
{
    psp[0].dwSize=sizeof(PROPSHEETPAGE);
    psp[0].dwFlags=0;
    psp[0].hInstance=g_hInstance;
    psp[0].pszTemplate=MAKEINTRESOURCE(IDD_PROPPAGE_SETUP);
    psp[0].pfnDlgProc=(DLGPROC)PropSheetSetupProc;
    psp[0].pszTitle=L"Setup Patch";
    psp[0].lParam=0;
    psp[0].pfnCallback=NULL;

    psp[1].dwSize=sizeof(PROPSHEETPAGE);
    psp[1].dwFlags=PSP_USETITLE;
    psp[1].hInstance=g_hInstance;
    psp[1].pszTemplate=MAKEINTRESOURCE(IDD_PROPPAGE_INSTALL);
    psp[1].pfnDlgProc=(DLGPROC)PropSheetInstallProc;
    psp[1].pszTitle=L"Install Patch";
    psp[1].lParam=0;
    psp[1].pfnCallback=NULL;

    psh.dwSize=sizeof(PROPSHEETHEADER);
    psh.dwFlags=PSH_PROPSHEETPAGE|PSH_NOAPPLYNOW|PSH_MODELESS|PSH_WIZARD;
    psh.hwndParent=Form1;
    psh.hInstance=g_hInstance;
    psh.pszIcon=NULL;
    psh.pszCaption=NULL;
    psh.nPages=sizeof(psp)/sizeof(PROPSHEETPAGE);
    psh.nStartPage=0;
    psh.ppsp=(LPCPROPSHEETPAGE)&psp;
    psh.pfnCallback=NULL;


    return (HWND)PropertySheet(&psh);
}

LRESULT CALLBACK WndProc (HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam)
{
    switch(Msg)
    {
		case WM_CREATE:
		{
			/*INITCOMMONCONTROLSEX InitCtrlEx;

			InitCtrlEx.dwSize = sizeof(INITCOMMONCONTROLSEX);
			InitCtrlEx.dwICC  = ICC_PROGRESS_CLASS;
			InitCommonControlsEx(&InitCtrlEx);*/

			ParsePatchList(L"patchlist.xml");

			break;
		}
        case WM_COMMAND:
            switch(LOWORD(wParam))
            {
                case ID_BUTTON1:
                    break;
                case IDM_EXIT:
                    PostQuitMessage(0);
                    break;
            }
        case WM_DESTROY:
            PostQuitMessage(0);
            return 0;
    }
    return DefWindowProc(hWnd,Msg,wParam,lParam);
}

int WINAPI WinMain (HINSTANCE hInst, HINSTANCE hPrev, LPSTR CmdLine, int CmdShow)
{
    static  MSG  Msg;
    memset(&Msg,0,sizeof(Msg));
    static  WNDCLASS  wc;
    memset(&wc,0,sizeof(wc));
    g_hInstance=hInst;
    wcscpy(AppName,L"Patcher");
    wc.style=0;
    wc.lpfnWndProc=WndProc;
    wc.cbClsExtra=0;
    wc.cbWndExtra=0;
    wc.hInstance=hInst;
    wc.hIcon=LoadIcon(NULL,IDI_WINLOGO);
    wc.hCursor=LoadCursor(NULL,IDC_ARROW);
    wc.hbrBackground=GetSysColorBrush(COLOR_BTNFACE);
    wc.lpszClassName=AppName;
    RegisterClass(&wc);
    FormLoad(hWindow);
    wstring Title = g_PackageName + L" v" + g_PackageVersion + L" - " + g_PackageDate;
	SetWindowText(Form1, Title.c_str());
    while(GetMessage(&Msg,NULL,0,0))
    {
        if(!IsDialogMessage(Form1,&Msg))
        {
            if(!PropSheet_IsDialogMessage(hWndPropCtrl,&Msg))
            {
                TranslateMessage(&Msg);
                DispatchMessage(&Msg);
            }
        }
    }
    return Msg.wParam;
}

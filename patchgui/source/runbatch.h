#ifndef __RUNBATCH_H__
#define __RUNBATCH_H__

#ifndef UNICODE
#define UNICODE
#endif

#include "windows.h"
#include <string>
using namespace std;

#define BUFSIZE 4096

void AppendText(HWND hWnd, wstring text);
int CreateChildProcess(wstring strCmdLine, wstring strCurrDir);
void ReadFromPipe(HWND hWnd);
int RunBatch(HWND hWnd, wstring strCmdLine, wstring strCurrDir);


#endif //__RUNBATCH_H__
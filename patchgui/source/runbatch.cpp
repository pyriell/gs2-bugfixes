/*
 * runbatch.cpp -- Handle batch calls to patch tools.
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

#include "runbatch.h"

//Global process info.  Reused in batch calls.
PROCESS_INFORMATION piProcInfo;

//Handles for stdout/stderr
HANDLE g_hChildStd_OUT_Rd = NULL;
HANDLE g_hChildStd_OUT_Wr = NULL;

// Create a child process that uses the previously created pipes for STDIN and STDOUT.
int CreateChildProcess(wstring strCmdLine, wstring strCurrDir)
{
	int bufsize = (strCmdLine.length() + 1) * sizeof(TCHAR);
	TCHAR *szCmdline = new TCHAR[bufsize];
	wcscpy(szCmdline, strCmdLine.c_str());
	bufsize = (strCurrDir.length() + 1) * sizeof(TCHAR);
	TCHAR *szCurrDir = new TCHAR[bufsize];
	wcscpy(szCurrDir, strCurrDir.c_str());
	STARTUPINFO siStartInfo;
	BOOL bSuccess = FALSE;

	// Set up members of the PROCESS_INFORMATION structure.
 	ZeroMemory( &piProcInfo, sizeof(PROCESS_INFORMATION) );

	// Set up members of the STARTUPINFO structure.
	// This structure specifies the STDIN and STDOUT handles for redirection.
	ZeroMemory( &siStartInfo, sizeof(STARTUPINFO) );
	siStartInfo.cb = sizeof(STARTUPINFO);
	siStartInfo.hStdError = g_hChildStd_OUT_Wr;
	siStartInfo.hStdOutput = g_hChildStd_OUT_Wr;
	siStartInfo.hStdInput = GetStdHandle(STD_INPUT_HANDLE);
	siStartInfo.wShowWindow |= SW_HIDE;
	siStartInfo.dwFlags |= STARTF_USESTDHANDLES|STARTF_USESHOWWINDOW;

	// Create the child process.
    bSuccess = CreateProcess(NULL,
		szCmdline,     // command line
		NULL,          // process security attributes
		NULL,          // primary thread security attributes
		TRUE,          // handles are inherited
		0,             // creation flags
		NULL,          // use parent's environment
		szCurrDir,     // use parent's current directory
		&siStartInfo,  // STARTUPINFO pointer
		&piProcInfo);  // receives PROCESS_INFORMATION

	delete szCurrDir;
	delete szCmdline;
	// If an error occurs, exit the application.
	if ( ! bSuccess )
	{
		DWORD error = GetLastError();
		return error;
	}
	return 0;
}

void ReadFromPipe(HWND hWnd)
{
	DWORD dwRead;
	CHAR chBuf[BUFSIZE+1];
	wchar_t wBuf[BUFSIZE+1];
	BOOL bSuccess = FALSE;

	for (;;)
	{
		ZeroMemory(chBuf, sizeof(CHAR) * (BUFSIZE + 1));
		ZeroMemory(wBuf, sizeof(wchar_t) * (BUFSIZE + 1));
		bSuccess = ReadFile( g_hChildStd_OUT_Rd, chBuf, BUFSIZE, &dwRead, NULL);
		if( ! bSuccess || dwRead < 1 ) break;

		MultiByteToWideChar(CP_UTF8, 0, chBuf, dwRead, wBuf, BUFSIZE);
		int len = GetWindowTextLength(hWnd);
		SendMessage(hWnd, EM_SETSEL, (WPARAM)len, (LPARAM)len);
		SendMessage(hWnd, EM_REPLACESEL, 0, (LPARAM)wBuf);
	}
}

void AppendText(HWND hWnd, wstring text)
{
	int len = GetWindowTextLength(hWnd);
	SendMessage(hWnd, EM_SETSEL, (WPARAM)len, (LPARAM)len);
	SendMessage(hWnd, EM_REPLACESEL, 0, (LPARAM)text.c_str());
}

int RunBatch(HWND hWnd, wstring strCmdLine, wstring strCurrDir)
{
	DWORD ExitCode;
	SECURITY_ATTRIBUTES saAttr;

	// Set the bInheritHandle flag so pipe handles are inherited.
	saAttr.nLength = sizeof(SECURITY_ATTRIBUTES);
	saAttr.bInheritHandle = TRUE;
	saAttr.lpSecurityDescriptor = NULL;

	// Create a pipe for the child process's STDOUT.
 	if ( ! CreatePipe(&g_hChildStd_OUT_Rd, &g_hChildStd_OUT_Wr, &saAttr, 0) )
	{
		DWORD error = GetLastError();
		return error;
	}
	// Ensure the read handle to the pipe for STDOUT is not inherited.
	if ( ! SetHandleInformation(g_hChildStd_OUT_Rd, HANDLE_FLAG_INHERIT, 0) )
	{
		DWORD error = GetLastError();
		return error;
	}
	CreateChildProcess(strCmdLine, strCurrDir);
	CloseHandle(g_hChildStd_OUT_Wr);
	ReadFromPipe(hWnd);
	WaitForSingleObject(piProcInfo.hProcess, INFINITE);
	BOOL result = GetExitCodeProcess(piProcInfo.hProcess, &ExitCode);
	if(!result)
	{
		int len = GetWindowTextLength(hWnd);
		SendMessage(hWnd, EM_SETSEL, (WPARAM)len, (LPARAM)len);
		wstring message = L"\r\n\r\n" + strCmdLine + L" -- Unable to get exit code, assuming success.";
		SendMessage(hWnd, EM_REPLACESEL, 0, (LPARAM)message.c_str());
	}
	else
	{
		wchar_t message[100] = { 0 };
		wsprintf(message, L"\r\nBatch process exited with code %X\r\n\r\n", ExitCode);
		int len = GetWindowTextLength(hWnd);
		SendMessage(hWnd, EM_SETSEL, (WPARAM)len, (LPARAM)len);
		SendMessage(hWnd, EM_REPLACESEL, 0, (LPARAM)message);
	}
	CloseHandle(g_hChildStd_OUT_Rd);
	CloseHandle(piProcInfo.hProcess);
	CloseHandle(piProcInfo.hThread);
	return ExitCode;
}

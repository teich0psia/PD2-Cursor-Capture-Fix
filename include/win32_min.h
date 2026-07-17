#ifndef PD2CCF_WIN32_MIN_H
#define PD2CCF_WIN32_MIN_H

#ifndef __declspec
#define __declspec(x)
#endif

#ifndef NULL
#define NULL ((void *)0)
#endif

#define WINAPI __stdcall
#define CALLBACK __stdcall
#define TRUE 1
#define FALSE 0
#define DLL_PROCESS_ATTACH 1
#define GW_OWNER 4

typedef int BOOL;
typedef unsigned long DWORD;
typedef long LONG;
typedef unsigned int UINT;
typedef long LPARAM;
typedef void *LPVOID;
typedef void *HANDLE;
typedef void *HWND;
typedef void *HINSTANCE;
typedef unsigned short WCHAR;
typedef WCHAR wchar_t;

typedef struct tagPOINT {
    LONG x;
    LONG y;
} POINT;

typedef struct tagRECT {
    LONG left;
    LONG top;
    LONG right;
    LONG bottom;
} RECT;

typedef DWORD (WINAPI *LPTHREAD_START_ROUTINE)(LPVOID);
typedef BOOL (CALLBACK *WNDENUMPROC)(HWND, LPARAM);

__declspec(dllimport) HANDLE WINAPI CreateThread(LPVOID, unsigned long, LPTHREAD_START_ROUTINE, LPVOID, DWORD, DWORD *);
__declspec(dllimport) BOOL WINAPI CloseHandle(HANDLE);
__declspec(dllimport) void WINAPI Sleep(DWORD);
__declspec(dllimport) DWORD WINAPI GetCurrentProcessId(void);
__declspec(dllimport) LONG WINAPI InterlockedCompareExchange(volatile LONG *, LONG, LONG);
__declspec(dllimport) LONG WINAPI InterlockedExchange(volatile LONG *, LONG);
__declspec(dllimport) BOOL WINAPI DisableThreadLibraryCalls(HINSTANCE);

__declspec(dllimport) BOOL WINAPI EnumWindows(WNDENUMPROC, LPARAM);
__declspec(dllimport) BOOL WINAPI IsWindowVisible(HWND);
__declspec(dllimport) HWND WINAPI GetWindow(HWND, UINT);
__declspec(dllimport) DWORD WINAPI GetWindowThreadProcessId(HWND, DWORD *);
__declspec(dllimport) int WINAPI GetClassNameW(HWND, WCHAR *, int);
__declspec(dllimport) BOOL WINAPI GetClientRect(HWND, RECT *);
__declspec(dllimport) BOOL WINAPI ClientToScreen(HWND, POINT *);
__declspec(dllimport) BOOL WINAPI IsWindow(HWND);
__declspec(dllimport) BOOL WINAPI IsIconic(HWND);
__declspec(dllimport) HWND WINAPI GetForegroundWindow(void);
__declspec(dllimport) BOOL WINAPI GetClipCursor(RECT *);
__declspec(dllimport) BOOL WINAPI ClipCursor(const RECT *);

#endif

#include <stdint.h>
#include <stdbool.h>
#include "win32_min.h"

#include "cursor_policy.h"

typedef struct lua_State lua_State;
typedef void *(*get_exposed_func_t)(const char *name);
typedef void (*pd2_log_t)(const char *message, int level, const char *file, int line);

__declspec(dllexport) const char *MODULE_LICENCE_DECLARATION =
    "This module is licenced under the GNU GPL version 2 or later, or another compatible licence";
__declspec(dllexport) const char *MODULE_SOURCE_CODE_LOCATION =
    "https://github.com/teich0psia/PD2-Cursor-Capture-Fix";
__declspec(dllexport) const char *MODULE_SOURCE_CODE_REVISION = "0.1.1";
__declspec(dllexport) uint64_t SBLT_API_REVISION = 1;

static volatile LONG g_worker_started = 0;
static DWORD g_process_id = 0;
static HWND g_game_window = NULL;
static pd2_log_t g_pd2_log = NULL;

static bool g_owns_clip = false;
static bool g_last_rect_valid = false;
static pd2ccf_rect g_last_rect = {0, 0, 0, 0};

static void log_line(const char *message, int level, int line)
{
    if (g_pd2_log) {
        g_pd2_log(message, level, __FILE__, line);
    }
}

static bool wide_equals(const wchar_t *a, const wchar_t *b)
{
    while (*a && *b && *a == *b) {
        ++a;
        ++b;
    }
    return *a == *b;
}

static BOOL CALLBACK enum_windows_proc(HWND hwnd, LPARAM lparam)
{
    DWORD pid = 0;
    wchar_t class_name[64];
    RECT client;
    POINT tl;
    POINT br;

    (void)lparam;
    if (!IsWindowVisible(hwnd) || GetWindow(hwnd, GW_OWNER) != NULL) {
        return TRUE;
    }
    GetWindowThreadProcessId(hwnd, &pid);
    if (pid != g_process_id) {
        return TRUE;
    }
    class_name[0] = L'\0';
    if (GetClassNameW(hwnd, class_name, (int)(64)) <= 0) {
        return TRUE;
    }
    if (!wide_equals(class_name, L"diesel win32")) {
        return TRUE;
    }
    if (!GetClientRect(hwnd, &client)) {
        return TRUE;
    }
    tl.x = client.left;
    tl.y = client.top;
    br.x = client.right;
    br.y = client.bottom;
    if (!ClientToScreen(hwnd, &tl) || !ClientToScreen(hwnd, &br)) {
        return TRUE;
    }
    if (br.x <= tl.x || br.y <= tl.y) {
        return TRUE;
    }
    g_game_window = hwnd;
    return FALSE;
}

static HWND find_game_window(void)
{
    g_game_window = NULL;
    EnumWindows(enum_windows_proc, 0);
    return g_game_window;
}

static bool get_client_screen_rect(HWND hwnd, pd2ccf_rect *out)
{
    RECT r;
    POINT tl;
    POINT br;

    if (!hwnd || !out || !GetClientRect(hwnd, &r)) {
        return false;
    }
    tl.x = r.left;
    tl.y = r.top;
    br.x = r.right;
    br.y = r.bottom;
    if (!ClientToScreen(hwnd, &tl) || !ClientToScreen(hwnd, &br)) {
        return false;
    }
    if (br.x <= tl.x || br.y <= tl.y) {
        return false;
    }
    out->left = tl.x;
    out->top = tl.y;
    out->right = br.x;
    out->bottom = br.y;
    return true;
}

static bool is_payday_foreground(void)
{
    HWND fg = GetForegroundWindow();
    DWORD pid = 0;
    if (!fg) {
        return false;
    }
    GetWindowThreadProcessId(fg, &pid);
    return pid == g_process_id;
}

static void clear_ownership(void)
{
    g_owns_clip = false;
    g_last_rect_valid = false;
}

static void update_capture(void)
{
    pd2ccf_rect desired;
    pd2ccf_rect current;
    RECT win_current;
    bool desired_valid;
    bool current_valid;
    bool active;
    pd2ccf_release_action action;

    if (!g_game_window || !IsWindow(g_game_window)) {
        g_game_window = find_game_window();
    }

    active = g_game_window && !IsIconic(g_game_window) && is_payday_foreground();
    desired_valid = active && get_client_screen_rect(g_game_window, &desired);
    current_valid = GetClipCursor(&win_current) != 0;
    if (current_valid) {
        current.left = win_current.left;
        current.top = win_current.top;
        current.right = win_current.right;
        current.bottom = win_current.bottom;
    }

    if (active && desired_valid) {
        if (pd2ccf_should_apply(true, true, &desired, current_valid, &current)) {
            RECT target;
            target.left = desired.left;
            target.top = desired.top;
            target.right = desired.right;
            target.bottom = desired.bottom;
            if (ClipCursor(&target)) {
                g_owns_clip = true;
                g_last_rect_valid = true;
                g_last_rect = desired;
            }
        }
        return;
    }

    action = pd2ccf_choose_release(g_owns_clip, g_last_rect_valid, &g_last_rect,
                                   current_valid, &current);
    if (action == PD2CCF_RELEASE_CALL) {
        if (ClipCursor(NULL)) {
            clear_ownership();
        }
    } else if (action == PD2CCF_RELEASE_DROP_OWNERSHIP) {
        clear_ownership();
    }
}

static DWORD WINAPI worker_main(LPVOID unused)
{
    (void)unused;
    log_line("PD2 Cursor Capture Fix worker started", 1, __LINE__);
    for (;;) {
        update_capture();
        Sleep(10);
    }
}

__declspec(dllexport) void SuperBLT_Plugin_Setup(get_exposed_func_t get_exposed_function)
{
    HANDLE thread;
    if (get_exposed_function) {
        g_pd2_log = (pd2_log_t)get_exposed_function("pd2_log");
    }
    g_process_id = GetCurrentProcessId();
    if (InterlockedCompareExchange(&g_worker_started, 1, 0) != 0) {
        return;
    }
    thread = CreateThread(NULL, 0, worker_main, NULL, 0, NULL);
    if (!thread) {
        InterlockedExchange(&g_worker_started, 0);
        log_line("PD2 Cursor Capture Fix failed to start worker", 4, __LINE__);
        return;
    }
    CloseHandle(thread);
}

__declspec(dllexport) void SuperBLT_Plugin_Init_State(lua_State *L)
{
    (void)L;
}

__declspec(dllexport) int SuperBLT_Plugin_PushLua(lua_State *L)
{
    (void)L;
    return 0;
}

__declspec(dllexport) void SuperBLT_Plugin_Update(lua_State *L)
{
    (void)L;
}

BOOL WINAPI DllMain(HINSTANCE instance, DWORD reason, LPVOID reserved)
{
    (void)reserved;
    if (reason == DLL_PROCESS_ATTACH) {
        DisableThreadLibraryCalls(instance);
    }
    return TRUE;
}

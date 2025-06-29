Its nice to not have fly away window snapping in Windows when using GlazeWM.

```
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v EnableSnapAssistFlyout /t REG_DWORD /d 0 /f
```

After doing that, the drop down tab goes away but the system may still want to snap windows. The most reliable way seems to be to use the GUI:

```
Settings -> System -> Multitasking -> Disable Snap windows.
```

In theory, the following commands _should_ work, but I couldn't get it to work without the GUI.

```
reg add "HKCU\Control Panel\Desktop" /v WindowArrangementActive /t REG_SZ /d "0" /f

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v SnapAssist /t REG_DWORD /d 0 /f

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v SnapFill /t REG_DWORD /d 0 /f

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v EnableSnapBar /t REG_DWORD /d 0 /f

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v EnableSnapAssistFlyout /t REG_DWORD /d 0 /f

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v DITest /t REG_DWORD /d 0 /f
```

- Restart Explorer: `taskkill /f /im explorer.exe && start explorer.exe`

New Windows 11 context menu is dumb.

```
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve
```



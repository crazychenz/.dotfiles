Its nice to not have fly away window snapping in Windows when using GlazeWM.

```
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v EnableSnapAssistFlyout /t REG_DWORD /d 0 /f
```

- Restart `explorer.exe`

New Windows 11 context menu is dumb.

```
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve
```


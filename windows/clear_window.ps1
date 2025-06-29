# Note: This was all written by claude.ai and hasn't been closely reviewed.

# Intended to create gaps in Windows window managers (GlazeWM, Whim, etc). Gaps are useful
# for workspaces that have less windows and you don't want to full screen or half screen you
# spotify or whats app.

# Use with a shortcut: `powershell.exe -STA -WindowStyle Hidden -ExecutionPolicy Bypass -File C:\bin\clear_window.ps1`

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Add Win32 API declarations for window manipulation
Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    
    public class Win32 {
        [DllImport("user32.dll")]
        public static extern int SetWindowLong(IntPtr hWnd, int nIndex, int dwNewLong);
        
        [DllImport("user32.dll")]
        public static extern int GetWindowLong(IntPtr hWnd, int nIndex);
        
        [DllImport("user32.dll")]
        public static extern bool SetLayeredWindowAttributes(IntPtr hwnd, uint crKey, byte bAlpha, uint dwFlags);
        
        public const int GWL_EXSTYLE = -20;
        public const int WS_EX_LAYERED = 0x80000;
        public const int LWA_ALPHA = 0x2;
        public const int LWA_COLORKEY = 0x1;
        
        public const int GWL_STYLE = -16;
        public const int WS_CAPTION = 0x00C00000;
        public const int WS_THICKFRAME = 0x00040000;
        public const int WS_MINIMIZEBOX = 0x00020000;
        public const int WS_MAXIMIZEBOX = 0x00010000;
        public const int WS_SYSMENU = 0x00080000;
    }
"@

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Transparent Window"
$form.Size = New-Object System.Drawing.Size(400, 300)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::Lime  # Use lime green as transparent color
$form.TransparencyKey = [System.Drawing.Color]::Lime  # Make lime green transparent
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Sizable
$form.TopMost = $true

# Variables for decorator management
$decoratorsVisible = $true
$lastActivityTime = Get-Date
$originalStyle = 0
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 1000  # Check every second

# Function to hide decorators
function Hide-Decorators {
    $hwnd = $form.Handle
    $currentStyle = [Win32]::GetWindowLong($hwnd, [Win32]::GWL_STYLE)
    $script:originalStyle = $currentStyle
    
    # Remove caption, borders, and system menu
    $newStyle = $currentStyle -band (-bnot [Win32]::WS_CAPTION) -band (-bnot [Win32]::WS_THICKFRAME) -band (-bnot [Win32]::WS_SYSMENU)
    [Win32]::SetWindowLong($hwnd, [Win32]::GWL_STYLE, $newStyle) | Out-Null
    
    $script:decoratorsVisible = $false
    
    # Force window to redraw
    $form.Refresh()
}

# Function to show decorators
function Show-Decorators {
    if ($script:originalStyle -ne 0) {
        $hwnd = $form.Handle
        [Win32]::SetWindowLong($hwnd, [Win32]::GWL_STYLE, $script:originalStyle) | Out-Null
        $script:decoratorsVisible = $true
        
        # Force window to redraw
        $form.Refresh()
    }
}

# Function to reset activity timer
function Reset-ActivityTimer {
    $script:lastActivityTime = Get-Date
    if (-not $script:decoratorsVisible) {
        Show-Decorators
    }
}

# Timer tick event to check for inactivity
$timer.Add_Tick({
    $currentTime = Get-Date
    $timeSinceActivity = ($currentTime - $script:lastActivityTime).TotalSeconds
    
    if ($timeSinceActivity -ge 60 -and $script:decoratorsVisible) {
        Hide-Decorators
    }
})

# Event handlers for mouse activity
$form.Add_MouseMove({
    Reset-ActivityTimer
})

$form.Add_MouseClick({
    Reset-ActivityTimer
})

$form.Add_MouseDown({
    Reset-ActivityTimer
})

# Event handlers for keyboard activity
$form.Add_KeyDown({
    Reset-ActivityTimer
})

$form.Add_KeyPress({
    Reset-ActivityTimer
})

# Handle form load event
$form.Add_Load({
    # Store the original window style when form loads
    $hwnd = $form.Handle
    $script:originalStyle = [Win32]::GetWindowLong($hwnd, [Win32]::GWL_STYLE)
    
    # Start the timer
    $timer.Start()
    
    # Reset activity time
    Reset-ActivityTimer
})

# Handle form closing
$form.Add_FormClosing({
    $timer.Stop()
    $timer.Dispose()
})

# Add a label to show the window is working (optional)
$label = New-Object System.Windows.Forms.Label
$label.Text = "Transparent Window`nDecorators will hide after 60 seconds of inactivity`nClick to restore decorators"
$label.AutoSize = $false
$label.Size = New-Object System.Drawing.Size(380, 100)
$label.Location = New-Object System.Drawing.Point(10, 10)
$label.BackColor = [System.Drawing.Color]::Transparent
$label.ForeColor = [System.Drawing.Color]::Black
$label.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$label.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter

# Add mouse events to label as well
$label.Add_MouseMove({
    Reset-ActivityTimer
})

$label.Add_MouseClick({
    Reset-ActivityTimer
})

$label.Add_MouseDown({
    Reset-ActivityTimer
})

$form.Controls.Add($label)

# Ensure we're running in STA mode for Windows Forms
if ([System.Threading.Thread]::CurrentThread.GetApartmentState() -ne "STA") {
    Write-Host "Restarting script in STA mode..."
    PowerShell -STA -File $MyInvocation.MyCommand.Path
    exit
}

# Show the form
Write-Host "Starting transparent window with auto-hide decorators..."
Write-Host "The window decorators will disappear after 60 seconds of inactivity."
Write-Host "Click anywhere on the window to restore the decorators."
Write-Host "Close the window to exit the script."

# Use Show() instead of ShowDialog() and run application message loop
$form.Show()
$form.Activate()

# Keep the script running while the form is visible
try {
    while ($form.Visible) {
        [System.Windows.Forms.Application]::DoEvents()
        Start-Sleep -Milliseconds 100
    }
}
catch {
    Write-Host "Error: $_"
}
finally {
    if ($timer) {
        $timer.Stop()
        $timer.Dispose()
    }
    if ($form -and !$form.IsDisposed) {
        $form.Dispose()
    }
}

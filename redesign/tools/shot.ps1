# Starts the dev build of VLC on a test file, takes a picture of its window
# and closes it again. It does not use the mouse or the screen: clicks are
# posted to the window and the picture is asked from the window, so it works
# while something else is in front.
param(
    [string]$Out = "$PSScriptRoot\shot.png",
    [string]$Media = "$PSScriptRoot\Videos\clip-m.mp4",
    [int]$Width = 1440,
    [int]$Height = 1080,
    [int]$Wait = 6,
    [string[]]$VlcArgs = @(),
    # Reuse a dev-build window left open by an earlier -KeepOpen run.
    [int]$VlcProcessId = 0,
    # Move the pointer there before the shot, as "x,y" inside the window.
    [string]$Hover = "",
    # Steps before the shot, separated by ";":
    #   "x,y"      click there
    #   "w:x,y,n"  turn the wheel n notches down there
    #   "t:text"   type the text
    #   "k:code"   press the key with that virtual key code (13 is Enter)
    #   "s:path"   save a picture of the window as it is now
    #   "p:ms"     wait for a filter or player event
    #   "e:text"   replace the focused field, then press Enter
    #   "c:x,y"    double click there
    #   "n:"       select the second window shown by this VLC process
    #   "f:path"   name that file in the file dialog VLC shows and accept it
    #   "m:mod,code"    press a key while a modifier is held, by their virtual
    #              key codes ("m:17,76" is Ctrl+L)
    #   "d:x,y,x2,y2"    press there, drag to the second place and release;
    #              with ",1" at the end a picture is saved before the release,
    #              next to -Out with "-drag" in its name
    [string]$Click = "",
    [switch]$KeepOpen,
    # Another build than build-win64, the unpacked zip of a release for one
    [string]$VlcDir = ''
)

$ErrorActionPreference = 'Stop'
$vlcDir = (Resolve-Path $(if ($VlcDir) { $VlcDir } else { Join-Path $PSScriptRoot '../../build-win64' })).Path
$log = "$vlcDir\portable\vlc.log"

Add-Type -AssemblyName System.Drawing
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Win {
    public delegate bool EnumWindowProc(IntPtr h, IntPtr data);
    [DllImport("user32.dll")] public static extern bool EnumWindows(EnumWindowProc callback, IntPtr data);
    [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint processId);
    [DllImport("user32.dll", CharSet = CharSet.Unicode)] public static extern int GetClassName(IntPtr h, System.Text.StringBuilder name, int size);
    [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr h, int command);
    public static IntPtr FindWindow(uint processId) {
        IntPtr result = IntPtr.Zero;
        long largestArea = 0;
        EnumWindows((h, data) => {
            uint owner;
            GetWindowThreadProcessId(h, out owner);
            var name = new System.Text.StringBuilder(256);
            GetClassName(h, name, name.Capacity);
            if (owner == processId && name.ToString().Contains("QWindow")) {
                RECT rect;
                if (GetWindowRect(h, out rect)) {
                    long area = (long)(rect.R - rect.L) * (rect.B - rect.T);
                    if (area > largestArea) {
                        largestArea = area;
                        result = h;
                    }
                }
            }
            return true;
        }, IntPtr.Zero);
        return result;
    }
    [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out RECT r);
    [DllImport("user32.dll")] public static extern bool GetClientRect(IntPtr h, out RECT r);
    [DllImport("user32.dll")] public static extern bool ClientToScreen(IntPtr h, ref POINT p);
    [DllImport("user32.dll")] public static extern bool SetProcessDPIAware();
    [DllImport("user32.dll")] public static extern bool SetWindowPos(IntPtr h, IntPtr after, int x, int y, int cx, int cy, uint flags);
    [DllImport("user32.dll")] public static extern bool PostMessage(IntPtr h, uint msg, IntPtr w, IntPtr l);
    [DllImport("user32.dll")] public static extern bool PrintWindow(IntPtr h, IntPtr dc, uint flags);
    [DllImport("user32.dll")] public static extern IntPtr SendMessageTimeout(IntPtr h, uint msg, IntPtr w, IntPtr l, uint flags, uint timeout, out IntPtr result);
    [DllImport("kernel32.dll")] public static extern uint GetCurrentThreadId();
    [DllImport("user32.dll")] public static extern bool AttachThreadInput(uint from, uint to, bool attach);
    [DllImport("user32.dll")] public static extern bool GetKeyboardState(byte[] state);
    [DllImport("user32.dll")] public static extern bool SetKeyboardState(byte[] state);
    // A key pressed while a modifier is held, for the window only: the
    // state of the keyboard is set for its thread, the keyboard is not used.
    public static void Chord(IntPtr h, int modifier, int key) {
        uint process;
        uint target = GetWindowThreadProcessId(h, out process);
        uint self = GetCurrentThreadId();
        AttachThreadInput(self, target, true);
        var state = new byte[256];
        GetKeyboardState(state);
        var held = (byte[])state.Clone();
        held[modifier] |= 0x80;
        // Qt asks for the left and the right key of a modifier, which come
        // after the modifiers: Shift 16 -> 160, Ctrl 17 -> 162, Alt 18 -> 164.
        if (modifier >= 16 && modifier <= 18)
            held[160 + 2 * (modifier - 16)] |= 0x80;
        SetKeyboardState(held);
        PostMessage(h, 0x0100, (IntPtr)key, (IntPtr)1);
        PostMessage(h, 0x0101, (IntPtr)key, new IntPtr(unchecked((int)0xC0000001)));
        System.Threading.Thread.Sleep(300);
        SetKeyboardState(state);
        AttachThreadInput(self, target, false);
    }
    [DllImport("user32.dll", CharSet = CharSet.Unicode)] public static extern IntPtr SendMessage(IntPtr h, uint msg, IntPtr w, string l);
    [DllImport("user32.dll")] public static extern bool EnumChildWindows(IntPtr parent, EnumWindowProc callback, IntPtr data);
    [DllImport("user32.dll")] public static extern IntPtr GetParent(IntPtr h);
    [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
    static string ClassOf(IntPtr h) {
        var name = new System.Text.StringBuilder(256);
        GetClassName(h, name, name.Capacity);
        return name.ToString();
    }
    public static IntPtr FindOtherWindow(uint processId, IntPtr main) {
        IntPtr result = IntPtr.Zero;
        long largestArea = 0;
        EnumWindows((h, data) => {
            uint owner;
            GetWindowThreadProcessId(h, out owner);
            RECT rect;
            if (owner == processId && h != main && IsWindowVisible(h)
                && ClassOf(h).Contains("QWindow") && GetWindowRect(h, out rect)) {
                long area = (long)(rect.R - rect.L) * (rect.B - rect.T);
                if (area > largestArea) { largestArea = area; result = h; }
            }
            return true;
        }, IntPtr.Zero);
        return result;
    }
    // Gives the file dialog a process shows the name of a file and accepts
    // it, with messages to the dialog. False if there is no such dialog.
    public static bool AnswerFileDialog(uint processId, string path) {
        IntPtr dialog = IntPtr.Zero;
        EnumWindows((h, data) => {
            uint owner;
            GetWindowThreadProcessId(h, out owner);
            if (owner == processId && IsWindowVisible(h) && ClassOf(h) == "#32770") {
                dialog = h;
                return false;
            }
            return true;
        }, IntPtr.Zero);
        if (dialog == IntPtr.Zero)
            return false;

        // The field for the name is the edit of a combo box, other edits of
        // the dialog are for searching and for the folder.
        IntPtr edit = IntPtr.Zero;
        EnumChildWindows(dialog, (h, data) => {
            if (ClassOf(h) == "Edit" && ClassOf(GetParent(GetParent(h))) == "ComboBoxEx32") {
                edit = h;
                return false;
            }
            return true;
        }, IntPtr.Zero);
        if (edit == IntPtr.Zero)
            return false;

        SendMessage(edit, 0x000C, IntPtr.Zero, path);
        PostMessage(dialog, 0x0111, (IntPtr)1, IntPtr.Zero);
        return true;
    }
    // The largest window a process shows besides one of them: a dialog or
    // a second window of the player. Zero if there is none.
    public static IntPtr FindOtherWindow(uint processId, IntPtr main) {
        IntPtr result = IntPtr.Zero;
        long largestArea = 0;
        EnumWindows((h, data) => {
            uint owner;
            GetWindowThreadProcessId(h, out owner);
            RECT rect;
            if (owner == processId && h != main && IsWindowVisible(h) && ClassOf(h).Contains("QWindow")
                && GetWindowRect(h, out rect)) {
                long area = (long)(rect.R - rect.L) * (rect.B - rect.T);
                if (area > largestArea) {
                    largestArea = area;
                    result = h;
                }
            }
            return true;
        }, IntPtr.Zero);
        return result;
    }
    public struct RECT { public int L, T, R, B; }
    public struct POINT { public int X, Y; }
}
"@
[Win]::SetProcessDPIAware() | Out-Null

if ($VlcProcessId -eq 0) {
    $devProcesses = @(Get-Process vlc -ErrorAction SilentlyContinue | Where-Object {
        $_.Path -eq (Join-Path $vlcDir 'vlc.exe')
    })
    $devProcesses | ForEach-Object { $_.CloseMainWindow() | Out-Null }
    Start-Sleep -Milliseconds 800
    $devProcesses | Where-Object { -not $_.HasExited } | Stop-Process -Force
    Remove-Item -LiteralPath $log -ErrorAction SilentlyContinue

    # A VLC that was killed asks whether to restore its play queue the next time.
    $ini = Join-Path $vlcDir "portable/vlc/vlc-qt-interface.ini"
    if (Test-Path $ini) {
        $kept = Get-Content $ini | Where-Object { $_ -notmatch "^RecoveryFilePath=" }
        [IO.File]::WriteAllLines($ini, $kept)
    }

    $arguments = @("-vv", "--file-logging", "--logfile=$log", "--no-qt-privacy-ask", "--no-one-instance", "--no-qt-video-autoresize") + $VlcArgs
    if ($Media) { $arguments += "`"$Media`"" }
    $p = Start-Process -FilePath "$vlcDir\vlc.exe" -WorkingDirectory $vlcDir -ArgumentList $arguments -WindowStyle Hidden -PassThru
} else {
    $p = Get-Process -Id $VlcProcessId
    if ($p.Path -ne (Join-Path $vlcDir 'vlc.exe')) {
        throw "The selected process is not this checkout's VLC dev build."
    }
}

$deadline = (Get-Date).AddSeconds(20)
do { Start-Sleep -Milliseconds 300; $h = [Win]::FindWindow($p.Id) } while ($h -eq 0 -and (Get-Date) -lt $deadline)
if ($h -eq 0) { throw 'VLC did not create a main window within 20 seconds.' }
# Show without taking focus; the hidden launch also suppresses its console.
[Win]::ShowWindow($h, 4) | Out-Null
# No activation, no change of the stacking order
[Win]::SetWindowPos($h, [IntPtr]::Zero, 0, 0, $Width, $Height, 0x0014) | Out-Null
Start-Sleep -Seconds $Wait
# The window takes the size of the video when that starts.
$h = [Win]::FindWindow($p.Id)
if ($h -eq 0) { throw 'The VLC window disappeared during video startup.' }
[Win]::SetWindowPos($h, [IntPtr]::Zero, 0, 0, $Width, $Height, 0x0014) | Out-Null
Start-Sleep -Milliseconds 1500

# A failed QML load can leave a gray QWindow next to an assertion dialog.
# Finding that window does not mean the interface started.
if ((Test-Path $log) -and (Select-String -Path $log -Pattern 'qt error: qml loading' -Quiet)) {
    Stop-Process -Id $p.Id -Force -ErrorAction SilentlyContinue
    throw "VLC could not load its QML interface; the dev process was stopped. See $log."
}

# Positions are given as they are in the picture, which is of the whole
# window: this is where what the window draws in starts in it.
$wr = New-Object Win+RECT
[Win]::GetWindowRect($h, [ref]$wr) | Out-Null
$origin = New-Object Win+POINT
[Win]::ClientToScreen($h, [ref]$origin) | Out-Null
$dx = $origin.X - $wr.L
$dy = $origin.Y - $wr.T

function Pos([int]$x, [int]$y) { [IntPtr](($y -shl 16) -bor ($x -band 0xFFFF)) }

function Shot([string]$path) {
    $reply = [IntPtr]::Zero
    # Avoid waiting forever in PrintWindow when the Qt event loop is blocked.
    if ([Win]::SendMessageTimeout($h, 0, [IntPtr]::Zero, [IntPtr]::Zero, 3, 2000, [ref]$reply) -eq [IntPtr]::Zero) {
        Stop-Process -Id $p.Id -Force -ErrorAction SilentlyContinue
        throw 'The VLC window is not responding; PrintWindow was skipped.'
    }
    $r = New-Object Win+RECT
    if (-not [Win]::GetWindowRect($h, [ref]$r)) { throw 'The VLC window no longer exists.' }
    $w = $r.R - $r.L
    $ht = $r.B - $r.T
    $bmp = New-Object System.Drawing.Bitmap $w, $ht
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $dc = $g.GetHdc()
    # 2: what the window shows, also when it is drawn by the compositor
    $printed = [Win]::PrintWindow($h, $dc, 2)
    $g.ReleaseHdc($dc)
    if (-not $printed) {
        $g.Dispose()
        $bmp.Dispose()
        throw 'PrintWindow failed to capture the VLC window.'
    }
    $bmp.Save($path)
    $g.Dispose()
    $bmp.Dispose()
    "window ${w}x${ht}, saved $path"
}

foreach ($step in ($Click -split ";" | Where-Object { $_ })) {
    if ($step.StartsWith("p:")) {
        Start-Sleep -Milliseconds ([int]$step.Substring(2))
        continue
    }
    if ($step.StartsWith("e:")) {
        # Field contents are short. Backspace and Delete avoid changing the
        # real keyboard state, which a synthetic Ctrl+A would require.
        for ($i = 0; $i -lt 64; ++$i) {
            [Win]::PostMessage($h, 0x0100, [IntPtr]8, [IntPtr]1) | Out-Null
            [Win]::PostMessage($h, 0x0101, [IntPtr]8, [IntPtr]0xC0000001) | Out-Null
            [Win]::PostMessage($h, 0x0100, [IntPtr]46, [IntPtr]1) | Out-Null
            [Win]::PostMessage($h, 0x0101, [IntPtr]46, [IntPtr]0xC0000001) | Out-Null
        }
        # Qt translates posted key messages into character messages. Let
        # those finish before posting the replacement text.
        Start-Sleep -Milliseconds 400
        foreach ($c in $step.Substring(2).ToCharArray()) {
            [Win]::PostMessage($h, 0x0102, [IntPtr][int]$c, [IntPtr]1) | Out-Null
        }
        Start-Sleep -Milliseconds 200
        [Win]::PostMessage($h, 0x0100, [IntPtr]13, [IntPtr]1) | Out-Null
        [Win]::PostMessage($h, 0x0101, [IntPtr]13, [IntPtr]0xC0000001) | Out-Null
        Start-Sleep -Milliseconds 1200
        continue
    }
    if ($step.StartsWith("s:")) {
        Shot $step.Substring(2)
        continue
    }
    if ($step.StartsWith("t:")) {
        foreach ($c in $step.Substring(2).ToCharArray()) {
            [Win]::PostMessage($h, 0x0102, [IntPtr][int]$c, [IntPtr]::Zero) | Out-Null
            Start-Sleep -Milliseconds 30
        }
        Start-Sleep -Milliseconds 400
        continue
    }
    if ($step.StartsWith("k:")) {
        $key = [int]$step.Substring(2)
        [Win]::PostMessage($h, 0x0100, [IntPtr]$key, [IntPtr]::Zero) | Out-Null
        [Win]::PostMessage($h, 0x0101, [IntPtr]$key, [IntPtr]0xC0000001) | Out-Null
        Start-Sleep -Milliseconds 600
        continue
    }
    if ($step -eq "n:") {
        $other = [Win]::FindOtherWindow($p.Id, $h)
        if ($other -eq 0) { throw 'VLC shows no second window.' }
        $h = $other
        $wr = New-Object Win+RECT
        [Win]::GetWindowRect($h, [ref]$wr) | Out-Null
        $origin = New-Object Win+POINT
        [Win]::ClientToScreen($h, [ref]$origin) | Out-Null
        $dx = $origin.X - $wr.L
        $dy = $origin.Y - $wr.T
        "second window $($wr.R - $wr.L)x$($wr.B - $wr.T)"
        continue
    }
    if ($step.StartsWith("f:")) {
        $answered = $false
        for ($i = 0; $i -lt 20 -and -not $answered; ++$i) {
            Start-Sleep -Milliseconds 250
            $answered = [Win]::AnswerFileDialog($p.Id, $step.Substring(2))
        }
        if (-not $answered) { throw 'VLC did not show a file dialog.' }
        Start-Sleep -Milliseconds 1500
        continue
    }
    if ($step.StartsWith("m:")) {
        $keys = $step.Substring(2).Split(",") | ForEach-Object { [int]$_ }
        [Win]::Chord($h, $keys[0], $keys[1])
        Start-Sleep -Milliseconds 1000
        continue
    }
    if ($step.StartsWith("d:") -or $step.StartsWith("c:")) {
        $xy = $step.Substring(2).Split(",") | ForEach-Object { [int]$_ }
        $x = $xy[0] - $dx
        $y = $xy[1] - $dy
        [Win]::PostMessage($h, 0x0200, [IntPtr]::Zero, (Pos $x $y)) | Out-Null
        Start-Sleep -Milliseconds 300
        if ($step.StartsWith("c:")) {
            # A double click is a click and a press that says it is the second.
            [Win]::PostMessage($h, 0x0201, [IntPtr]1, (Pos $x $y)) | Out-Null
            [Win]::PostMessage($h, 0x0202, [IntPtr]::Zero, (Pos $x $y)) | Out-Null
            [Win]::PostMessage($h, 0x0203, [IntPtr]1, (Pos $x $y)) | Out-Null
            [Win]::PostMessage($h, 0x0202, [IntPtr]::Zero, (Pos $x $y)) | Out-Null
        } else {
            # Press, move there in a few steps with the button held, release.
            $tx = $xy[2] - $dx
            $ty = $xy[3] - $dy
            [Win]::PostMessage($h, 0x0201, [IntPtr]1, (Pos $x $y)) | Out-Null
            for ($i = 1; $i -le 8; ++$i) {
                Start-Sleep -Milliseconds 40
                $mx = [int]($x + ($tx - $x) * $i / 8)
                $my = [int]($y + ($ty - $y) * $i / 8)
                [Win]::PostMessage($h, 0x0200, [IntPtr]1, (Pos $mx $my)) | Out-Null
            }
            Start-Sleep -Milliseconds 300
            if ($xy.Count -gt 4) { Shot ("$Out" -replace '\.png$', '-drag.png') }
            [Win]::PostMessage($h, 0x0202, [IntPtr]::Zero, (Pos $tx $ty)) | Out-Null
        }
        Start-Sleep -Milliseconds 1200
        continue
    }

    $wheel = $step.StartsWith("w:")
    $xy = $step.Substring($(if ($wheel) { 2 } else { 0 })).Split(",")
    $x = [int]$xy[0] - $dx
    $y = [int]$xy[1] - $dy
    [Win]::PostMessage($h, 0x0200, [IntPtr]::Zero, (Pos $x $y)) | Out-Null
    Start-Sleep -Milliseconds 300
    if ($wheel) {
        # The wheel says where it is in screen coordinates.
        $pt = New-Object Win+POINT
        $pt.X = $x
        $pt.Y = $y
        [Win]::ClientToScreen($h, [ref]$pt) | Out-Null
        $notches = [int]$xy[2]
        $delta = if ($notches -gt 0) { -120 } else { 120 }
        for ($i = 0; $i -lt [Math]::Abs($notches); ++$i) {
            [Win]::PostMessage($h, 0x020A, [IntPtr]($delta -shl 16), (Pos $pt.X $pt.Y)) | Out-Null
            Start-Sleep -Milliseconds 60
        }
    } else {
        [Win]::PostMessage($h, 0x0201, [IntPtr]1, (Pos $x $y)) | Out-Null
        Start-Sleep -Milliseconds 60
        [Win]::PostMessage($h, 0x0202, [IntPtr]::Zero, (Pos $x $y)) | Out-Null
    }
    Start-Sleep -Milliseconds 1200
}
if ($Hover) {
    $xy = $Hover.Split(",")
    [Win]::PostMessage($h, 0x0200, [IntPtr]::Zero, (Pos ([int]$xy[0] - $dx) ([int]$xy[1] - $dy))) | Out-Null
    Start-Sleep -Milliseconds 900
}
Shot $Out
"VLC process: $($p.Id)"

if (-not $KeepOpen) {
    $p.CloseMainWindow() | Out-Null
    if (-not $p.WaitForExit(5000)) { $p | Stop-Process -Force; "had to kill vlc" }
}

if (Test-Path $log) {
    Get-Content $log | Select-String -Pattern "qt (warning|error|critical)" | Select-Object -First 25 |
        ForEach-Object { $t = $_.Line; if ($t.Length -gt 280) { $t.Substring(0, 280) } else { $t } }
}

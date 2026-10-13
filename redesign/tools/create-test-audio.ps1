# Generate a small PCM fixture for silent audio-visualizer checks.
param([string]$Out = "$PSScriptRoot/Videos/test-tone.wav")

$ErrorActionPreference = 'Stop'
Add-Type @'
using System;
using System.IO;
using System.Text;
public static class TestAudio {
    public static void Write(string path) {
        const int rate = 48000;
        const int samples = rate * 20;
        using (var writer = new BinaryWriter(File.Create(path))) {
            writer.Write(Encoding.ASCII.GetBytes("RIFF"));
            writer.Write(36 + samples * 2);
            writer.Write(Encoding.ASCII.GetBytes("WAVEfmt "));
            writer.Write(16);
            writer.Write((short)1);
            writer.Write((short)1);
            writer.Write(rate);
            writer.Write(rate * 2);
            writer.Write((short)2);
            writer.Write((short)16);
            writer.Write(Encoding.ASCII.GetBytes("data"));
            writer.Write(samples * 2);
            for (int i = 0; i < samples; ++i) {
                double phase = 2 * Math.PI * i / rate;
                writer.Write((short)(8000 * Math.Sin(440 * phase) + 4000 * Math.Sin(880 * phase)));
            }
        }
    }
}
'@
[TestAudio]::Write([IO.Path]::GetFullPath($Out))
"Created $Out"

"""Turns an X window dump, as Xvfb keeps of its screen with -fbdir, into a
PNG. For the build image of the Linux test, which has no tool for that.

python3 xwd-to-png.py <Xvfb_screen0> <out.png>"""
import struct
import sys
import zlib

data = open(sys.argv[1], "rb").read()

# The header is 25 numbers, in the byte order of whoever wrote it. The
# second one is the version of the format, which is 7.
order = ">" if struct.unpack(">I", data[4:8])[0] == 7 else "<"
header = struct.unpack(order + "25I", data[:100])
width, height, msb_first, line_size, colors = header[4], header[5], header[7], header[12], header[19]
start = header[0] + colors * 12

# Four bytes for a pixel: blue, green, red and one that is not used, or
# these the other way around.
first, step = (1, 1) if msb_first else (2, -1)

rows = bytearray()
for y in range(height):
    line = data[start + y * line_size:start + y * line_size + width * 4]
    row = bytearray(width * 3)
    for channel in range(3):
        row[channel::3] = line[first + step * channel::4]
    rows += b"\0" + row


def chunk(kind, body):
    return struct.pack(">I", len(body)) + kind + body + struct.pack(">I", zlib.crc32(kind + body))


with open(sys.argv[2], "wb") as png:
    png.write(b"\x89PNG\r\n\x1a\n"
              + chunk(b"IHDR", struct.pack(">IIBBBBB", width, height, 8, 2, 0, 0, 0))
              + chunk(b"IDAT", zlib.compress(bytes(rows), 6))
              + chunk(b"IEND", b""))

print(f"picture {width}x{height}")

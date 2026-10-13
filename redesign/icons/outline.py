#! /usr/bin/env python3
"""Turn the icons of the Figma file into outlines VLC's icon font can take.

The Figma icons are mostly strokes, the icon font needs filled shapes without
overlaps (see modules/gui/qt/pixmaps/makeIconFont.py). FontForge expands plain
strokes when it imports an SVG, two things have to be prepared for it:

  - a shape that is filled and stroked comes out hollow, so its fill is
    imported alone and grown by half the stroke width;
  - a dot drawn as a stroke of no length with round caps comes out empty, so
    it is replaced by a circle.

usage: outline.py <VLCIcons.json> <figma_dir> [preview_dir]

The glyphs of VLCIcons.json whose path is in icons/redesign/ are the ones made
here, each from the Figma icon of the same file name.
"""
import json
import os
import re
import sys
import tempfile
import xml.etree.ElementTree as ET

import fontforge

SVG_NS = "http://www.w3.org/2000/svg"
SHAPES = {"path", "rect", "circle", "ellipse", "line", "polyline", "polygon"}
EM = 1024

ET.register_namespace("", SVG_NS)


def local(tag):
    return tag.rsplit("}", 1)[-1]


def shapes_of(node, inherited):
    """Yield (element, fill, stroke, transforms) for each shape below node."""
    for child in node:
        name = local(child.tag)
        style = dict(inherited)
        for key in ("fill", "stroke", "stroke-width", "stroke-linecap", "stroke-linejoin"):
            if key in child.attrib:
                style[key] = child.attrib[key]
        transforms = inherited["transforms"]
        if "transform" in child.attrib and name == "g":
            transforms = transforms + [child.attrib["transform"]]
        style["transforms"] = transforms
        if name == "g":
            yield from shapes_of(child, style)
        elif name in SHAPES:
            yield child, style


def is_dot(element):
    """A path that goes nowhere: with round caps it is drawn as a dot."""
    if local(element.tag) != "path":
        return None
    numbers = [float(n) for n in re.findall(r"-?\d*\.?\d+(?:e-?\d+)?", element.attrib.get("d", ""))]
    if len(numbers) != 4 or not re.fullmatch(r"\s*M[^A-Za-z]*L[^A-Za-z]*", element.attrib.get("d", "")):
        return None
    if abs(numbers[0] - numbers[2]) > 0.01 or abs(numbers[1] - numbers[3]) > 0.01:
        return None
    return numbers[0], numbers[1]


def single_shape_svg(root, element, style, path):
    """Write an SVG with the size of root that only holds element."""
    svg = ET.Element("{%s}svg" % SVG_NS, {k: root.attrib[k] for k in ("width", "height", "viewBox")})
    parent = svg
    for transform in style["transforms"]:
        parent = ET.SubElement(parent, "{%s}g" % SVG_NS, {"transform": transform})
    copy = ET.SubElement(parent, element.tag, dict(element.attrib))
    for key in ("fill", "stroke", "stroke-width", "stroke-linecap", "stroke-linejoin"):
        copy.attrib.pop(key, None)
        if style.get(key) not in (None, "none"):
            copy.attrib[key] = "#000000" if key in ("fill", "stroke") else style[key]
    copy.attrib.setdefault("fill", "none")
    ET.ElementTree(svg).write(path)


def outline(font, code, source):
    root = ET.parse(source).getroot()
    scale = EM / float(root.attrib["width"])
    glyph = font.createChar(code)
    scratch = font.createChar(code + 0x1000)

    base = {"fill": "none", "stroke": "none", "transforms": []}
    if "fill" in root.attrib:
        base["fill"] = root.attrib["fill"]

    with tempfile.TemporaryDirectory() as tmp:
        part = os.path.join(tmp, "part.svg")
        for element, style in shapes_of(root, base):
            filled = style.get("fill", "none") != "none"
            stroked = style.get("stroke", "none") != "none"
            width = float(style.get("stroke-width", 1))

            dot = is_dot(element) if stroked and style.get("stroke-linecap") == "round" else None
            if dot:
                element = ET.Element("{%s}circle" % SVG_NS,
                                     {"cx": str(dot[0]), "cy": str(dot[1]), "r": str(width / 2)})
                style = dict(style, fill="#000000", stroke="none")
                filled, stroked = True, False

            if not filled and not stroked:
                continue

            scratch.clear()
            if filled and stroked:
                single_shape_svg(root, element, dict(style, stroke="none"), part)
                scratch.importOutlines(part)
                scratch.correctDirection()
                scratch.stroke("circular", width * scale, cap="round",
                               join=style.get("stroke-linejoin", "miter"), removeinternal=True)
            else:
                single_shape_svg(root, element, style, part)
                scratch.importOutlines(part)
                scratch.removeOverlap()
                scratch.correctDirection()

            layer = glyph.foreground
            layer += scratch.foreground
            glyph.foreground = layer

    font.removeGlyph(scratch)
    glyph.removeOverlap()
    glyph.round()
    glyph.width = EM
    glyph.vwidth = EM
    return glyph


def write_svg(glyph, path):
    """Export glyph as an SVG that is exactly as big as the em square."""
    glyph.export(path)
    with open(path, encoding="utf-8") as f:
        d = re.search(r'\sd="([^"]*)"', f.read()).group(1)
    with open(path, "w", encoding="utf-8", newline="\n") as f:
        f.write('<svg width="%d" height="%d" viewBox="0 0 %d %d" xmlns="%s">\n' % (EM, EM, EM, EM, SVG_NS))
        f.write(' <path d="%s"/>\n</svg>\n' % " ".join(d.split()))


def main():
    model_path, figma_dir = sys.argv[1:3]
    preview_dir = sys.argv[3] if len(sys.argv) > 3 else None
    with open(model_path, encoding="utf-8") as f:
        model = json.load(f)
    pixmaps_dir = os.path.dirname(os.path.abspath(model_path))

    font = fontforge.font()
    font.em = EM
    font.ascent = EM
    font.descent = 0

    wanted = sorted({glyph["path"] for glyph in model["glyphs"] if "/redesign/" in glyph["path"]})
    for i, path in enumerate(wanted):
        name = os.path.basename(path)
        glyph = outline(font, 0xE000 + i, os.path.join(figma_dir, name))
        dest = os.path.join(pixmaps_dir, path)
        os.makedirs(os.path.dirname(dest), exist_ok=True)
        write_svg(glyph, dest)
        if preview_dir:
            glyph.export(os.path.join(preview_dir, name[:-4] + ".png"), 96)
        print("%-32s %d contours" % (name, len(glyph.foreground)))


main()

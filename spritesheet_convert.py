#!/usr/bin/env python3
"""
Skaliert ein Spritesheet auf 256x256 (Nearest Neighbor) und entfernt den weißen Hintergrund.

Usage:
    python3 spritesheet_convert.py <input.png> [output.png] [--size 256] [--threshold 240]
"""

import sys
import argparse
from pathlib import Path
from PIL import Image
import numpy as np


def convert(input_path: str, output_path: str, size: int, threshold: int, remove_bg: bool = True) -> None:
    img = Image.open(input_path).convert("RGBA")
    print(f"Original: {img.size}")

    img = img.resize((size, size), Image.NEAREST)

    data = np.array(img)

    if remove_bg:
        r, g, b = data[:, :, 0], data[:, :, 1], data[:, :, 2]
        white_mask = (r > threshold) & (g > threshold) & (b > threshold)
        data[white_mask] = [0, 0, 0, 0]
        print(f"Entfernte Pixel: {int(white_mask.sum())}")
    else:
        print("Hintergrund-Entfernung übersprungen")

    Image.fromarray(data).save(output_path)
    print(f"Skaliert auf: {size}x{size}")
    print(f"Gespeichert: {output_path}")


def main() -> None:
    parser = argparse.ArgumentParser(description="Spritesheet auf Zielgröße skalieren und weißen Hintergrund entfernen.")
    parser.add_argument("input", help="Eingabedatei (z.B. spritesheet.png)")
    parser.add_argument("output", nargs="?", help="Ausgabedatei (Standard: <name>_converted.png)")
    parser.add_argument("--size", type=int, default=256, help="Zielgröße in Pixel (Standard: 256)")
    parser.add_argument("--threshold", type=int, default=240, help="Schwellwert für Weiß 0-255 (Standard: 240)")
    parser.add_argument("--no-remove-bg", action="store_true", help="Weißen Hintergrund NICHT entfernen")
    args = parser.parse_args()

    input_path = Path(args.input)
    if not input_path.exists():
        print(f"Fehler: Datei nicht gefunden: {input_path}")
        sys.exit(1)

    output_path = args.output or str(input_path.stem) + "_converted.png"

    convert(str(input_path), output_path, args.size, args.threshold, not args.no_remove_bg)


if __name__ == "__main__":
    main()

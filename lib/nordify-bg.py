#!/usr/bin/env python3

"""
Simple ImageGoNord converter.
Usage:
  python nordify.py input.jpg
  python nordify.py input.jpg output.png
"""

import sys
from pathlib import Path
from ImageGoNord import GoNord, NordPaletteFile

def main():
    if len(sys.argv) < 2:
        print("Usage: python nordify.py <input_image> [output_image]")
        sys.exit(1)

    input_path = Path(sys.argv[1])
    if not input_path.exists():
        print(f"Error: file not found → {input_path}")
        sys.exit(1)

    # Default output name: original_name_nord.ext
    if len(sys.argv) >= 3:
        output_path = Path(sys.argv[2])
    else:
        output_path = input_path.with_stem(input_path.stem + "_nord")

    go_nord = GoNord()

    # Recommended for most wallpapers
    go_nord.enable_avg_algorithm()

    # Optional: limit the palette (comment out what you don't want)
    # go_nord.reset_palette()
    # go_nord.add_file_to_palette(NordPaletteFile.POLAR_NIGHT)
    # go_nord.add_file_to_palette(NordPaletteFile.SNOW_STORM)
    # go_nord.add_file_to_palette(NordPaletteFile.FROST)
    # go_nord.add_file_to_palette(NordPaletteFile.AURORA)

    print(f"Converting: {input_path} → {output_path}")
    image = go_nord.open_image(str(input_path))
    go_nord.convert_image(image, save_path=str(output_path))
    print("Done.")

if __name__ == "__main__":
    main()

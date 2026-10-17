# ExifButcher 📸🔪

ExifButcher is a lightweight, native macOS Menu Bar utility that allows users to seamlessly batch-update the EXIF camera model data in RAW files (such as Fujifilm `.RAF`). 

If you just bought a brand new camera and your preferred RAW converter (like Capture One Pro or Lightroom) hasn't updated its profiles to support it yet, ExifButcher lets you quickly trick the software. It "butchers" the EXIF data by swapping out the actual camera model with an older model that uses the same sensor and processor, so you can start editing immediately.

![ExifButcher Icon](Resources/Assets.xcassets/AppIcon.appiconset/mac_512.png)

## Features
- **Native macOS Integration:** Seamlessly integrates directly into Finder. Just right-click any RAW file or folder of RAWs and select **"Adjust RAWs EXIF"**.
- **Minimal UI:** Sits quietly in your Menu Bar. Set your target camera model once and forget it.
- **Fast & Safe:** Uses the industry-standard [ExifTool](https://exiftool.org/) engine under the hood. Modifies files safely in-place (`-overwrite_original`).
- **Batch Processing:** Handles single files or recursively scans entire directories and SD cards.
- **Zero Configuration:** Bundles its own `exiftool` binary, so you don't need to install any command-line tools or dependencies.

## Installation

### Homebrew (recommended)
With [Homebrew](https://brew.sh) installed, run:
```bash
brew install --cask webdunesurfer/tap/exifbutcher
```
Then open ExifButcher once from `/Applications` to register the Finder action.

- Update: `brew upgrade --cask exifbutcher`
- Uninstall: `brew uninstall --cask exifbutcher`

If you installed ExifButcher manually before, delete `/Applications/ExifButcher.app` first. Homebrew won't overwrite an app it didn't install.

### Manual
1. Download the latest `.pkg` or `.dmg` from the [Releases page](https://github.com/webdunesurfer/ExifButcher/releases).
2. **`.pkg`:** right-click it → **Open**, then follow the installer. **`.dmg`:** drag `ExifButcher.app` onto the `Applications` shortcut.
3. The app is not notarized, so macOS asks you to confirm the first launch. If it is blocked, go to **System Settings > Privacy & Security** and click **Open Anyway**.
4. Open `ExifButcher.app` from your Applications folder once to register the macOS Service.

See [docs/INSTALLATION.md](docs/INSTALLATION.md) for details and troubleshooting.

## Usage
1. Click the ExifButcher (camera) icon in your macOS Menu Bar.
2. In the **Target Camera Model** field, enter the camera model you want to spoof (e.g., `X-S20`).
3. (Optional) Enter the **Original Camera Model** to ensure it only modifies files from a specific camera (e.g., `X-T30 III`).
4. Right-click any `.RAF` file or folder in Finder, go to **Quick Actions** (or Services), and click **Adjust RAWs EXIF**.
5. Wait for the macOS notification confirming success!

## Development
This app is built using Swift, SwiftUI, and Xcodegen.

1. Clone the repository.
2. Install [Xcodegen](https://github.com/yonaskolb/XcodeGen) (`brew install xcodegen`).
3. Run `xcodegen generate` in the root directory.
4. Open the generated `ExifButcher.xcodeproj` in Xcode and build, or run `scripts/package.sh <version>` to build the installers.

ExifTool is bundled in `Resources/exiftool`. See [docs/BUILD.md](docs/BUILD.md) for releases and CI.

## Credits
- **Core Engine:** Built on top of the incredible [ExifTool](https://exiftool.org/) by Phil Harvey.

## License
MIT License. See `LICENSE` for details.

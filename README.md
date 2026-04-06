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
1. Go to the [Releases/Actions tab](https://github.com/webdunesurfer/ExifButcher/actions) on this repository.
2. Click on the latest successful "Build and Release" workflow run.
3. Download the `ExifButcher-Installers` artifact at the bottom of the page.
4. Extract the zip file and run the `.pkg` installer, or mount the `.dmg` and drag `ExifButcher.app` to your `/Applications` folder.
5. **Gatekeeper Note:** If macOS says the app is "damaged," this is because it is unsigned. Open Terminal and run:
   ```bash
   xattr -cr /Applications/ExifButcher.app
   ```
6. Open `ExifButcher.app` from your Applications folder once to register the macOS Service.

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
3. Download the macOS package from [ExifTool](https://exiftool.org/), extract it, rename the folder to `exiftool`, and place it in the `Resources` directory.
4. Run `xcodegen generate` in the root directory.
5. Open the generated `ExifButcher.xcodeproj` in Xcode and build.

## Credits
- **Core Engine:** Built on top of the incredible [ExifTool](https://exiftool.org/) by Phil Harvey.

## License
MIT License. See `LICENSE` for details.

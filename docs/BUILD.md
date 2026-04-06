# Build Instructions

ExifButcher uses **XcodeGen** to procedurally generate the `.xcodeproj` file. This prevents merge conflicts in the Xcode project file and keeps the repository clean.

## Prerequisites
1. **macOS** (13.0 Ventura or higher).
2. **Xcode** (Full Xcode app installed via the Mac App Store, not just the Command Line Tools).
3. **Homebrew** (`brew`).

## Local Setup & Build

1. **Install XcodeGen**
   ```bash
   brew install xcodegen
   ```

2. **Download ExifTool**
   ExifTool must be bundled manually since it is not checked into the repository to save space.
   - Download the latest macOS Package from [exiftool.org](https://exiftool.org/).
   - Extract the `.tar.gz` file.
   - Rename the extracted folder to exactly `exiftool`.
   - Move it to the `Resources` directory: `ExifButcher/Resources/exiftool`.

3. **Generate the Xcode Project**
   In the root of the repository, run:
   ```bash
   xcodegen generate
   ```
   *Note: If you change settings in `project.yml`, you must re-run this command. If you add keys that inject into `Info.plist`, ensure you do not have a hardcoded `Info.plist` checked into git that overrides `xcodegen`, or manually update the physical `Info.plist`.*

4. **Build the App**
   Open `ExifButcher.xcodeproj` in Xcode and press `Cmd + B` to build, or run via CLI:
   ```bash
   xcodebuild -project ExifButcher.xcodeproj -scheme ExifButcher -configuration Release build SYMROOT=build CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO
   ```

## CI/CD Pipeline (GitHub Actions)
The repository includes an automated workflow (`.github/workflows/build.yml`) that triggers on pushes and pull requests to the `main` branch. 

The pipeline automatically:
1. Installs XcodeGen.
2. Generates the Xcode project.
3. Compiles the Swift application.
4. Generates a `.pkg` macOS Installer using `pkgbuild`.
5. Generates a `.dmg` Disk Image using `hdiutil`.
6. Uploads them as a single zip artifact named `ExifButcher-Installers`.
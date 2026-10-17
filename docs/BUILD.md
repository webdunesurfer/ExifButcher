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

2. **ExifTool**
   ExifTool is checked into the repository at `Resources/exiftool` and is copied into the app bundle by a post-compile script. To upgrade it, replace that folder with the contents of the latest release from [exiftool.org](https://exiftool.org/).

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

5. **Build the installers (optional)**
   ```bash
   scripts/package.sh 1.2.0          # version, optional build number as 2nd arg
   ```
   This builds a universal (arm64 + x86_64) app, ad-hoc signs it, and writes `ExifButcher-<version>.dmg`, `ExifButcher-<version>.pkg` and `SHA256SUMS.txt` to `dist/`.

## Versioning
`MARKETING_VERSION` and `CURRENT_PROJECT_VERSION` in `project.yml` are the defaults for local builds. Release builds override them from the git tag (`v1.2.0` → `1.2.0`) and the CI run number.

## CI/CD Pipeline (GitHub Actions)
Both workflows install XcodeGen and run `scripts/package.sh`.

- **`.github/workflows/build.yml`** runs on pushes and pull requests to `main`. It uploads the installers as a short-lived (14-day) `ExifButcher-test-build` artifact for testing.
- **`.github/workflows/release.yml`** runs when a `v*` tag is pushed. It publishes a GitHub Release with the `.dmg`, `.pkg` and checksums attached, then updates `version` and `sha256` in the Homebrew cask in [webdunesurfer/homebrew-tap](https://github.com/webdunesurfer/homebrew-tap) (`Casks/exifbutcher.rb`). This needs the `HOMEBREW_TAP_TOKEN` repository secret: a fine-grained personal access token with **Contents: Read and write** on `homebrew-tap` only. When the token expires, create a new one and replace the secret.

To cut a release:
```bash
git tag v1.2.0
git push origin v1.2.0
```

## Code Signing
There is no Apple Developer ID, so the app is **ad-hoc signed** (`codesign -s -`) and not notarized. Ad-hoc signing seals the bundle, so Gatekeeper treats it as an app from an unidentified developer instead of reporting it as "damaged". If a Developer ID becomes available, add signing with `--options runtime`, `productsign` for the pkg, and `notarytool` + `stapler` to `scripts/package.sh`.

The `.pkg` is built with `BundleIsRelocatable = false`, so Installer always installs to `/Applications` and never "upgrades" a copy elsewhere on disk (the Finder Service only registers from `/Applications`).

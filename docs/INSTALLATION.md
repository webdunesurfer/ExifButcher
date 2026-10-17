# Installation Instructions

ExifButcher is distributed through [Homebrew](#homebrew-recommended) and [GitHub Releases](https://github.com/webdunesurfer/ExifButcher/releases). The app is **ad-hoc signed** but not notarized (there is no paid Apple Developer certificate), so macOS asks you to confirm before it opens it the first time.

## Homebrew (recommended)

Requires [Homebrew](https://brew.sh). Install ExifButcher with:

```bash
brew install --cask webdunesurfer/tap/exifbutcher
```

This adds the [webdunesurfer/tap](https://github.com/webdunesurfer/homebrew-tap) tap and installs the app into `/Applications`. The cask also clears the download quarantine, so macOS shows no Gatekeeper prompt. Next, continue with [Initializing the Finder Service](#initializing-the-finder-service).

| Task | Command |
|---|---|
| Update to the latest release | `brew upgrade --cask exifbutcher` |
| Show the installed and latest versions | `brew info --cask exifbutcher` |
| Uninstall | `brew uninstall --cask exifbutcher` |
| Uninstall and delete saved settings | `brew uninstall --cask --zap exifbutcher` |

### Switching from a manual install

Homebrew will not overwrite an app it did not install. If you previously installed ExifButcher from a `.dmg` or `.pkg`, quit it from the menu bar and remove it first. Your camera model settings are kept.

```bash
rm -rf /Applications/ExifButcher.app
brew install --cask webdunesurfer/tap/exifbutcher
```

Alternatively, `brew install --cask --force webdunesurfer/tap/exifbutcher` replaces the existing copy.

## Manual Installation

Download the latest release, then pick **one** of these:

- **`.pkg` installer (recommended):** Right-click `ExifButcher-<version>.pkg` → **Open** → **Open**. On macOS 15 and later, if no Open button appears, go to **System Settings > Privacy & Security** and click **Open Anyway**. The installer always places the app in `/Applications`, and apps installed this way are not quarantined, so the app itself opens without further prompts.
- **`.dmg` disk image:** Open `ExifButcher-<version>.dmg` and drag `ExifButcher.app` onto the `Applications` shortcut. On first launch, macOS will say it cannot verify the developer. Go to **System Settings > Privacy & Security** and click **Open Anyway** (on macOS 14 and earlier, right-click the app → **Open** also works).

The app must be in `/Applications`. *This is strictly required for the macOS Finder Service (right-click menu) to register successfully.*

You can check the download against `SHA256SUMS.txt` from the release:
```bash
shasum -a 256 -c SHA256SUMS.txt
```

## If macOS Still Blocks the App

As a last resort, remove the quarantine flag manually:

```bash
xattr -dr com.apple.quarantine /Applications/ExifButcher.app
```

## Initializing the Finder Service

macOS does not immediately recognize right-click context menu options (`NSServices`) until the app has been launched at least once.

1. Navigate to `/Applications` and double-click `ExifButcher.app`.
2. A camera icon (`📷`) will appear in your top right Menu Bar.
3. Click it to set your target camera (e.g., `X-S20`).
4. (Optional) You can now quit the app from the menu if you wish; the right-click Finder action will remain active in the background.

## Troubleshooting the Context Menu
If the "**📷 ExifButcher: Adjust RAWs EXIF**" option does not appear when you right-click a `.RAF` file:

1. Ensure the app is actually inside `/Applications`.
2. Open **System Settings > Keyboard > Keyboard Shortcuts > Services**. Look under "Files and Folders" and ensure `ExifButcher: Adjust RAWs EXIF` is checked.
3. Force macOS to flush and reload its services database by running this in Terminal:
   ```bash
   /System/Library/CoreServices/pbs -flush
   ```

## Troubleshooting Homebrew

- **`It seems there is already an App at '/Applications/ExifButcher.app'`**: see [Switching from a manual install](#switching-from-a-manual-install).
- **`brew upgrade` doesn't find a new version**: refresh Homebrew's copy of the tap with `brew update`, then try again.
- **`Cask 'webdunesurfer/tap/exifbutcher' is unavailable`** (from `brew info` and similar commands): add the tap first with `brew tap webdunesurfer/tap`. `brew install` adds it automatically.

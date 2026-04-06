# Installation Instructions

If you are downloading ExifButcher from the GitHub Actions artifacts, the app is **unsigned** (it is not tied to a paid Apple Developer Certificate). As a result, macOS Gatekeeper will aggressively block it.

## Step-by-Step Installation

1. **Download** the `ExifButcher-Installers.zip` from the latest GitHub Action run.
2. **Extract** the `.zip` file. You can choose to use the `.pkg` installer (which automatically places the app in `/Applications`) or mount the `.dmg` and drag the app manually.
3. Ensure `ExifButcher.app` is placed in your `/Applications` folder. *This is strictly required for the macOS Finder Service (right-click menu) to register successfully.*

## Bypassing macOS Gatekeeper ("App is Damaged" Error)

Because the app is unsigned, macOS adds a `com.apple.quarantine` extended attribute to the file when downloaded from the internet. When you try to open it, macOS will say the app is **damaged and should be moved to the Trash**.

**To fix this:**
Open your terminal and remove the quarantine flag using the `xattr` command:

```bash
xattr -cr /Applications/ExifButcher.app
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
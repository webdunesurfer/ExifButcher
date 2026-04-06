# Architecture Overview

ExifButcher is a native macOS application written in **Swift 5** using **SwiftUI** for the user interface. It acts as a lightweight GUI and system wrapper around the industry-standard command-line utility **ExifTool**.

## Core Components

1. **The UI (Menu Bar App)**
   - Managed by `ExifButcherApp.swift` and `ContentView.swift`.
   - The application does not show a standard window or a Dock icon (`LSUIElement: true` in `Info.plist`). 
   - It attaches exclusively to the macOS top Menu Bar using SwiftUI's `MenuBarExtra`.
   - Uses `@AppStorage` (`UserDefaults`) to persist the user's `OriginalCameraModel` and `TargetCameraModel` settings.

2. **The ExifTool Engine**
   - We do not rely on the user having ExifTool installed globally. Instead, we bundle the official macOS standalone package of ExifTool directly inside the app bundle (`Resources/exiftool`).
   - The wrapper logic lives in `ExifToolRunner.swift`.
   - **Crucial Execution Detail:** The bundled `exiftool` file is actually a Perl script. To avoid macOS App Sandbox and execution permission issues (Gatekeeper preventing direct execution of bundled scripts), `ExifToolRunner` uses `Process` to explicitly call `/usr/bin/perl` and passes the bundled `exiftool` path as its first argument.
   - Command structure used: `/usr/bin/perl /path/to/exiftool -if '$model eq {original}' -Model={target} -overwrite_original -r /path/to/target`.
   - Progress and errors are piped to macOS `UNUserNotificationCenter` for visual feedback.

3. **macOS Finder Integration (Services / Quick Actions)**
   - The app integrates into the Finder context menu (right-click -> Quick Actions / Services) without requiring a heavy Finder Sync Extension.
   - This is accomplished via the `NSServices` array defined in `Info.plist` (and generated via `project.yml`).
   - **Key Configuration:**
     - `NSMessage: processFolder` (This maps directly to an `@objc func processFolder` in `AppDelegate`).
     - `NSSendFileTypes: [public.item, public.folder, public.directory]` (Tells macOS to show this option when a user selects a generic file or folder).
     - `NSRequiredContext -> NSServiceCategory: public.item` (Required for modern macOS versions to categorize the service correctly).
     - The menu text is strictly string-based. Apple does not support `NSImage` keys for `NSServices`, so we prefix the text with a camera emoji `📷`.

## Concurrency
To prevent blocking the main UI thread (and the macOS Menu Bar) while processing massive directories of RAW files, `ExifToolRunner` is dispatched asynchronously onto a background thread using `DispatchQueue.global(qos: .userInitiated).async`. All UI updates and Notifications are pushed back to the main thread or handled by the system notification daemon.
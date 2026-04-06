# Project Context for LLM Agents

Welcome, fellow LLM! If you are reading this file, you have been instantiated to assist with the development, maintenance, or debugging of the **ExifButcher** macOS utility.

This repository contains specific macOS architectural decisions that you must be aware of to prevent breaking the build or the Finder integration.

## Documentation Index
Please read the following documents in the `docs/` folder to understand the current state of the project before making architectural changes or diagnosing issues:

1. **`docs/ARCHITECTURE.md`**: Explains the Menu Bar UI, the Perl-script ExifTool wrapper, and the exact requirements for `NSServices` (Finder Context Menu). Read this if you are touching `Info.plist`, `ExifToolRunner.swift`, or `ExifButcherApp.swift`.
2. **`docs/BUILD.md`**: Explains the `project.yml` XcodeGen setup and the GitHub Actions CI/CD pipeline.
3. **`docs/INSTALLATION.md`**: Explains the Gatekeeper quarantine bypass (`xattr`) and how the macOS Pasteboard Server registers the app.

## Critical Rules & Historical Context

- **Do Not Modify `Info.plist` Directly (Usually):** The project uses `xcodegen`. Settings should ideally be added to `project.yml`. However, be aware that a physical `Info.plist` is tracked in git. If `xcodegen generate` fails to overwrite the physical `Info.plist`, you must manually update the physical `Info.plist` to match your changes, or remove it from git tracking so `xcodegen` handles it dynamically.
- **NSServices Context Menu:** The Finder right-click integration is fragile.
  - The `@objc func processFolder` in `ExifButcherApp.swift` MUST have the exact signature: `(_ pboard: NSPasteboard, userData: String, error: AutoreleasingUnsafeMutablePointer<NSString>)`. Note that `userData` must be `String`, NOT `String?`.
  - In the `Info.plist` -> `NSServices` dictionary, we MUST use `NSSendFileTypes` (not `NSSendTypes`) to pass modern UTIs like `public.item`.
  - We do NOT use `NSImage` for the menu icon, as macOS Services do not support it. We prefix the `NSMenuItem` default string with a `📷` emoji.
- **ExifTool Execution:** The bundled `exiftool` is a Perl script. Do NOT execute it directly as a binary. You MUST instantiate `/usr/bin/perl` via `Process()` and pass the `exiftool` bundle path as an argument. Failure to do so will result in silent Sandbox/Gatekeeper execution blocks.
- **Code Signing:** The CI/CD pipeline builds the app *without* code signing (`CODE_SIGN_IDENTITY=""`). Do not enable `ENABLE_HARDENED_RUNTIME` in `project.yml` unless a valid Apple Developer Certificate is provided, otherwise the automated build will fail.
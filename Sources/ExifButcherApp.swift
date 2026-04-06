import SwiftUI
import UserNotifications

@main
struct ExifButcherApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        MenuBarExtra("ExifButcher", systemImage: "camera.filters") {
            ContentView()
        }
        .menuBarExtraStyle(.window)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.servicesProvider = self
        NSUpdateDynamicServices()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Notification authorization error: \(error.localizedDescription)")
            }
        }
    }
    
    @objc func processFolder(_ pboard: NSPasteboard, userData: String, error: AutoreleasingUnsafeMutablePointer<NSString>) {
        NSLog("ExifButcher: processFolder Service Triggered!")
        
        guard let types = pboard.types, types.contains(.fileURL),
              let urls = pboard.readObjects(forClasses: [NSURL.self], options: nil) as? [URL] else {
            NSLog("ExifButcher: No valid file URLs found on Pasteboard.")
            return
        }
        
        let targetModel = UserDefaults.standard.string(forKey: "TargetCameraModel") ?? ""
        let originalModel = UserDefaults.standard.string(forKey: "OriginalCameraModel") ?? ""
        
        NSLog("ExifButcher: Received \(urls.count) URLs. Target Model: '\(targetModel)'")
        
        let runner = ExifToolRunner()
        
        // Run in background so we don't block the main thread
        DispatchQueue.global(qos: .userInitiated).async {
            for url in urls {
                var isDirectory: ObjCBool = false
                if FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory), isDirectory.boolValue {
                    runner.processDirectory(url, originalModel: originalModel, targetModel: targetModel)
                } else {
                    runner.processFile(url, originalModel: originalModel, targetModel: targetModel)
                }
            }
        }
    }
}

import Foundation
import UserNotifications

class ExifToolRunner {
    var exifToolURL: URL? {
        return Bundle.main.url(forResource: "exiftool", withExtension: nil)
    }
    
    func processDirectory(_ url: URL, originalModel: String, targetModel: String) {
        guard let exifToolPath = exifToolURL?.path else {
            notifyUser(title: "Error", body: "ExifTool not found in app bundle.")
            return
        }
        
        let task = Process()
        task.executableURL = URL(fileURLWithPath: exifToolPath)
        
        var arguments: [String] = []
        if !originalModel.isEmpty {
            arguments.append("-if")
            arguments.append("$model eq '\(originalModel)'")
        }
        
        arguments.append("-Model=\(targetModel)")
        arguments.append("-overwrite_original")
        arguments.append("-r") // Recursive
        arguments.append(url.path)
        
        task.arguments = arguments
        
        do {
            try task.run()
            task.waitUntilExit()
            
            if task.terminationStatus == 0 {
                notifyUser(title: "Success", body: "Finished processing folder: \(url.lastPathComponent)")
            } else {
                notifyUser(title: "Warning", body: "ExifTool finished with non-zero status.")
            }
        } catch {
            notifyUser(title: "Error", body: "Failed to execute ExifTool: \(error.localizedDescription)")
        }
    }
    
    func processFile(_ url: URL, originalModel: String, targetModel: String) {
        guard let exifToolPath = exifToolURL?.path else {
            notifyUser(title: "Error", body: "ExifTool not found in app bundle.")
            return
        }
        
        let task = Process()
        task.executableURL = URL(fileURLWithPath: exifToolPath)
        
        var arguments: [String] = []
        if !originalModel.isEmpty {
            arguments.append("-if")
            arguments.append("$model eq '\(originalModel)'")
        }
        
        arguments.append("-Model=\(targetModel)")
        arguments.append("-overwrite_original")
        arguments.append(url.path)
        
        task.arguments = arguments
        
        do {
            try task.run()
            task.waitUntilExit()
            
            if task.terminationStatus == 0 {
                notifyUser(title: "Success", body: "Finished processing file: \(url.lastPathComponent)")
            } else {
                notifyUser(title: "Warning", body: "ExifTool finished with non-zero status.")
            }
        } catch {
            notifyUser(title: "Error", body: "Failed to execute ExifTool: \(error.localizedDescription)")
        }
    }
    
    private func notifyUser(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
}

import Foundation
import UserNotifications

class ExifToolRunner {
    var exifToolScriptURL: URL? {
        // The script is inside the exiftool directory in the bundle resources
        return Bundle.main.url(forResource: "exiftool", withExtension: nil, subdirectory: "exiftool") ?? Bundle.main.url(forResource: "exiftool", withExtension: nil)
    }
    
    func processDirectory(_ url: URL, originalModel: String, targetModel: String) {
        runExifTool(targetUrl: url, originalModel: originalModel, targetModel: targetModel, isRecursive: true)
    }
    
    func processFile(_ url: URL, originalModel: String, targetModel: String) {
        runExifTool(targetUrl: url, originalModel: originalModel, targetModel: targetModel, isRecursive: false)
    }
    
    private func runExifTool(targetUrl: URL, originalModel: String, targetModel: String, isRecursive: Bool) {
        guard !targetModel.isEmpty else {
            notifyUser(title: "Warning", body: "Please open ExifButcher app and set a Target Camera Model first.")
            return
        }
        
        guard let scriptPath = exifToolScriptURL?.path else {
            notifyUser(title: "Error", body: "ExifTool script not found in app bundle.")
            return
        }
        
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/perl")
        
        var arguments: [String] = [scriptPath]
        
        if !originalModel.isEmpty {
            arguments.append("-if")
            arguments.append("$model eq '\(originalModel)'")
        }
        
        arguments.append("-Model=\(targetModel)")
        arguments.append("-overwrite_original")
        
        if isRecursive {
            arguments.append("-r")
        }
        
        arguments.append(targetUrl.path)
        
        task.arguments = arguments
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        
        do {
            try task.run()
            task.waitUntilExit()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8) ?? ""
            
            if task.terminationStatus == 0 {
                notifyUser(title: "Success", body: "Finished: \(targetUrl.lastPathComponent)\n\(output.prefix(100))")
            } else {
                notifyUser(title: "Error", body: "Code: \(task.terminationStatus)\nOutput: \(output.prefix(100))")
            }
        } catch {
            notifyUser(title: "Execution Error", body: "Failed to run Perl: \(error.localizedDescription)")
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

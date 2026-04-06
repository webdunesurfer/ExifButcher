import SwiftUI

struct ContentView: View {
    @AppStorage("OriginalCameraModel") var originalModel: String = ""
    @AppStorage("TargetCameraModel") var targetModel: String = ""
    @State private var isProcessing = false
    @State private var progressMessage = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Adjust RAWs EXIF")
                .font(.headline)
            
            VStack(alignment: .leading) {
                Text("Original Camera Model (optional):")
                TextField("e.g. X-T30 III", text: $originalModel)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            VStack(alignment: .leading) {
                Text("Target Camera Model:")
                TextField("e.g. X-S20", text: $targetModel)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            Divider()
            
            HStack {
                Button("Select Folder to Process") {
                    selectFolder()
                }
                .disabled(isProcessing || targetModel.isEmpty)
                
                Spacer()
                
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
            }
            
            if isProcessing {
                HStack {
                    ProgressView()
                        .scaleEffect(0.5)
                    Text(progressMessage)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .frame(width: 300)
    }
    
    func selectFolder() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = true
        
        if panel.runModal() == .OK {
            isProcessing = true
            progressMessage = "Processing..."
            
            let runner = ExifToolRunner()
            DispatchQueue.global(qos: .userInitiated).async {
                for url in panel.urls {
                    runner.processDirectory(url, originalModel: originalModel, targetModel: targetModel)
                }
                
                DispatchQueue.main.async {
                    isProcessing = false
                    progressMessage = "Done!"
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        progressMessage = ""
                    }
                }
            }
        }
    }
}

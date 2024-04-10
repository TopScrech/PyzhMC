import SwiftUI

struct InstanceScreenshotsView: View {
    @StateObject var instance: Instance
    
    @FocusState var selectedItem: Screenshot?
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack {
            ScrollView {
                ZStack {
                    if instance.screenshots.count > 0 {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(instance.screenshots, id: \.self) { screenshot in
                                HStack {
                                    VStack {
                                        AsyncImage(url: screenshot.path, scale: 1) {
                                            $0.resizable().scaledToFit()
                                        } placeholder: {
                                            Image(systemName: "bolt")
                                                .resizable()
                                                .scaledToFit()
                                        }
                                        
                                        Text(screenshot.path.lastPathComponent)
                                            .footnote()
                                    }
                                    .padding(2)
                                    .focusable()
                                    .focused($selectedItem, equals: screenshot)
                                    .onCopyCommand {
                                        [NSItemProvider(contentsOf: screenshot.path)!]
                                    }
                                    .highPriorityGesture(
                                        TapGesture().onEnded { i in
                                            withAnimation(.linear(duration: 0.1)) {
                                                selectedItem = screenshot
                                            }
                                        }
                                    )
                                }
                            }
                        }
                    } else {
                        Text("No screenshots")
                            .largeTitle()
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            .cornerRadius(8)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.secondary, lineWidth: 1)
            }
            .background(Color(NSColor.textBackgroundColor))
            .padding(7)
            
            HStack {
                ScreenshotShareButton(selectedItem: selectedItem)
                    .disabled(selectedItem == nil)
                
//                Button("Open in Finder") {
//                    NSWorkspace.shared.selectFile(selectedItem?.path.path, inFileViewerRootedAtPath: instance.getScreenshotsFolder().path)
//                }
                
                Button("Open in Finder") {
                    let fileManager = FileManager.default
                    let folderPath = instance.getScreenshotsFolder().path
                    
                    // Check if the folder exists
                    if !fileManager.fileExists(atPath: folderPath) {
                        do {
                            // Attempt to create the folder
                            try fileManager.createDirectory(atPath: folderPath, withIntermediateDirectories: true, attributes: nil)
                            print("Folder created successfully.")
                        } catch {
                            // Handle potential error
                            print("Error creating folder: \(error.localizedDescription)")
                            return
                        }
                    }
                    
                    // Open the folder in Finder
                    NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: folderPath)
                }
            }
            .padding(.bottom, 8)
            .padding([.top, .leading, .trailing], 5)
        }
    }
}
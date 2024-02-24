# ContinuationCam
ContinuationCam aims to be a simple Swift package that allows computer vision tasks and to alleviate the boilerplate coming from AVFoundation.
It provides a camera module that uses an ```@escaping (CIImage) -> ()``` closure to feed the preview image stream into your computer vision tasks.

# Basic example:
```
import SwiftUI
import ContinuationCam

//ContentView that is displayed in the main app
struct ContentView: View {
    var body: some View {
        VisionView()
    }
}


//Example camera preview
struct VisionView: View {
    @StateObject private var provider = ContinuationCam()
    @State private var image: Image?
    
    var body: some View {
        GeometryReader { geometry in
            if let image = image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }.task { //Set closure here
            provider.continuation = {img in
                image = img.continuationImage
            }
        }
    }
}
```


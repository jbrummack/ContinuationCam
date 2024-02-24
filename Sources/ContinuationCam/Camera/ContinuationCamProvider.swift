//
//  ContinuationCamProvider.swift
//
//
//  Created by Julius Brummack on 24.02.24.
//

import Foundation
import AVFoundation
import SwiftUI
import Vision
import os.log

///Start the CameraVisionProvider via SwiftUI: *Your View*.task {*Your VisionProvider*.camera.start()}
final class ContinuationCam: ObservableObject {
    ///UIImage for simple access
    @Published var viewfinderImage: Image?
    let camera = Camera()
    ///CIImage for processing preview
    private var continuation: VoidT<CIImage>?
    
    func execute(_ task: @escaping VoidT<CIImage>) {
        self.continuation = task
    }
    ///If set the preview stops refreshing
    func pausePreview() {
        camera.isPreviewPaused = true
    }
    ///If set the preview continues
    func continuePreview() {
        camera.isPreviewPaused = false
    }
    

    init(_ continuation: VoidT<CIImage>?) {
        self.continuation = continuation
        Task {
            await camera.start()
            Task {
                await preview()
            }
            Task {
                await handleCameraPhotos()
            }
        }
    }
    init() {
        Task {
            await camera.start()
            Task {
                await preview()
            }
            Task {
                await handleCameraPhotos()
            }
        }
    }
    
    func preview() async {
        let imageStream = camera.previewStream

        for await image in imageStream {
            Task { @MainActor in
                viewfinderImage = image.continuationImage
            }
            if continuation != nil {
                continuation!(image)
            }
        }
    }
    
    func handleCameraPhotos() async {
        let unpackedPhotoStream = camera.photoStream
            .compactMap { self.unpackPhoto($0) }
        
        for await photoData in unpackedPhotoStream {
            Task { @MainActor in
                //Evaluate image stuff
                print("Taking Photos")
                //splitHiRes(for: photoData)
            }
        }
    }
    
    private func unpackPhoto(_ photo: AVCapturePhoto) -> Data? {
        guard let imageData = photo.fileDataRepresentation() else { return nil }

        return imageData
    }
    func handleCameraProcessing() async {
    }
    

}


extension CIImage {
    var continuationImage: Image? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else { return nil }
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }
}

fileprivate extension Image.Orientation {

    init(_ cgImageOrientation: CGImagePropertyOrientation) {
        switch cgImageOrientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        }
    }
}

fileprivate let logger = Logger(subsystem: "SwiftVisionCam", category: "DataModel")

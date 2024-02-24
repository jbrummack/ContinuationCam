//
//  BasicPreview.swift
//
//
//  Created by Julius Brummack on 24.02.24.
//

import Foundation
import SwiftUI

///Example for Preview
struct VisionViewTemplate: View {
    @StateObject private var provider = ContinuationCam(){_ in }
    @State private var rectImage: Image?
    
    var body: some View {
        GeometryReader { geometry in
            RealtimeView(image: $provider.viewfinderImage)
        }.overlay(){
            if let rectImage = rectImage {
                rectImage
                    .resizable()
                    .frame(width: 100, height: 100)
            }
        }
    }
}

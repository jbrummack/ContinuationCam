//
//  CameraView.swift
//
//
//  Created by Julius Brummack on 24.02.24.
//

import Foundation
import SwiftUI

struct RealtimeView: View {
    @Binding var image: Image?
    
    var body: some View {
        GeometryReader { geometry in
            if let image = image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}

#Preview {
    GeometryReader { geometry in
        Image(systemName: "viewfinder")
                .resizable()
                .frame(width: geometry.size.width, height: geometry.size.height)
        
    }
}
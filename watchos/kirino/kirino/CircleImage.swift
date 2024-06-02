//
//  CircleImage.swift
//  kirino
//
//  Created by 김현재 on 5/28/24.
//

import SwiftUI

struct CircleImage: View {
    var image: Image

    var body: some View {
        image
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: 2)
            }
            .shadow(radius: 7)
    }
}

#Preview {
    CircleImage(image: Image("Ganghoon"))
}

//
//  ContentView.swift
//  kirino
//
//  Created by 김현재 on 5/28/24.
//

import SwiftUI

struct ContentView: View {
    var message: Message?
    
    init(message: Message? = nil) {
        self.message = ModelData().messages[0]
    }

    var body: some View {
        VStack {
            if let message {
                CircleImage(image: message.image.resizable())
                    .scaledToFit()
            }
            Divider()
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView(
        message: ModelData().messages[0]
    )
}

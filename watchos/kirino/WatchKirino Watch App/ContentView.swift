//
//  ContentView.swift
//  WatchKirino Watch App
//
//  Created by 김현재 on 5/29/24.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    var message: Message?
    
    init(message: Message? = nil) {
        self.message = ModelData().messages[0]
    }
    
    var body: some View {
        VStack {
            DetailView()
        }
        .padding()
//        .task {
//            let center = UNUserNotificationCenter.current()
//            _ = try? await center.requestAuthorization(
//                options: [.alert, .sound, .badge]
//            )
//        }
    }
}

#Preview {
    ContentView()
        .environment(ModelData())
}

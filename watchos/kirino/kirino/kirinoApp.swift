//
//  kirinoApp.swift
//  kirino
//
//  Created by 김현재 on 5/28/24.
//

import SwiftUI

@main
struct kirinoApp: App {
    @State private var modelData = ModelData()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(modelData)
        }

        #if os(watchOS)
        WKNotificationScene(controller: NotificationController.self, category: "MessageReceived")
        WKNotificationScene(controller: ResponseController.self, category: "ResponseReceived")
        #endif
    }
}

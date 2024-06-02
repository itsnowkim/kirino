//
//  WatchKirinoApp.swift
//  WatchKirino Watch App
//
//  Created by 김현재 on 5/30/24.
//
import SwiftUI
import UserNotifications
import WatchKit

@main
struct WatchKirinoApp: App {
    @WKExtensionDelegateAdaptor(ExtensionDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(delegate.deviceTokenModel)
                .task {
                    let center = UNUserNotificationCenter.current()
                    _ = try? await center.requestAuthorization(
                        options: [.alert, .sound, .badge]
                    )
                }
        }
        WKNotificationScene(controller: NotificationController.self, category: "MessageReceived")
        WKNotificationScene(controller: ResponseController.self, category: "ResponseReceived")
    }
}

#Preview {
    WatchKirinoApp() as! any View
}

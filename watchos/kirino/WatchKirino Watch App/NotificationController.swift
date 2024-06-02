//
//  NotificationController.swift
//  WatchKirino Watch App
//
//  Created by 김현재 on 5/30/24.
//

import Foundation
import WatchKit
import SwiftUI
import UserNotifications

// incomming notification store values
class NotificationController: WKUserNotificationHostingController<NotificationView>{
    var name: String?
    var detail: String?
    var message: Message?
//    var sound: String?
    
    let messageIndexKey = "messageIndex"
    
    override var body: NotificationView{
        NotificationView(
            name: name,
            detail: detail,
            message: message
        )
    }
    
    override class var isInteractive: Bool {
        return true
    }
    
    override func didReceive(_ notification: UNNotification) {
        let modelData = ModelData()

        let notificationData = notification.request.content.userInfo as? [String: Any]
        print("content : ",notification.request.content)

        let aps = notificationData?["aps"] as? [String: Any]
        let alert = aps?["alert"] as? [String: Any]

        name = alert?["title"] as? String
        detail = alert?["body"] as? String
//        sound = alert?["sound"] as? String
//        print("sound", sound)

        if let index = notificationData?[messageIndexKey] as? Int {
            message = modelData.messages[index]
        }
    }
}

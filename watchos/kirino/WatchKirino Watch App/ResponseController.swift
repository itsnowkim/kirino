//
//  ResponseController.swift
//  WatchKirino Watch App
//
//  Created by 김현재 on 5/30/24.
//
import Foundation
import WatchKit
import SwiftUI
import UserNotifications

// incomming notification store values
class ResponseController: WKUserNotificationHostingController<ResponseNotificationView>{
    var name: String?
    var detail: [String]?
    var response: String?
    var message: Message?
    
    let messageIndexKey = "messageIndex"
    
    override var body: ResponseNotificationView{
        ResponseNotificationView(
            name: name,
            detail: detail,
            message: message,
            response: response
        )
    }
    
    override class var isInteractive: Bool {
        return true
    }
    
    override func didReceive(_ notification: UNNotification) {
        let modelData = ModelData()

        let notificationData =
            notification.request.content.userInfo as? [String: Any]

        let aps = notificationData?["aps"] as? [String: Any]
        let alert = aps?["alert"] as? [String: Any]

        name = alert?["title"] as? String
        detail = alert?["body"] as? [String]
        response = alert?["subtitle"] as? String

        if let index = notificationData?[messageIndexKey] as? Int {
            message = modelData.messages[index]
        }
    }
}

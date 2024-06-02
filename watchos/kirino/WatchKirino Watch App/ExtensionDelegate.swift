//
//  ExtensionDelegate.swift
//  WatchKirino Watch App
//
//  Created by 김현재 on 5/31/24.
//

import WatchKit
import UserNotifications
import Firebase
import FirebaseMessaging

class ExtensionDelegate: NSObject, WKExtensionDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    var deviceTokenModel = DeviceTokenModel()

    func applicationDidFinishLaunching() {
        print("launched\n")
        // Firebase 초기화
        FirebaseApp.configure()
        
        
        // 푸시 알림 권한 요청
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    WKExtension.shared().registerForRemoteNotifications()
                    self.setupNotificationActions()
                }
            } else {
                print("Notification permission denied.")
            }
        }
        
        UNUserNotificationCenter.current().delegate = self
        
        Messaging.messaging().delegate = self
    }
    
    func setupNotificationActions() {
        // 메시지 받을 때 액션 생성
        let okAction = UNNotificationAction(identifier: "Ok", title: "답변 생성하기", options: [])
        // 답변 전송하라는 액션 생성
        let okSend = UNNotificationAction(identifier: "Send", title: "이대로 전송하기", options: [])
        
        // 카테고리 생성
        let myCategory = UNNotificationCategory(identifier: "MessageReceived", actions: [okAction], intentIdentifiers: [], options: [])
        let myCategory2 = UNNotificationCategory(identifier: "ResponseReceived", actions: [okSend], intentIdentifiers: [], options: [])
        
        // 카테고리 등록
        UNUserNotificationCenter.current().setNotificationCategories([myCategory, myCategory2])
    }

    func didRegisterForRemoteNotifications(withDeviceToken deviceToken: Data) {
        print("didRegisterForRemoteNotifications\n")
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        
        // 여기서 디바이스 토큰을 업데이트합니다
        deviceTokenModel.updateDeviceToken(token)
        
        // device token Messaging 등록
        Messaging.messaging().apnsToken = deviceToken
        
        // 여기서 디바이스 토큰을 서버에 전달하여 저장
//        sendDeviceTokenToServer(token)
    }

    func didFailToRegisterForRemoteNotificationsWithError(_ error: Error) {
        print("Failed to register: \(error.localizedDescription)")
    }
    
    // UNUserNotificationCenterDelegate 메서드 구현
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        WKInterfaceDevice.current().play(.click)
        completionHandler([.list, .sound, .badge, .banner])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "Ok":
            // kirino 에게 답변 생성하라고 전송하기
            // get 으로 서버에 요청
            print("Ok action tapped")
        case "Send":
            // 이대로 보내라고 전송하기
            print("Send action tapped")
        default:
            break
        }
        completionHandler()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("SUCCESS: Firebase registration token received!")
        // fcmToken이 nil이 아니라면 그 값을 사용하고, nil이라면 빈 문자열을 사용
        let tokenString = fcmToken ?? "fcm token lost"
        print(tokenString)
        
        deviceTokenModel.updateFcmToken(tokenString)
        UserDefaults.standard.set(fcmToken, forKey: "fcmToken")
        
        sendPostRequest(deviceToken: deviceTokenModel.deviceToken, fcmToken: tokenString)
    }
    
    // send to server
    func sendPostRequest(deviceToken: String, fcmToken: String) {
        let store = [
            "deviceToken": deviceToken,
            "fcmToken": fcmToken
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: store, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            guard let url = URL(string: "http://54.252.213.174:443/token") else {
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    // 네트워킹 에러 확인
                    print("Networking error: \(String(describing: error))")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    // HTTP 에러 확인
                    print("Status code should be 200, but is \(httpStatus.statusCode)")
                    print("Response: \(String(describing: response))")
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        print("Response JSON: \(json)")
                    }
                } catch let error {
                    print("JSON parsing error: \(error.localizedDescription)")
                }
            }
            task.resume()
        } catch {
            print("JSON serialization error: \(error.localizedDescription)")
        }
    }
    
}

//
//  DetailView.swift
//  WatchKirino Watch App
//
//  Created by 김현재 on 5/30/24.
//

import SwiftUI
import WatchKit

import Foundation
import Combine

class DeviceTokenModel: ObservableObject {
    @Published var deviceToken: String = ""
    @Published var fcmToken: String = ""
    
    func updateDeviceToken(_ token: String) {
        DispatchQueue.main.async {
            self.deviceToken = token
        }
    }

    func updateFcmToken(_ token: String) {
        DispatchQueue.main.async {
            self.fcmToken = token
        }
    }
}

struct DetailView: View {
    @EnvironmentObject var deviceTokenModel: DeviceTokenModel
    @State private var responseText: String = ""
    @State private var responseToken: String = ""

    var body: some View {
        ScrollView {
            Button(action:{
                sendGetRequest()
            }){
                Text("서버 확인")
                    .font(.headline)
            }
            Text(responseText)
                .padding()
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            
            Text("Device Token: \(deviceTokenModel.deviceToken)")
                .font(.caption)
                .padding()
                .lineLimit(nil) // 줄 제한 없음
                .frame(maxWidth: .infinity, alignment: .trailing)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
            
            Text("FCM Token: \(deviceTokenModel.fcmToken)")
                .font(.caption)
                .padding()
                .lineLimit(nil) // 줄 제한 없음
                .frame(maxWidth: .infinity, alignment: .trailing)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
            
//            Button(action:{
//                sendPostRequest(deviceToken: deviceTokenModel.deviceToken, fcmToken: deviceTokenModel.fcmToken)
//            }){
//                Text("전송하기")
//                    .font(.headline)
//            }
//            Text(responseToken)
//                .padding()
//                .font(.caption)
//                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
    }
    
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
    
    func sendGetRequest() {
        guard let url = URL(string: "http://54.252.213.174:443") else {
            print("Invalid URL")
            return
        }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("dataTaskWithURL fail: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.responseText = "Request failed: \(error.localizedDescription)"
                }
                return
            }
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Response Data: \(responseString)")
                DispatchQueue.main.async {
                    self.responseText = responseString
                }
            }
        }
        
        task.resume()
    }
}

#Preview {
    DetailView()
}

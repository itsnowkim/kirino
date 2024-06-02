//
//  NotificationView.swift
//  WatchKirino Watch App
//
//  Created by 김현재 on 5/30/24.
//

import SwiftUI

struct NotificationView: View {
    var name: String?
    var detail: String?
    var message: Message?

    var body: some View {
        NavigationView {
            VStack {
                HStack{
                    if let message {
                        CircleImage(image: message.image.resizable())
                            .scaledToFit()
                    }
                    Text(name ?? "Unknown Sender")
                        .font(.headline)
                        .padding(10)
                    Spacer()

                }
                
                Divider()

                Text(detail ?? "새로운 메시지가 있습니다.")
                    .font(.caption)
//                
//                Spacer()
//                
//                Button {
//                    // Button 누르면 Backend 로 답변 생성하라고 보냄
//                    print("pressed button")
//                } label: {
//                    Text("답변 생성하기")
//                    .font(.headline)
//                    .foregroundColor(.blue)
//
//                }
            }
        }
    }
}


#Preview {
    NotificationView()
}


#Preview {
    NotificationView(
        name: "김강훈",
        detail: "오늘 저녁에 이수역에서 삼겹살 어때?",
        message: ModelData().messages[0]
    )
}

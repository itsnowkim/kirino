//
//  ResponseNotificationView.swift
//  WatchKirino Watch App
//
//  Created by 김현재 on 5/30/24.
//

import SwiftUI

struct ResponseNotificationView: View {
    var name: String?
    var detail: [String]?
    var message: Message?
    var response: String?

    var body: some View {
        
        VStack {
            HStack{
                if let message {
                    CircleImage(image: message.image.resizable())
                        .frame(width: 50, height: 50)
//                            .scaledToFit()
                }
                Text(name ?? "Unknown Sender")
                    .font(.headline)
                    .padding(10)
                Spacer()

            }
            
            Divider()

            Group {
                if let detail = detail {
                    ForEach(detail, id: \.self) { msg in
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.2)) // 투명한 배경
                                Text(msg)
                                    .font(.caption)
                                    .padding()
                                    .lineLimit(nil) // 줄 제한 없음
                                    .multilineTextAlignment(.leading) // 왼쪽 정렬
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            Spacer()
                        }
                    }
                } else {
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.2)) // 투명한 배경
                            Text("새로운 메시지가 있습니다.")
                                .font(.caption)
                                .padding()
                                .lineLimit(nil) // 줄 제한 없음
                                .multilineTextAlignment(.leading) // 왼쪽 정렬
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        Spacer()
                    }
                }
            }
            .padding(3)
            
            Divider()
            
            Text("KIRINO 의 추천메시지")
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.8)) // 투명한 배경
                    Text(response ?? "좋아좋아! 좋아좋아! 좋아좋아! 좋아좋아! 좋아좋아!")
                        .font(.caption)
                        .padding()
                        .lineLimit(nil) // 줄 제한 없음
                        .multilineTextAlignment(.trailing) // 오른쪽 정렬
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
            }
            
//            Button {
//                // Button 누르면 Backend 로 이대로 답변 보내라고 함
//                print("pressed button")
//            } label: {
//                Text("이대로 답변 보내기")
//                .font(.headline)
//                .foregroundColor(.blue)
//            }
        }
    }
    
}


#Preview {
    ResponseNotificationView()
}

#Preview {
    ResponseNotificationView(
        name: "김강훈",
        detail: ["오늘 저녁에 이수역에서 삼겹살 어때?", "아니면 치킨으로 가자"],
        message: ModelData().messages[0]
    )
}

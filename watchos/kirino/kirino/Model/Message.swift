//
//  Message.swift
//  kirino
//
//  Created by 김현재 on 5/28/24.
//

import Foundation
import SwiftUI
import CoreLocation

struct Message: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var description: String
//    var recieved_time: Date
    
    private var imageName: String
    var image: Image {
        Image(imageName)
    }
}

//
//  LoungeRequestBodyModel.swift
//  My
//
//  Created by Prof K on 6/30/22.
//

import Foundation

struct LoungeRequestBodyModel: Codable {
    let lounge_name: String
    let host_id: String
    let topics: [String]
    let live_recording: Bool
}

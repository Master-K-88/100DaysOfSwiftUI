/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Lounge : Codable {
	let lounge_id : String?
	let lounge_name : String?
	let start_time : String?
	let dolby_voice : Bool?
	let live_recording : Bool?
	let host : Host?
	let speakers : [String]?
	let participants : [String]?
	let topics : [Topics]?
	let tags : [String]?
	let play_count : Int?
	let is_private : Bool?
	let is_featured : Bool?
	let external_id : String?
	let _id : String?
	let createdAt : String?
	let updatedAt : String?
	let __v : Int?

	enum CodingKeys: String, CodingKey {

		case lounge_id = "lounge_id"
		case lounge_name = "lounge_name"
		case start_time = "start_time"
		case dolby_voice = "dolby_voice"
		case live_recording = "live_recording"
		case host = "host"
		case speakers = "speakers"
		case participants = "participants"
		case topics = "topics"
		case tags = "tags"
		case play_count = "play_count"
		case is_private = "is_private"
		case is_featured = "is_featured"
		case external_id = "external_id"
		case _id = "_id"
		case createdAt = "createdAt"
		case updatedAt = "updatedAt"
		case __v = "__v"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		lounge_id = try values.decodeIfPresent(String.self, forKey: .lounge_id)
		lounge_name = try values.decodeIfPresent(String.self, forKey: .lounge_name)
		start_time = try values.decodeIfPresent(String.self, forKey: .start_time)
		dolby_voice = try values.decodeIfPresent(Bool.self, forKey: .dolby_voice)
		live_recording = try values.decodeIfPresent(Bool.self, forKey: .live_recording)
		host = try values.decodeIfPresent(Host.self, forKey: .host)
		speakers = try values.decodeIfPresent([String].self, forKey: .speakers)
		participants = try values.decodeIfPresent([String].self, forKey: .participants)
		topics = try values.decodeIfPresent([Topics].self, forKey: .topics)
		tags = try values.decodeIfPresent([String].self, forKey: .tags)
		play_count = try values.decodeIfPresent(Int.self, forKey: .play_count)
		is_private = try values.decodeIfPresent(Bool.self, forKey: .is_private)
		is_featured = try values.decodeIfPresent(Bool.self, forKey: .is_featured)
		external_id = try values.decodeIfPresent(String.self, forKey: .external_id)
		_id = try values.decodeIfPresent(String.self, forKey: ._id)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
		__v = try values.decodeIfPresent(Int.self, forKey: .__v)
	}

}
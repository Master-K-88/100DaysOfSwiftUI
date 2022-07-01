/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Topics : Codable {
	let image : Image?
	let _id : String?
	let name : String?
	let content : String?
	let slug : String?
	let topicID : String?
	let createdAt : String?
	let updatedAt : String?
	let __v : Int?

	enum CodingKeys: String, CodingKey {

		case image = "image"
		case _id = "_id"
		case name = "name"
		case content = "content"
		case slug = "slug"
		case topicID = "topicID"
		case createdAt = "createdAt"
		case updatedAt = "updatedAt"
		case __v = "__v"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		image = try values.decodeIfPresent(Image.self, forKey: .image)
		_id = try values.decodeIfPresent(String.self, forKey: ._id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		content = try values.decodeIfPresent(String.self, forKey: .content)
		slug = try values.decodeIfPresent(String.self, forKey: .slug)
		topicID = try values.decodeIfPresent(String.self, forKey: .topicID)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
		__v = try values.decodeIfPresent(Int.self, forKey: .__v)
	}

}
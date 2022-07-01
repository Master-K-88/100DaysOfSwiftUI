/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Selected : Codable {
	let _id : Int?
	let username : Int?
	let avatar : Int?
	let is_creator : Int?
	let login_token : Int?
	let is_activated : Int?
	let wallet_id : Int?
	let user_roles : Int?
	let is_premium_member : Int?

	enum CodingKeys: String, CodingKey {

		case _id = "_id"
		case username = "username"
		case avatar = "avatar"
		case is_creator = "is_creator"
		case login_token = "login_token"
		case is_activated = "is_activated"
		case wallet_id = "wallet_id"
		case user_roles = "user_roles"
		case is_premium_member = "is_premium_member"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		_id = try values.decodeIfPresent(Int.self, forKey: ._id)
		username = try values.decodeIfPresent(Int.self, forKey: .username)
		avatar = try values.decodeIfPresent(Int.self, forKey: .avatar)
		is_creator = try values.decodeIfPresent(Int.self, forKey: .is_creator)
		login_token = try values.decodeIfPresent(Int.self, forKey: .login_token)
		is_activated = try values.decodeIfPresent(Int.self, forKey: .is_activated)
		wallet_id = try values.decodeIfPresent(Int.self, forKey: .wallet_id)
		user_roles = try values.decodeIfPresent(Int.self, forKey: .user_roles)
		is_premium_member = try values.decodeIfPresent(Int.self, forKey: .is_premium_member)
	}

}
/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct _doc : Codable {
	let login_token : Login_token?
	let user_roles : [String]?
	let _id : String?
	let is_premium_member : Bool?
	let is_activated : Bool?
	let is_creator : Bool?
	let username : String?
	let avatar : String?
	let wallet_id : String?

	enum CodingKeys: String, CodingKey {

		case login_token = "login_token"
		case user_roles = "user_roles"
		case _id = "_id"
		case is_premium_member = "is_premium_member"
		case is_activated = "is_activated"
		case is_creator = "is_creator"
		case username = "username"
		case avatar = "avatar"
		case wallet_id = "wallet_id"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		login_token = try values.decodeIfPresent(Login_token.self, forKey: .login_token)
		user_roles = try values.decodeIfPresent([String].self, forKey: .user_roles)
		_id = try values.decodeIfPresent(String.self, forKey: ._id)
		is_premium_member = try values.decodeIfPresent(Bool.self, forKey: .is_premium_member)
		is_activated = try values.decodeIfPresent(Bool.self, forKey: .is_activated)
		is_creator = try values.decodeIfPresent(Bool.self, forKey: .is_creator)
		username = try values.decodeIfPresent(String.self, forKey: .username)
		avatar = try values.decodeIfPresent(String.self, forKey: .avatar)
		wallet_id = try values.decodeIfPresent(String.self, forKey: .wallet_id)
	}

}
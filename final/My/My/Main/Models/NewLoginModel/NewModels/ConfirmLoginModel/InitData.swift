/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct InitData : Codable {
	let _id : Bool?
	let is_premium_member : Bool?
	let is_activated : Bool?
	let is_creator : Bool?
	let username : Bool?
	let avatar : Bool?
	let wallet_id : Bool?
	let login_token_token : Bool?
	let login_token_expires : Bool?
	let login_token_active : Bool?
	let login_token_attempts : Bool?

	enum CodingKeys: String, CodingKey {

		case _id = "_id"
		case is_premium_member = "is_premium_member"
		case is_activated = "is_activated"
		case is_creator = "is_creator"
		case username = "username"
		case avatar = "avatar"
		case wallet_id = "wallet_id"
		case login_token_token = "login_token.token"
		case login_token_expires = "login_token.expires"
		case login_token_active = "login_token.active"
		case login_token_attempts = "login_token.attempts"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		_id = try values.decodeIfPresent(Bool.self, forKey: ._id)
		is_premium_member = try values.decodeIfPresent(Bool.self, forKey: .is_premium_member)
		is_activated = try values.decodeIfPresent(Bool.self, forKey: .is_activated)
		is_creator = try values.decodeIfPresent(Bool.self, forKey: .is_creator)
		username = try values.decodeIfPresent(Bool.self, forKey: .username)
		avatar = try values.decodeIfPresent(Bool.self, forKey: .avatar)
		wallet_id = try values.decodeIfPresent(Bool.self, forKey: .wallet_id)
		login_token_token = try values.decodeIfPresent(Bool.self, forKey: .login_token_token)
		login_token_expires = try values.decodeIfPresent(Bool.self, forKey: .login_token_expires)
		login_token_active = try values.decodeIfPresent(Bool.self, forKey: .login_token_active)
		login_token_attempts = try values.decodeIfPresent(Bool.self, forKey: .login_token_attempts)
	}

}

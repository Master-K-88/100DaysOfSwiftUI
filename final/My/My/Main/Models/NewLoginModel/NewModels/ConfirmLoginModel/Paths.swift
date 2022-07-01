/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Paths : Codable {
	let hashedSecret : String?
	let wallet_id : String?
	let username : String?
	let is_premium_member : String?
	let is_activated : String?
	let is_creator : String?
	let user_roles : String?
	let login_token_token : String?
	let login_token_method : String?
	let login_token_active : String?
	let _id : String?
	let avatar : String?
	let login_token_expires : String?
	let login_token_attempts : String?

	enum CodingKeys: String, CodingKey {

		case hashedSecret = "hashedSecret"
		case wallet_id = "wallet_id"
		case username = "username"
		case is_premium_member = "is_premium_member"
		case is_activated = "is_activated"
		case is_creator = "is_creator"
		case user_roles = "user_roles"
		case login_token_token = "login_token.token"
		case login_token_method = "login_token.method"
		case login_token_active = "login_token.active"
		case _id = "_id"
		case avatar = "avatar"
		case login_token_expires = "login_token.expires"
		case login_token_attempts = "login_token.attempts"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		hashedSecret = try values.decodeIfPresent(String.self, forKey: .hashedSecret)
		wallet_id = try values.decodeIfPresent(String.self, forKey: .wallet_id)
		username = try values.decodeIfPresent(String.self, forKey: .username)
		is_premium_member = try values.decodeIfPresent(String.self, forKey: .is_premium_member)
		is_activated = try values.decodeIfPresent(String.self, forKey: .is_activated)
		is_creator = try values.decodeIfPresent(String.self, forKey: .is_creator)
		user_roles = try values.decodeIfPresent(String.self, forKey: .user_roles)
		login_token_token = try values.decodeIfPresent(String.self, forKey: .login_token_token)
		login_token_method = try values.decodeIfPresent(String.self, forKey: .login_token_method)
		login_token_active = try values.decodeIfPresent(String.self, forKey: .login_token_active)
		_id = try values.decodeIfPresent(String.self, forKey: ._id)
		avatar = try values.decodeIfPresent(String.self, forKey: .avatar)
		login_token_expires = try values.decodeIfPresent(String.self, forKey: .login_token_expires)
		login_token_attempts = try values.decodeIfPresent(String.self, forKey: .login_token_attempts)
	}

}

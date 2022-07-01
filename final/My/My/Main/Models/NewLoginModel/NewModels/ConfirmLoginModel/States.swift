/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct States : Codable {
//	let ignore : Ignore?
	let defaultData : Default?
	let initData : InitData?
//	let modify : Modify?
	let require : Require?

	enum CodingKeys: String, CodingKey {

//		case ignore = "ignore"
		case defaultData = "default"
		case initData = "init"
//		case modify = "modify"
		case require = "require"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
//		ignore = try values.decodeIfPresent(Ignore.self, forKey: .ignore)
        defaultData = try values.decodeIfPresent(Default.self, forKey: .defaultData)
        initData = try values.decodeIfPresent(InitData.self, forKey: .initData)
//		modify = try values.decodeIfPresent(Modify.self, forKey: .modify)
		require = try values.decodeIfPresent(Require.self, forKey: .require)
	}

}

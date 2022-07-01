/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Uknown : Codable {
	let activePaths : ActivePaths?
	let skipId : Bool?
	let strictMode : Bool?
	let selected : Selected?
	let fields : Fields?
	let exclude : Bool?
	let getters : Getters?
	let nestedPath : String?

	enum CodingKeys: String, CodingKey {

		case activePaths = "activePaths"
		case skipId = "skipId"
		case strictMode = "strictMode"
		case selected = "selected"
		case fields = "fields"
		case exclude = "exclude"
		case getters = "getters"
		case nestedPath = "nestedPath"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		activePaths = try values.decodeIfPresent(ActivePaths.self, forKey: .activePaths)
		skipId = try values.decodeIfPresent(Bool.self, forKey: .skipId)
		strictMode = try values.decodeIfPresent(Bool.self, forKey: .strictMode)
		selected = try values.decodeIfPresent(Selected.self, forKey: .selected)
		fields = try values.decodeIfPresent(Fields.self, forKey: .fields)
		exclude = try values.decodeIfPresent(Bool.self, forKey: .exclude)
		getters = try values.decodeIfPresent(Getters.self, forKey: .getters)
		nestedPath = try values.decodeIfPresent(String.self, forKey: .nestedPath)
	}

}

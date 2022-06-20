import Cocoa

let newArray: [Int]? = nil

func randomInt(newArray: [Int]?) -> Int {
    newArray?.randomElement() ?? Int.random(in: 1...100)
}

print(randomInt(newArray: newArray))

import Cocoa

//var greeting = "Hello, playground"
let luckyNumbers = [7, 4, 38, 21, 16, 15, 12, 33, 31, 49]

let result = luckyNumbers.sorted().filter { newNum in
    !newNum.isMultiple(of: 2)
}.map { newVal -> Int in
    print("\(newVal) is a lucky number")
    return newVal
}

print("\(result)")

let secondResult = luckyNumbers.filter { num in
    !num.isMultiple(of: 2)
}.sorted().map { num -> Int in
    print("\(num) is a lucky number")
    return num
}

print(secondResult)

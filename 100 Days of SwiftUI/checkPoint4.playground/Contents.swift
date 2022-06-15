import Cocoa

//var greeting = "Hello, playground"
enum SquareRootError: Error {
    case negativeNumber, tooLargeNumber, noRootError
}

func squareRoot (_ number: Int) throws -> Int {
    if number < 0 {
        throw SquareRootError.negativeNumber
    }
    if number > 10_000 {
        throw SquareRootError.tooLargeNumber
    }
    
    for i in 1...100 {
        if i * i == number {
            return i
        }
    }
    throw SquareRootError.noRootError
}
do {
    let result = try squareRoot(10000)
    print("The result is \(result)")
} catch SquareRootError.tooLargeNumber {
    print("The number is out of range")
} catch SquareRootError.negativeNumber {
    print("You can only find the square root of positive number")
} catch SquareRootError.noRootError {
    print("There is no integer root for this value")
}

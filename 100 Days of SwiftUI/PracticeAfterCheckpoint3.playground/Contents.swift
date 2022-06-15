import Cocoa

//var greeting = "Hello, playground"

func checkStringIdentical(stringA: String, stringB: String) -> Bool {
    stringA.sorted() == stringB.sorted()
}

func pythagoras(a: Double, b: Double) -> Double {
    sqrt((a*a) + (b*b))
}
checkStringIdentical(stringA: "cab", stringB: "bac")
pythagoras(a: 3, b: 4)

enum passwordError: Error {
    case short, obvious
}


func checkPassword(_ password: String) throws -> String {
    if password.count < 5 { throw passwordError.short }
    if password == "12345" { throw passwordError.obvious }
    if password.count < 8 {
        return "ok"
    } else if password.count < 10 {
        return "Good"
    } else {
        return "Excellent"
    }
}
let password = "12345"
//print(try? checkPassword("12387654456745") )
do {
    let result = try checkPassword(password)
    print("Password rating \(result)")
} catch passwordError.short {
    print("The password is short")
} catch passwordError.obvious {
    print("The password is too obvious")
}

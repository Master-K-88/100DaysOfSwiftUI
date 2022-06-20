import Cocoa

//var greeting = "Hello, playground"

func greetUser() -> String{
    print("Hello User")
    return "Thanks everyone"
}

var greetCopyUser = greetUser
var greetNumberUser = { (name: String) -> String in
    return ("\(name)")
//    return 5
}

print(greetCopyUser())
let korede = greetNumberUser("Korede")
let zion = greetNumberUser("Zion")
let daniel = greetNumberUser("Daniel")

print("\(korede) is \(zion)'s dad")

let userData: (Int) -> String = { (id: Int) -> String in
    if id == 1988 {
        return "Korede"
    } else {
        return "Anonymous"
    }
}

print(userData(1988))

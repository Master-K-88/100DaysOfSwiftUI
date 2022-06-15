import Cocoa

var greeting = "Hello, playground"

let students = ["Doyin", "Koyinsola", "Benjamin", "Mofola", "Sulaimon", "David", "Doyin"]
print("The number of students is: \(students.count)")
let studentSet = Set(students)
print("There are \(studentSet.count) unique items")
var studentDict: [String: Int] = [:]
for item in studentSet {
    var counter = 0
    for newItem in students {
        if item == newItem {
            counter += 1
        }
    }
    studentDict[item] = counter
}
print(studentDict)

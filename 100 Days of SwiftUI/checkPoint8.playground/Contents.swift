import Cocoa

protocol Building{
    var numRoom: Int { get }
    var costOfRoom: Int { get set}
    var nameOfManager: String { get }
    
    func salesSummary()
    
}

extension Building {
    func salesSummary() {
        print("The cost of a room is \(costOfRoom) and there are \(numRoom) room and the manager name is \(nameOfManager)")
    }
}

struct House: Building {
    var numRoom: Int
    
    var costOfRoom: Int
    
    var nameOfManager: String
    
    
    
    
}

struct Office: Building {
    var numRoom: Int
    
    var costOfRoom: Int
    
    var nameOfManager: String
        
}
let officeRoom = Office(numRoom: 5, costOfRoom: 500, nameOfManager: "John")
officeRoom.salesSummary()

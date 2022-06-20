import Cocoa

//var greeting = "Hello, playground"

struct Car {
    let model: String
    let numSeat: Int
    private (set) var currentGear: Int
    
    
    mutating func changeGearUp() {
        if currentGear != 11 {
            print(currentGear)
            currentGear += 1
            
        }
        
    }
    
    mutating func changeGearDown() {
        if currentGear != 1 {
            currentGear -= 1
            print(currentGear)
        }
    }
}

var newCar = Car(model: "SG987", numSeat: 6, currentGear: 1)
for _ in 0...20 {
    newCar.changeGearUp()
}

for _ in 0...20 {
    newCar.changeGearDown()
}

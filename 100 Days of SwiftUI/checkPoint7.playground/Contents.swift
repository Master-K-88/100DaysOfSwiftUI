import Cocoa

class Animal {
    var leg: Int
    
    init(leg: Int) {
        self.leg = leg
    }
    
}

class Dog: Animal {
    func speak() {
//        print("Woof woof")
    }
}

class Corgi: Dog {
    override func speak() {
        print("Corgi bark Woof Woof")
    }
}

class Poodle: Dog {
    override func speak() {
        print("Poodle bark Woooof Wooooof")
    }
}

class Cat: Animal {
    var isTamed: Bool
    
    init(isTamed: Bool, leg: Int) {
        self.isTamed = isTamed
        super.init(leg: leg)
    }
    func speak() {
        print("Meow Meow")
    }
}

class Persian: Cat {
    override func speak() {
        print("I am persian and can't speak fluently")
    }
}

class Lion: Cat {
    override func speak() {
        print("I am Lion cat with a sound of Roar")
    }
}

let catLion = Lion(isTamed: false, leg: 4)
print(catLion.isTamed)
catLion.speak()
print(catLion.isTamed)
print(catLion.leg)

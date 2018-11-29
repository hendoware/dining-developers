    import Cocoa
    
    var lock = NSLock()
    
    class Spoon {
        
        var isHeld: Bool = false
        
        var x: Int?
        
        init(n: Int) {
            x = n
        }
        
        func pickUp() {
            lock.lock()
            if !isHeld {
                isHeld = true
                print("Spoon \(x) was picked up")
                lock.unlock()
                return
            } else {
                pickUp()
            }
        }
        
        func putDown() {
            isHeld = false
            print("Spoon \(x) was put down")
            
        }
        
        
    }
    
    class Developer {
        var leftSpoon: Spoon?
        var rightSpoon: Spoon?
        var x: Int
        
        var heldLeftSpoon = false
        var heldRightSpoon = false
        
        
        
        init(n: Int) {
            x = n
        }
        
        func think() {
            var numberOfSpoon = 0
            let lhs = leftSpoon?.x
            let rhs = rightSpoon?.x
            
            while !heldLeftSpoon || !heldRightSpoon {
                if numberOfSpoon == 0 {
                    if lhs! < rhs! {
                        leftSpoon?.pickUp()
                        heldLeftSpoon = true
                        numberOfSpoon += 1
                    } else if rhs! < lhs! {
                        rightSpoon?.pickUp()
                        heldRightSpoon = true
                        numberOfSpoon += 1
                    }
                    
                } else {
                    if !heldLeftSpoon {
                        leftSpoon?.pickUp()
                        heldLeftSpoon = true
                    } else if !heldRightSpoon {
                        rightSpoon?.pickUp()
                        heldRightSpoon = true
                    }
                }
                print("thinking")
            }
        }
        
        func eat() {
            let rand = Int.random(in: 100...1000)
            usleep(useconds_t(rand))
            leftSpoon!.putDown()
            rightSpoon!.putDown()
            print("eating done")
        }
        
        
        func run() {
            print("developer number: \(x)")
            if !done() {
                print("not done")
            }
            print("dev #\(x)")
            repeat {
                think()
                print("dev #\(x) thinking...")
                eat()
                print("dev #\(x) eating...")
            } while true
        }
        
        func done() -> Bool {
            if leftSpoon != nil &&
                rightSpoon != nil &&
                !heldRightSpoon &&
                !heldLeftSpoon {
                return true
            }
            return false
        }
        
    }
    
    var spoons: [Spoon] = []
    var devs: [Developer] = []
    
    func setup(number: Int) {
        reset()
        let finalSpoon = Spoon(n: number)
        spoons.insert(finalSpoon, at: 0)
        
        let firstDeveloper = Developer(n: 1)
        let leftSpoon = Spoon(n: 1)
        firstDeveloper.leftSpoon = leftSpoon
        firstDeveloper.rightSpoon = finalSpoon
        
        spoons.insert(leftSpoon, at: 0)
        devs.append(firstDeveloper)
        
        for n in 2..<number {
            let dev = Developer(n: n)
            let newSpoon = Spoon(n: n)
            dev.leftSpoon = newSpoon
            dev.rightSpoon = spoons[0]
            spoons.insert(newSpoon, at: 0)
            devs.append(dev)
        }
        
        let finalDeveloper = Developer(n: number)
        finalDeveloper.leftSpoon = finalSpoon
        finalDeveloper.rightSpoon = spoons[0]
        devs.append(finalDeveloper)
        
    }
    
    func reset() {
        spoons = []
        devs = []
    }
    
    func display() {
        var devNum: [Int] = []
        for n in devs {
            devNum.append(n.x)
        }
        
        var spoonNum: [Int] = []
        for spoon in spoons {
            spoonNum.append(spoon.x!)
        }
        
        print("Devs:\(devNum). Spoons: \(spoonNum)")
        print("Multi-Thread" )
    }
    
    setup(number: 5)
    display()
    
    DispatchQueue.concurrentPerform(iterations: 5) { (i) in
        devs[i].run()
    }
    
    

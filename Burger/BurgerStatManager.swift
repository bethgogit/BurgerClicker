//
//  BurgerStatManager.swift
//  Burger
//
//  Created by Lab3student on 2024-03-02.
//

import UIKit

class BurgerStatManager: Codable {
    public static var bsm: BurgerStatManager!
    
    private var totalBurgerCount: Int
    private var burgerCount: Int
    private var balance: Double
    private var foodstuff: Int
    private var level: Int
    private var unitSize: Int
    private var cost: Double
    private var stuffPerBurger: Int
    private var price: Double
    
    private enum CodingKeys: String, CodingKey {
        case totalBurgerCount
        case burgerCount
        case balance
        case foodstuff
        case level
        case unitSize
        case cost
        case stuffPerBurger
        case price
    }
    
    init() {
        totalBurgerCount = 0
        burgerCount = 0
        balance = 0.0
        foodstuff = 100
        level = 0

        unitSize = 12
        cost = 0.65
        stuffPerBurger = 1
        price = 1.0
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalBurgerCount = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSNumber.self, from: try container.decode(Data.self, forKey: .totalBurgerCount))! as! Int
        burgerCount = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSNumber.self, from: try container.decode(Data.self, forKey: .burgerCount))! as! Int
        balance = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSNumber.self, from: try container.decode(Data.self, forKey: .balance))! as! Double
        foodstuff = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSNumber.self, from: try container.decode(Data.self, forKey: .foodstuff))! as! Int
        level = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSNumber.self, from: try container.decode(Data.self, forKey: .level))! as! Int
        unitSize = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSNumber.self, from: try container.decode(Data.self, forKey: .unitSize))! as! Int
        cost = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSNumber.self, from: try container.decode(Data.self, forKey: .cost))! as! Double
        stuffPerBurger = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSNumber.self, from: try container.decode(Data.self, forKey: .stuffPerBurger))! as! Int
        price = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSNumber.self, from: try container.decode(Data.self, forKey: .price))! as! Double

    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(try NSKeyedArchiver.archivedData(withRootObject: totalBurgerCount, requiringSecureCoding: false), forKey: .totalBurgerCount)
        try container.encode(try NSKeyedArchiver.archivedData(withRootObject: burgerCount, requiringSecureCoding: false), forKey: .burgerCount)
        try container.encode(try NSKeyedArchiver.archivedData(withRootObject: balance, requiringSecureCoding: false), forKey: .balance)
        try container.encode(try NSKeyedArchiver.archivedData(withRootObject: foodstuff, requiringSecureCoding: false), forKey: .foodstuff)
        try container.encode(try NSKeyedArchiver.archivedData(withRootObject: level, requiringSecureCoding: false), forKey: .level)
        try container.encode(try NSKeyedArchiver.archivedData(withRootObject: unitSize, requiringSecureCoding: false), forKey: .unitSize)
        try container.encode(try NSKeyedArchiver.archivedData(withRootObject: cost, requiringSecureCoding: false), forKey: .cost)
        try container.encode(try NSKeyedArchiver.archivedData(withRootObject: stuffPerBurger, requiringSecureCoding: false), forKey: .stuffPerBurger)
        try container.encode(try NSKeyedArchiver.archivedData(withRootObject: price, requiringSecureCoding: false), forKey: .price)

    }
    
    static func resetBSM() throws {
        bsm = BurgerStatManager()
        try saveBSM()
    }
    
    static func loadBSM() throws {
        let documents = try FileManager.default.url(for: .documentDirectory,
                                                in: .userDomainMask,
                                                appropriateFor: nil,
                                                create: false)
        let file = documents.appendingPathComponent("burger")
        let decoder = JSONDecoder()
        bsm = try decoder.decode(BurgerStatManager.self, from: Data(contentsOf: file))
    }

    static func saveBSM() throws {
        let documents = try FileManager.default.url(for: .documentDirectory,
                                                in: .userDomainMask,
                                                appropriateFor: nil,
                                                create: false)
        let file = documents.appendingPathComponent("burger")
        let encoder = JSONEncoder()
        let collectionData = try encoder.encode(bsm)
        try collectionData.write(to: file)
    }
    
    static func initDefaultBSM() {
        bsm = BurgerStatManager()
    }
    
    static func makeBurgers(_ count:Int) -> Bool {
        if (bsm.foodstuff >= count*bsm.stuffPerBurger) {
            //make things
            bsm.burgerCount += count
            bsm.totalBurgerCount += count
            //subtract things
            bsm.foodstuff -= bsm.stuffPerBurger*count
            return true
        }
        return false
    }
    
    static func buyBurger(_ count:Int) -> Bool {
        if (bsm.burgerCount >= count) {
            bsm.burgerCount -= count
            bsm.balance += bsm.price*Double(count)
            return true
        }
        return false
    }
    
    static func canAffordFoodstuffs(_ count:Int) -> Bool {
        return bsm.balance >= Double(count*bsm.unitSize)*bsm.cost
    }
    
    static func buyFoodstuffs(_ count:Int) -> Bool {
        if (canAffordFoodstuffs(count)) {
            bsm.balance -= bsm.cost*Double(count*bsm.unitSize)
            bsm.foodstuff += count*bsm.unitSize
            return true
        }
        return false
    }
    
    static func getBurgerCount() -> Int {
        return bsm.burgerCount
    }
    
    static func getTotalBurgerCount() -> Int {
        return bsm.totalBurgerCount
    }
    
    static func getBalance() -> Double {
        return bsm.balance
    }
    
    static func getFoodstuffCount() -> Int {
        return bsm.foodstuff
    }
    
    static func getLevel() -> Int {
        return bsm.level
    }
    
    static func addBalance(_ value: Double) {
        bsm.balance += value
    }
    
    static func incLevel() {
        bsm.level += 1
        
        bsm.cost *= 1.125
        bsm.stuffPerBurger = 1+bsm.level/5
        bsm.price *= 2
    }
    
    static func canAfford(_ value:Double) -> Bool {
        return bsm.balance >= value
    }
}

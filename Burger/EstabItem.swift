//
//  EstabItem.swift
//  Burger
//
//  Created by Lab3student on 2024-03-02.
//

import UIKit

class EstabItem: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case nameKey
        case typeKey
    }
    
    
    var name: String?
    var type: Int! //0 = producer, 1 = supplier
    var timer: Timer!
    
    init() {
        type = 0
        name = nameFromType()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if (self.type==0) {
                BurgerStatManager.makeBurgers(1)
            } else {
                BurgerStatManager.buyFoodstuffs(1)
            }
        }
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSString.self, from: try container.decode(Data.self, forKey: .nameKey))! as String
        type = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSNumber.self, from: try container.decode(Data.self, forKey: .typeKey))! as? Int

    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(try NSKeyedArchiver.archivedData(withRootObject: name, requiringSecureCoding: false), forKey: .nameKey)
        try container.encode(try NSKeyedArchiver.archivedData(withRootObject: type, requiringSecureCoding: false), forKey: .typeKey)

    }
    
    func invalidate() {
        timer.invalidate() 
    }
    
    func nameFromType() -> String {
        return type==0 ? "Producer":"Supplier"
    }
}

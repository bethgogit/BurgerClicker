//
//  EstabItemStore.swift
//  Burger
//
//  Created by Lab3student on 2024-03-02.
//

import UIKit

class EstabItemStore {
    static var items = [EstabItem]()

    static func getCount() -> Int {
        return items.count
    }
    
    static func addItem() {
        items.append(EstabItem())
    }
    
    static func resetItems() throws {
        items = [EstabItem]()
        try saveItems()
    }
    
    static func saveItems() throws {
        let documents = try FileManager.default.url(for: .documentDirectory,
                                                in: .userDomainMask,
                                                appropriateFor: nil,
                                                create: false)
        let file = documents.appendingPathComponent("burger1")
        let encoder = JSONEncoder()
        let collectionData = try encoder.encode(items)
        try collectionData.write(to: file)
    }
    
    static func loadItems() throws  {
        let documents = try FileManager.default.url(for: .documentDirectory,
                                                in: .userDomainMask,
                                                appropriateFor: nil,
                                                create: false)
        let file = documents.appendingPathComponent("burger1")
        let decoder = JSONDecoder()
        items = try decoder.decode([EstabItem].self, from: Data(contentsOf: file))
    }
}

//
//  ScheduledBuyer.swift
//  Burger
//
//  Created by Lab3student on 2024-04-05.
//

import UIKit

class ScheduledBuyer {
    static var duration:Double!
    private static var timer:Timer!
    
    static func start() {
        if (!UserDefaults.standard.bool(forKey:"buyerDuration")) {
            resetBuyers()
        } else {
            duration = UserDefaults.standard.double(forKey: "buyerDuration")
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: true) { _ in
            if BurgerStatManager.buyBurger(Int.random(in: 1...2)) {
                //https://stackoverflow.com/questions/38964083/swift-notifying-a-viewcontroller-from-another-using-completion-handler
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ligma"), object: nil)
            }
        }
    }
    
    static func resetBuyers() {
        duration = 1.5
        UserDefaults.standard.set(duration, forKey: "buyerDuration")
        UserDefaults.standard.synchronize()
    }
    
    static func makeBuyersFaster() {
        duration *= 0.75
        UserDefaults.standard.set(duration, forKey: "buyerDuration")
        UserDefaults.standard.synchronize()
        timer.invalidate()
        start()
    }
}

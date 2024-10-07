//
//  BurgerTabBarController.swift
//  Burger
//
//  Created by Lab3student on 2024-03-02.
//

import UIKit

class BurgerTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //tikka masala
        do {
            try BurgerStatManager.loadBSM()
        } catch {
            BurgerStatManager.initDefaultBSM()
        }
        do {
            try EstabItemStore.saveItems()
        } catch {
            
        }
        
        ScheduledBuyer.start()
        
        //autosave
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            do {
                try BurgerStatManager.saveBSM()
            } catch {
                
            }
        }
        
        //hardcode hide tabs
        //tabBar.items![1].isEnabled = false
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

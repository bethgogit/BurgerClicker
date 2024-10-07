//
//  MainBurgerControllerViewController.swift
//  Burger
//
//  Created by Lab3student on 2024-03-01.
//

import UIKit

class MainBurgerViewController: UIViewController {
    
    @IBOutlet weak var burgerCountLabel: UILabel!
    @IBOutlet weak var burgerTotalLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var foodstuffLabel: UILabel!
    @IBOutlet weak var buyFoodstuffsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //lazy way to show foodstuff button when affordable
        let concurrentQueue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)
        concurrentQueue.async {
            while !BurgerStatManager.canAffordFoodstuffs(1) {
                
            }
            DispatchQueue.main.async {
                self.buyFoodstuffsButton.isHidden = false
            }
        }

        NotificationCenter.default.addObserver(self, selector: #selector(onLigma), name: Notification.Name("ligma"), object: nil)
    }
    
    @objc func onLigma (notification: NSNotification){
        updateStats()
    }
    
    func updateStats() {
        //update stats
        burgerCountLabel.text = "\(BurgerStatManager.getBurgerCount()) burgers in stock."
        burgerTotalLabel.text = "\(BurgerStatManager.getTotalBurgerCount()) burgers produced total."
        balanceLabel.text = "$\(BurgerStatManager.getBalance())"
        foodstuffLabel.text = "\(BurgerStatManager.getFoodstuffCount()) foodstuffs left."
        
        buyFoodstuffsButton.isEnabled = BurgerStatManager.canAffordFoodstuffs(1)
    }
    
    @IBAction func onCreateBurger(_ button:UIButton!) {
        if (BurgerStatManager.makeBurgers(1)) {
            updateStats()
        }
    }
    
    @IBAction func onBuyFoodstuffs(_ sender: UIButton) {
        if (BurgerStatManager.buyFoodstuffs(1)) {
            updateStats()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onReset(_ sender: Any) {
        let controller = UIAlertController(title: "Alert", message: "This button wipes all saves. Are you sure you want to do this?", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "yeah", style: .destructive) {_ in
            do {
                try BurgerStatManager.resetBSM()
                try EstabItemStore.resetItems()
                ScheduledBuyer.resetBuyers()
                self.buyFoodstuffsButton.isHidden = true
                let controller1 = UIAlertController(title: "Success", message: "Successfully reset!", preferredStyle: .alert)
                controller1.addAction(UIAlertAction(title: "oh ok", style: .default))
                self.present(controller1, animated: true, completion: {
                    self.updateStats()
                })
            } catch {
                let controller1 = UIAlertController(title: "Error", message: "Somehow, the reset failed.", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "oh ok", style: .default))
                self.present(controller1, animated: true)
            }
        })
        controller.addAction(UIAlertAction(title: "nope", style: .default))
        present(controller, animated: true)
    }
}

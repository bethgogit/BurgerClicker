//
//  UpgradeBurgerViewController.swift
//  Burger
//
//  Created by Lab3student on 2024-04-06.
//

import UIKit

class UpgradeBurgerViewController: UIViewController, URLSessionDelegate {
    var prefixes: [String]?
    
    @IBOutlet weak var currentBurgerInfoLabel: UILabel!
    @IBOutlet weak var nextBurgerInfoLabel: UILabel!
    @IBOutlet weak var burgerUpgradeButton: UIButton!
    @IBOutlet weak var balanceLabel: UILabel!
    
    @IBOutlet weak var marketingUpgradeButton: UIButton!

    @IBOutlet weak var establishmentButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //define burger prefixes if they don't exist
        //found an API for getting word synonyms and figured that would be a better way to incorporate web requests
        prefixes = ["good"] //THIS SHOULD ONLY HAVE ONE ELEMENT WHEN DEFINED
        let urlString = "https://api.datamuse.com/words?ml=\(prefixes![0])"
        let url = NSURL(string: urlString)! as URL
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration:config)
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { data, response, error in
            let decoder = JSONDecoder()
            let responses = try! decoder.decode([WordResponse].self, from: data!)
            
            //append only the adjectives
            for word in responses {
                if (word.tags.contains("adj") && word.tags.contains("syn")) {
                    self.prefixes!.append(word.word)
                }
            }
            
            //list is garunteed to have at least 2 elements so do UI here
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
        task.resume()
        
        //subscribe for balance updates
        NotificationCenter.default.addObserver(self, selector: #selector(onLigma), name: Notification.Name("ligma"), object: nil)
    }
    
    @objc func onLigma (notification: NSNotification){
        updateUI()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUI()
    }
    
    func updateUI() {
        let burgerLevel = BurgerStatManager.getLevel()
        if prefixes != nil && prefixes!.count>1 {
            currentBurgerInfoLabel.text = "Current Burger: The \(prefixes![burgerLevel]) burger"
            nextBurgerInfoLabel.text = "Next Burger: The \(prefixes![burgerLevel+1]) burger"
        }
        
        balanceLabel.text = "Balance: $\(BurgerStatManager.getBalance())"
        burgerUpgradeButton.setTitle("Upgrade for $\(burgerUpgradePrice())", for: .normal)
        burgerUpgradeButton.isEnabled = BurgerStatManager.canAfford(burgerUpgradePrice())
        
        marketingUpgradeButton.setTitle("Upgrade for $\(marketingUpgradePrice())", for: .normal)
        marketingUpgradeButton.isEnabled = BurgerStatManager.canAfford(marketingUpgradePrice())
        
        establishmentButton.setTitle("Buy for $\(establishmentPrice())", for: .normal)
        establishmentButton.isEnabled = BurgerStatManager.canAfford(establishmentPrice())
    }
    
    func burgerUpgradePrice() -> Double {
        return 50*(NSDecimalNumber(decimal:pow(2,BurgerStatManager.getLevel())) as! Double)
    }

    @IBAction func onBurgerUpgrade(_ sender: UIButton) {
        if (BurgerStatManager.canAfford(burgerUpgradePrice())) {
            BurgerStatManager.addBalance(-burgerUpgradePrice())
            BurgerStatManager.incLevel()
            updateUI()
        }
    }
    
    func marketingUpgradePrice() -> Double {
        return 37.5/ScheduledBuyer.duration
    }
    
    func establishmentPrice() -> Double {
        return 50*Double(EstabItemStore.getCount()+1)
    }

    @IBAction func onMarketingUpgrade(_ sender: UIButton) {
        if (BurgerStatManager.canAfford(marketingUpgradePrice())) {
            BurgerStatManager.addBalance(-marketingUpgradePrice())
            ScheduledBuyer.makeBuyersFaster()
            updateUI()
        }
    }
    
    
    @IBAction func onEstablishmentBuy(_ sender: UIButton) {
        if (BurgerStatManager.canAfford(establishmentPrice())) {
            BurgerStatManager.addBalance(-establishmentPrice())
            EstabItemStore.addItem()
            updateUI()
        }
    }
}

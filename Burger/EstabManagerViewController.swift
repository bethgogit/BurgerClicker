//
//  EstabManagerViewController.swift
//  Burger
//
//  Created by Lab3student on 2024-04-06.
//

import UIKit

class EstabManagerViewController: UIViewController {
    
    var item:EstabItem!
    @IBOutlet weak var estabTypeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabel()
        
        // Do any additional setup after loading the view.
    }
    
    func updateLabel() {
        estabTypeLabel.text = "Establishment type: \(item.nameFromType())"
    }

    @IBAction func onToggle(_ sender: UISwitch) {
        item.type = sender.isOn ? 1:0
        updateLabel()
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

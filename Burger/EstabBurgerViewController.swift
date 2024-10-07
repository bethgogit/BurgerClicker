//
//  EstabBurgerViewController.swift
//  Burger
//
//  Created by Lab3student on 2024-03-02.
//

import UIKit

class EstabCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
}

class EstabBurgerViewController: UITableViewController {
    
    var itemStore: EstabItemStore!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destController = segue.destination as! EstabManagerViewController
        destController.item = sender! as? EstabItem
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        applyTableFilters()
    }
    
    func applyTableFilters() {
        //reload data
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EstabItemStore.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sugma", for: indexPath) as! EstabCell
        let item = EstabItemStore.items[indexPath.row]
        cell.name.text = item.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "estabSegue", sender: EstabItemStore.items[indexPath.row])
    }

}

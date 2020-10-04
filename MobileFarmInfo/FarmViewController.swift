//
//  FarmViewController.swift
//  MobileFarmInfo
//
//  Created by PJ Gray on 10/3/20.
//

import UIKit

class FarmViewController: UIViewController {

    enum CellTypes {
        case header, token1, token2, totalStaked, rewards, apy, staked, earnings
    }
    
    let cells : [CellTypes] = [
        .header
    ]
    
    let pools : [Pool] = [
        Pool(name: "Pair name")
    ]
    
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Pools"
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

extension FarmViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cells.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let pool = self.pools[section]
        return pool.name
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
//        let pool = self.pools[indexPath.section]
        
        switch self.cells[indexPath.row] {
        case .header:
            cell.textLabel?.text = "header"
        default:
            print("unknown")
        }
                
        return cell
    }
}


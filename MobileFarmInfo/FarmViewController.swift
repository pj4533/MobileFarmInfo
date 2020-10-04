//
//  FarmViewController.swift
//  MobileFarmInfo
//
//  Created by PJ Gray on 10/3/20.
//

import UIKit

import Web3
import Web3ContractABI

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
    
    var datasource : PoolDataSource?
    
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.datasource?.getPoolCount(withSuccess: { (poolCount) in
            DispatchQueue.main.async {
                self.title = "\(poolCount) Pools"
                self.tableview.reloadData()
            }
        }, failure: { (error) in
            print(error?.localizedDescription ?? "Unknown error")
        })
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

        
        // from here use token address to get info based on the type -- in pickle the first one is LP token
        // so uniswap type. I can use infura and pass the UNI ABI, but I think I could also query direct to
        // uniswaps API. but maybe I'll need to use the ABI for other types? not sure how to tell the different pool types
        // apart?
        //
        // also may want to precache this stuff so I dont do a ton of calls to Infura?
        self.datasource?.getTokenAddress(forPoolIndex: indexPath.section, withSuccess: { (address) in
            print(address.hex(eip55: false))
        }, failure: { (error) in
            print(error?.localizedDescription ?? "Unknown error")
        })
        
        
        switch self.cells[indexPath.row] {
        case .header:
            cell.textLabel?.text = "header"
        default:
            print("unknown")
        }
                
        return cell
    }
}


//
//  FarmViewController.swift
//  MobileFarmInfo
//
//  Created by PJ Gray on 10/3/20.
//

import UIKit

import Web3
import Web3ContractABI
import Web3PromiseKit

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

        // hardcoded pickle chef for now
        let datasource = EtherscanDataSource()
        datasource.getABI(address: "0xbD17B1ce622d73bD438b9E658acA5996dc394b0d") { (jsonABIData) in
            
            do {
                let web3 = Web3(rpcURL: "https://mainnet.infura.io/v3/\(Secrets().infuraProjectId)")

                let contractAddress = try EthereumAddress(hex: "0xbD17B1ce622d73bD438b9E658acA5996dc394b0d", eip55: true)
                if let contractJsonABI = jsonABIData {
                    // You can optionally pass an abiKey param if the actual abi is nested and not the top level element of the json
                    let contract = try web3.eth.Contract(json: contractJsonABI, abiKey: nil, address: contractAddress)
                    firstly {
                        contract["poolLength"]!().call()
                    }.done { outputs in
                        self.title = "\(outputs.values.first ?? 0) Pools"
                    }.catch { error in
                        print(error)
                    }
                    
                }
            } catch let error {
                print(error.localizedDescription)
            }

            
        } failure: { (error) in
            print(error?.localizedDescription ?? "Unknown error")
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


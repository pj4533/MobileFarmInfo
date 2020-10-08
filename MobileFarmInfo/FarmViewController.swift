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
        case header, token0, token1, totalStaked, rewards, apy, staked, earnings
    }

    var ethPrice : Double?
    var cells : [[CellTypes]] = []
    
    var pools : [Pool] = []
    
    var datasource : PoolDataSource?
    
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cgDataSource = CoinGeckoDataSource()
        cgDataSource.getETHPrice { (ethPrice) in
            self.ethPrice = ethPrice
            self.datasource?.getPoolCount(withSuccess: { (poolCount) in
                DispatchQueue.main.async {
                    self.title = "\(poolCount) Pools"
                }
                
                let group = DispatchGroup()
                
                // should loop thru, doing 1 for now
                for i in 0...5 {//Int(poolCount) {
                    group.enter()
                    self.datasource?.getTokenAddress(forPoolIndex: i, withSuccess: { (address) in
                        group.leave()
                        let pairAddress = address.hex(eip55: false)
                        let uniswapDataSource = UniswapDataSource()
                        group.enter()
                        uniswapDataSource.getPair(address: pairAddress) { (pair) in
                            group.leave()
                            if let pair = pair {
                                var pool = pair.getPool()
                                
                                print("Loading: \(pairAddress)")
                                group.enter()
                                uniswapDataSource.getToken(address: pairAddress) { (lpToken) in
                                    print(lpToken)
                                    pool.lpToken = lpToken

                                    var cellsForPool : [CellTypes] = [ .header ]

                                    if pool.token0 != nil { cellsForPool.append(.token0) }
                                    if pool.token1 != nil { cellsForPool.append(.token1) }
                                    
                                    // leaving this out for now, stuck on getting this number right
    //                                cellsForPool.append(.totalStaked)

                                    self.cells.append(cellsForPool)
                                    self.pools.append(pool)
                                    group.leave()
                                } failure: { (error) in
                                    print(error?.localizedDescription ?? "Unknown error")
                                }
                            }
                        } failure: { (error) in
                            print(error?.localizedDescription ?? "Unknown error")
                        }
                    }, failure: { (error) in
                        print(error?.localizedDescription ?? "Unknown error")
                    })
                }

                group.notify(queue: DispatchQueue.main) {
                    self.tableview.reloadData()
                }

                
            }, failure: { (error) in
                print(error?.localizedDescription ?? "Unknown error")
            })
        } failure: { (error) in
            print(error?.localizedDescription ?? "Unknown coin gecko error")
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.cells.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cells[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let pool = self.pools[section]
        return pool.name
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let pool = self.pools[indexPath.section]
        let cellsForPool = self.cells[indexPath.section]
        
        // from here use token address to get info based on the type -- in pickle the first one is LP token
        // so uniswap type. I can use infura and pass the UNI ABI, but I think I could also query direct to
        // uniswaps API. but maybe I'll need to use the ABI for other types? not sure how to tell the different pool types
        // apart?
        //
        // also may want to precache this stuff so I dont do a ton of calls to Infura?
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        switch cellsForPool[indexPath.row] {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: "subtitleCell", for: indexPath)
            cell.textLabel?.text = "UNI Price: \(currencyFormatter.string(from: NSNumber(value: pool.price)) ?? "$0")"
            cell.detailTextLabel?.text = "TVL: \(currencyFormatter.string(from: NSNumber(value: pool.tvl)) ?? "$0")"
            return cell
        case .token0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            cell.textLabel?.text = "\(pool.token0?.symbol ?? "?") Price: \(currencyFormatter.string(from: NSNumber(value: pool.token0?.usdMarketPrice(withEtherPrice: self.ethPrice ?? 0) ?? 0)) ?? "$0")"
            return cell
        case .token1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "\(pool.token1?.symbol ?? "?") Price: \(currencyFormatter.string(from: NSNumber(value: pool.token1?.usdMarketPrice(withEtherPrice: self.ethPrice ?? 0) ?? 0)) ?? "$0")"
            return cell
        case .totalStaked:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            self.datasource?.getTotalStaked(forToken: pool.lpToken, withSuccess: { (totalStaked) in
                cell.textLabel?.text = "Staked: \(currencyFormatter.string(from: NSNumber(value: totalStaked)) ?? "$0")"
            }, failure: nil)
            return cell
        default:
            print("unknown")
        }
                
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
}


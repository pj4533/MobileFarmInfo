//
//  PickleDataSource.swift
//  MobileFarmInfo
//
//  Created by PJ Gray on 10/4/20.
//

import Foundation
import Web3
import Web3ContractABI

class PickleDataSource : ABIDataSource, PoolDataSource {
    private var chefAddress = "0xbD17B1ce622d73bD438b9E658acA5996dc394b0d"
    
    func loadABI(withSuccess success: (() -> Void)?, failure: ((Error?) -> Void)?) {
        super.loadABI(forAddress: self.chefAddress, withSuccess: success, failure: failure)
    }
    
    func getPoolCount(withSuccess success: ((BigUInt) -> Void)?, failure: ((Error?) -> Void)?) {
        self.contract?["poolLength"]?().call(completion: { (response, error) in
            if let error = error {
                failure?(error)
            } else {
                if let poolCount = response?.values.first as? BigUInt {
                    success?(poolCount)
                } else {
                    failure?(NSError(domain: "Return type incorrect", code: -1, userInfo: nil))
                }
            }
        })
    }
    
    func getTokenAddress(forPoolIndex poolIndex: Int, withSuccess success: ((EthereumAddress) -> Void)?, failure: ((Error?) -> Void)?) {
        self.contract?["poolInfo"]?(poolIndex).call(completion: { (response, error) in
            if let error = error {
                failure?(error)
            } else {
                if let address = response?["lpToken"] as? EthereumAddress {
                    success?(address)
                } else {
                    failure?(NSError(domain: "Token error", code: -1, userInfo: nil))
                }
            }
        })
    }

    func getRewardTokenAddress(withSuccess success: ((_ address: EthereumAddress) -> Void)?, failure: ((Error?) -> Void)?) {
        self.contract?["pickle"]?().call(completion: { (response, error) in
            if let error = error {
                failure?(error)
            } else {
                if let address = response?.values.first as? EthereumAddress {
                    success?(address)
                } else {
                    failure?(NSError(domain: "Token error", code: -1, userInfo: nil))
                }
            }
        })
    }

    // stuck on this
    func getTotalStaked(forToken token: Token?, withSuccess success: ((_ totalStaked: Double) -> Void)?, failure: ((Error?) -> Void)?) {
        self.getRewardTokenAddress(withSuccess: { (address) in
            do {
                let contract = self.web3.eth.Contract(type: GenericERC20Contract.self, address: address)
                contract.balanceOf(address: try EthereumAddress(hex: self.chefAddress, eip55: true)).call(completion: { (response, error) in
                    if let error = error {
                        print(error)
                        failure?(error)
                    } else {
                        do {
                            if let balance = response?["_balance"] as? BigUInt {
                                
                                let staked = try Double((balance / (10^BigUInt(token?.decimals ?? "0"))))
                                print(staked * 152.50)
                            }

                        } catch let error {
                            failure?(error)
                        }
        //                if let address = response?["lpToken"] as? EthereumAddress {
        //                    success?(address)
        //                } else {
        //                    failure?(NSError(domain: "Token error", code: -1, userInfo: nil))
        //                }
                    }
                })
            } catch let error {
                failure?(error)
            }
        }, failure: failure)
    }

}

//
//  ABIDataSource.swift
//  MobileFarmInfo
//
//  Created by PJ Gray on 10/4/20.
//

import Foundation
import Web3
import Web3ContractABI

class ABIDataSource {
    private var jsonABIData : Data?
    
    enum PoolType {
        case uni, jar
    }
    
    let web3 = Web3(rpcURL: "https://mainnet.infura.io/v3/\(Secrets().infuraProjectId)")    
    var contract : DynamicContract?
    
    func loadABI(forAddress address: String, withSuccess success: (() -> Void)?, failure: ((Error?) -> Void)?) {
        let datasource = EtherscanDataSource()
        datasource.getABI(address: address, withSuccess: { (jsonABIData) in
            self.jsonABIData = jsonABIData
            if let jsonABI = jsonABIData {
                do {
                    let contractAddress = try EthereumAddress(hex: address, eip55: true)
                    self.contract = try self.web3.eth.Contract(json: jsonABI, abiKey: nil, address: contractAddress)
                } catch let error {
                    print(error)
                }
                success?()
            } else {
                failure?(NSError(domain: "JSON ABI Data Invalid", code: -1, userInfo: nil))
            }
        }, failure: failure)
    }

    func getPoolType(forAddress address: String, withSuccess success: ((_ poolType: PoolType) -> Void)?, failure: ((Error?) -> Void)?) {
        self.loadABI(forAddress: address, withSuccess: {
            if self.contract?["token0"] != nil {
                success?(.uni)
            } else if self.contract?["token"] != nil {
                success?(.jar)
            } else {
                failure?(NSError(domain: "Unknown pool type", code: -1, userInfo: nil))
            }
        }, failure: failure)
    }
}

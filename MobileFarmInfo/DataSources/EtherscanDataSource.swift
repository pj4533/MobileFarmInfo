//
//  EtherscanDataSource.swift
//  MobileFarmInfo
//
//  Created by PJ Gray on 10/4/20.
//

import Foundation

class EtherscanDataSource {
    func getABI(address: String, withSuccess success: ((_ contractABIData: Data? ) -> Void)?, failure: ((_ error: Error?) -> Void)? ) {
                
        let url = URL(string: "https://api.etherscan.io/api?module=contract&action=getabi&address=\(address)")!
        let request = URLRequest(url: url)
        
        struct EtherscanResponse : Codable {
            let result: String?
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(EtherscanResponse.self, from: data)
                    success?(response.result?.data(using: .utf8))
                } catch let error {
                    print(error)
                }
            }
        }
        task.resume()
    }
}

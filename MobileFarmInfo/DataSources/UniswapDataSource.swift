//
//  UniswapDataSource.swift
//  MobileFarmInfo
//
//  Created by PJ Gray on 10/4/20.
//

import Foundation

class UniswapDataSource {
    
    func getPair(address: String, withSuccess success: ((_ pair: Pair?) -> Void)?, failure: ((_ error: Error?) -> Void)? ) {
        let parameters : [String:Any] = [
            "query" : "query($id: String!) {  pair(id:$id) { id totalSupply reserveUSD reserve0 reserve1 token0Price token1Price volumeToken0 volumeToken1 token0 { symbol decimals derivedETH } token1 { symbol decimals derivedETH } }  }",
            "variables" : [
                "id" : address.lowercased()
            ]
        ]
        
        let url = URL(string: "https://api.thegraph.com/subgraphs/name/uniswap/uniswap-v2")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        struct DataResponse : Codable {
            let pair : Pair?
        }

        struct GraphQLResponse : Codable {
            let data: DataResponse?
        }

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let graphQLResponse = try decoder.decode(GraphQLResponse.self, from: data)
                    DispatchQueue.main.async {
                        success?(graphQLResponse.data?.pair)
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        failure?(error)
                    }
                }
            }
        }
        task.resume()
    }
    
}

//
//  Pair.swift
//  MobileFarmInfo
//
//  Created by PJ Gray on 10/4/20.
//

import Foundation

struct Pair : Codable {
    var id: String?
    var totalSupply: String?
    
    var token0: Token?
    var token0Price: String?
    var volumeToken0: String?
    
    var token1: Token?
    var token1Price: String?
    var volumeToken1: String?
    
    func getPool() -> UniswapPool {
        
        // this is wrong - not sure what q0 q1 are...
        let q0 = (Double(self.volumeToken0 ?? "0") ?? 0.0) / Double(10^(Int(self.token0?.decimals ?? "0") ?? 0))
        let q1 = (Double(self.volumeToken1 ?? "0") ?? 0.0) / Double(10^(Int(self.token1?.decimals ?? "0") ?? 0))

        var tvl = ((Double(self.token0Price ?? "0") ?? 0.0) * q0)
        tvl = tvl + ( (Double(self.token1Price ?? "0") ?? 0.0) * q1)
        
        
        return UniswapPool(name: "\(self.token0?.symbol ?? "?")-\(self.token1?.symbol ?? "?")", price: tvl / (Double(self.totalSupply ?? "0.0") ?? 0.0), tvl: tvl)
    }
}

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
    var reserveUSD: String?
    
    var reserve0: String?
    var token0: Token?
    var token0Price: String?
    var volumeToken0: String?
    
    var reserve1: String?
    var token1: Token?
    var token1Price: String?
    var volumeToken1: String?
    
    func getPool() -> UniswapPool {
        let tvl = Double(self.reserveUSD ?? "0.0") ?? 0.0        
        return UniswapPool(
            name: "\(self.token0?.symbol ?? "?")-\(self.token1?.symbol ?? "?")",
            price: tvl / (Double(self.totalSupply ?? "0.0") ?? 0.0),
            tvl: tvl,
            token0: self.token0,
            token1: self.token1
        )
    }
}

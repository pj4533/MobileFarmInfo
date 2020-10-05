//
//  UniswapPool.swift
//  MobileFarmInfo
//
//  Created by PJ Gray on 10/4/20.
//

import Foundation

struct UniswapPool : Pool {
    var name: String
    var price: Double
    var tvl: Double
    
    var token0: Token?
    var token1: Token?
}

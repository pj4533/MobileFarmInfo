//
//  Pool.swift
//  MobileFarmInfo
//
//  Created by PJ Gray on 10/3/20.
//

import Foundation

protocol Pool {
    var name : String { get }
    var price : Double { get }
    var tvl : Double { get }
    var token0 : Token? { get }    
    var token1 : Token? { get }
    var lpToken : Token? { get }
}

//
//  Token.swift
//  MobileFarmInfo
//
//  Created by PJ Gray on 10/4/20.
//

import Foundation

struct Token : Codable {
    var id: String?
    var symbol: String?
    var decimals: String?
    var derivedETH: String?
    
    func usdMarketPrice(withEtherPrice etherPrice: Double) -> Double {
        return (Double(self.derivedETH ?? "0") ?? 0) * etherPrice
    }

}

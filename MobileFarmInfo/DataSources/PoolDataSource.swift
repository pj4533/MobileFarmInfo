//
//  PoolDataSource.swift
//  MobileFarmInfo
//
//  Created by PJ Gray on 10/4/20.
//

import Foundation
import Web3

protocol PoolDataSource {
    func getPoolCount(withSuccess success: ((_ poolCount: BigUInt ) -> Void)?, failure: ((_ error: Error?) -> Void)? )
    func getTokenAddress(forPoolIndex poolIndex:Int, withSuccess success: ((_ lpToken: EthereumAddress ) -> Void)?, failure: ((_ error: Error?) -> Void)? )
}

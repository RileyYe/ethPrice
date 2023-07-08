//
//  coinConfigure.swift
//  ethPrice
//
//  Created by rileyye on 2023/7/8.
//

import Foundation

struct MetaCoinConfigure {
  let id: String
  let name: String
  let icon: String
}

struct CoinConfigure {
  static let ETH =  MetaCoinConfigure(id: "ethereum", name: "ethereum", icon: "eth")
  static let MATIC = MetaCoinConfigure(id: "matic-network", name: "matic", icon: "matic")
}

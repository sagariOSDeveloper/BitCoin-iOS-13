//
//  CurrencyData.swift
//  BitCoinSW
//
//  Created by Sagar Baloch on 15/01/2020.
//  Copyright © 2020 Sagar Baloch. All rights reserved.
//

import Foundation


struct CurrencyData:Codable {
    let last:Double
}

struct CoinModel {
    let price:Double
    let currency:String
}

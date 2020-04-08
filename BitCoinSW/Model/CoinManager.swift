//
//  CoinManager.swift
//  BitCoinSW
//
//  Created by Sagar Baloch on 15/01/2020.
//  Copyright © 2020 Sagar Baloch. All rights reserved.
//

import Foundation

protocol CurrenyDelegate {
    func didUpdateUI(_ coinManager:CoinManager,price:CoinModel)
    func didFailWithError(error:Error)
}
struct CoinManager {
    
    var delegate:CurrenyDelegate?
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let baseURL="https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    var curr="nil"
    mutating func getCoinPrice(for currency:String){
        let URL="\(baseURL)\(currency)"
        print(URL)
        curr=currency
        performRequest(for: URL)
    }
    
    func performRequest(for urlString:String) {
        if let url=URL(string: urlString){
            print("URL Created")
            let session=URLSession(configuration: .default)
            print("Session Created")
            let task=session.dataTask(with: url, completionHandler: {(data,response,error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    print("Error: \(error!)")
                    return
                }
                if let safeData=data{
                    let dataString = String(data:safeData,encoding: .utf8)
                    print("Data: \(dataString!)")
                    if let price=self.parseJSON(safeData){
                        self.delegate?.didUpdateUI(self, price: price)
                    }
                }
            })
            task.resume()
        }else{
            print("URL not Created")
        }
    }
    
    func parseJSON(_ price:Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do{
            let decoderData=try decoder.decode(CurrencyData.self, from: price)
            let lastPrice=decoderData.last
            let priceData=CoinModel(price: lastPrice,currency: curr)
            print(lastPrice)
            return priceData
        }catch{
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

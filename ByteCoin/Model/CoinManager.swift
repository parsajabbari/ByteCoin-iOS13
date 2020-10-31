//
//  CoinManager.swift
//  ByteCoin

import Foundation

protocol CoinManagerDelegate {
    func didFailWithError(_ error: Error)
    
    func gotBitcoinPrice(_ price: Double)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "7B833E93-784E-4396-9DAA-ED68239F2CBA"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {(data, response, error) in
                if let safeError = error {
                    self.delegate?.didFailWithError(safeError)
                } else {
                    if let safeData = data {
                        if let coin = parseJSON(safeData) {
                            delegate?.gotBitcoinPrice(coin.rate)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> CoinData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            return decodedData
        } catch {
            delegate?.didFailWithError(error)
            return nil
        }
    }
}


//
//  ethPriceApp.swift
//  ethPrice
//
//  Created by rileyye on 2023/7/8.
//

import SwiftUI

protocol PriceFetchStrategy { func fetch(coin: String, completion: @escaping (Result<Double, Error>) -> Void) }

class CoinGeckoPriceFetchStrategy: PriceFetchStrategy {
  func fetch(coin: String, completion: @escaping (Result<Double, Error>) -> Void) {
    guard
      let url = URL(
        string:
          "https://api.coingecko.com/api/v3/simple/price?ids=\(coin)&vs_currencies=usd")
    else { fatalError("Missing URL") }
    let urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
    let config = URLSessionConfiguration.default
    config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    let session = URLSession(configuration: config)
    let dataTask = session.dataTask(with: urlRequest) { (data, resp, error) in
      if let e = error {
        DispatchQueue.main.async {
          completion(.failure(e))
          return
        }
      }
      guard let resp = resp as? HTTPURLResponse else { return }
      if resp.statusCode == 200 {
        guard let data = data else { return }
        DispatchQueue.main.async {
          do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            if let dict = jsonObject as? [String: [String: Double]] {
              completion(.success((dict["\(coin)"]?["usd"] ?? Double.nan) as Double))
            }
          } catch let error { completion(.failure(error)) }
        }
      }
    }
    dataTask.resume()
  }
}



class PriceViewModel: ObservableObject {
  @Published var price: Double = 0.0
  @Published var coinConfigure: MetaCoinConfigure = CoinConfigure.ETH
  var priceFetchStrategy: PriceFetchStrategy

  init(priceFetchStrategy: PriceFetchStrategy = CoinGeckoPriceFetchStrategy()) {
    self.priceFetchStrategy = priceFetchStrategy
    self.updatePrice()
    Timer.scheduledTimer(withTimeInterval: 20, repeats: true) { _ in
      self.updatePrice()
    }
  }
  
  public func setCoinConfigure(coinConfigure: MetaCoinConfigure) {
    self.coinConfigure = coinConfigure
    updatePrice()
  }
  
  private func updatePrice() {
    self.priceFetchStrategy.fetch(coin: self.coinConfigure.id) { result in
      switch result {
      case .success(let usd):
        DispatchQueue.main.async {
          print(self.coinConfigure.id)
          self.price = usd
        }
      case .failure(_):
        self.price = Double.nan
      }
    }
  }
}

@main struct ethPriceApp: App {
  @StateObject private var priceView = PriceViewModel()
  var body: some Scene {
    MenuBarExtra(
      content: {
        VStack {
          Button("ETH") {
            priceView.setCoinConfigure(coinConfigure: CoinConfigure.ETH)
          }
          Button("MATIC") {
            priceView.setCoinConfigure(coinConfigure: CoinConfigure.MATIC)
          }
          Button("Exit") { NSApp.terminate(nil) }
        }
      },
      label: {
        HStack {
          Image(priceView.coinConfigure.icon)
          Text(String(" \(priceView.price) USD"))
        }
      })
  }
}

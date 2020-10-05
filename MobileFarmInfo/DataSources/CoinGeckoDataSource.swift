import Foundation

class CoinGeckoDataSource {
    func getETHPrice(withSuccess success: ((_ ethPrice: Double) -> Void)?, failure: ((_ error: Error?) -> Void)? ) {

        let url = URL(string: "https://api.coingecko.com/api/v3/simple/price?ids=ethereum&vs_currencies=usd")!
        let request = URLRequest(url: url)
        
        struct CoinResponse : Codable {
            let usd : Double
        }
        
        struct CoinGeckoResponse : Codable {
            let ethereum : CoinResponse
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(CoinGeckoResponse.self, from: data)
                    
                    success?(response.ethereum.usd)
                } catch let error {
                    print(error)
                }
            }
        }
        task.resume()
    }
}

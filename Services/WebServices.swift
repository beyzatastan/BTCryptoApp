//
//  WebServices.swift
//  BTCrypto
//
//  Created by beyza nur on 1.02.2024.
//

import Foundation

class WebServices{
    static let shared = WebServices()
    
    //VERİ ÇEKME
    
    func fetchData(completion:@escaping ([Crypto]?) -> Void){
        
        guard let url=URL(string: "https://raw.githubusercontent.com/atilsamancioglu/IA32-CryptoComposeData/main/cryptolist.json")
        else{ completion(nil)
            return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                    print("URLSession hatası: \(error)")
                    completion(nil)
                    return
                }
            guard let data=data ,error == nil else{ completion(nil)
                return }
            do{
                //dizi içinde verdiği için [Cryptos] yazdım
                let cryptos = try JSONDecoder().decode([Crypto].self, from: data)
                completion(cryptos)
            }catch{
                print(error.localizedDescription)
                completion(nil)
            }
            
        }
        task.resume()
        
    }
}


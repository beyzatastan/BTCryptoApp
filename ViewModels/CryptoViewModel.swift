//
//  CryptoViewModel.swift
//  BTCrypto
//
//  Created by beyza nur on 1.02.2024.
//

import Foundation

class CryptoViewModel{
    
    var cryptos=[Crypto]()
    
    func fetchData(completion:@escaping ()-> Void){
        WebServices.shared.fetchData{ fetchedcrypto in
            if let fetchedcrypto=fetchedcrypto {
                self.cryptos=fetchedcrypto
            }else {
                print("veri çekme hatası")
            }
            completion()
            
        }
    }
}


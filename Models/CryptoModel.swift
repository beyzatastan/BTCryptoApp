//
//  CryptoModel.swift
//  BTCrypto
//
//  Created by beyza nur on 1.02.2024.
//

import Foundation

//cryptolar bize bir dizi içinde veriliyor zaten,içinde başka bir dizi yok gireceğimiz
struct Crypto : Decodable {
    let currency : String
    let price : String
}

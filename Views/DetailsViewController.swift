//
//  DetailsViewController.swift
//  BTCrypto
//
//  Created by beyza nur on 5.02.2024.
//

import UIKit
import Firebase

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var totalResult: UILabel!
    @IBOutlet weak var currencynumber: UILabel!
    @IBOutlet weak var currencyPrice: UILabel!
    @IBOutlet weak var currencyName: UILabel!
    
    var cryptoName=String()
    var cryptoPrice=String()
    var cryptoAmount=Int()
    var cryptoResult=String()
    //database im
    let db=Firestore.firestore()
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyName.layer.cornerRadius = 20
        currencyPrice.layer.cornerRadius = 10
        currencyName.clipsToBounds = true
        currencyPrice.clipsToBounds = true
        
        currencynumber.layer.cornerRadius = 20
        totalResult.layer.cornerRadius = 10
        currencynumber.clipsToBounds = true
        totalResult.clipsToBounds = true
        
        
            write()
        }
    
   
    
    
    
    func write(){
        currencyName.text = cryptoName
        currencyPrice.text = cryptoPrice
        
            guard let user = Auth.auth().currentUser else { return }
            let currentUserId = user.uid
        // Kullanıcının sahip olduğu kripto biriminin bilgilerini kontrol et
        let cryptoRef = db.collection("Cryptos").whereField("CurrencyName", isEqualTo: cryptoName).whereField("User", isEqualTo: currentUserId)
        cryptoRef.getDocuments { (snapshot, error) in
            if let error = error {
                print("kontrol hatası-checkıf -\(error.localizedDescription)")
            }else {
                guard let documents = snapshot?.documents else { return }
                if let document = documents.first {
                    // Kullanıcı bu kripto birimine zaten sahip, miktarı arttır
                    var currentAmount = document.get("CurrencyAmount") as? Int ?? 0
                    var price=document.get("Currency Price") as? String ?? "0.0"
                    
                    self.currencynumber.text = "\(currentAmount)"
                    
                }
            }
        }
        updateTotalGain()
    }


 
        func checkIfHave(userId: String){
            guard let user = Auth.auth().currentUser else { return }
            let currentUserId = user.uid
            
            // Kullanıcının sahip olduğu kripto biriminin bilgilerini kontrol et
            let cryptoRef = db.collection("Cryptos").whereField("CurrencyName", isEqualTo: cryptoName).whereField("User", isEqualTo: currentUserId)
            
            cryptoRef.getDocuments { (snapshot, error) in
                if let error = error {
                    print("kontrol hatası-checkıf -\(error.localizedDescription)")
                } else {
                    guard let documents = snapshot?.documents else { return }
                    if let document = documents.first {
                        // Kullanıcı bu kripto birimine zaten sahip, miktarı arttır
                        var currentAmount = document.get("CurrencyAmount") as? Int ?? 0
                        currentAmount += 1
                        
                        // Miktarı güncelle
                        document.reference.updateData(["CurrencyAmount": currentAmount]) { error in
                            if let error = error {
                                print("Error updating document: \(error.localizedDescription)")
                            } else {
                                print("Buy operation successful")
                                self.cryptoAmount = currentAmount
                                self.currencynumber.text = "\(self.cryptoAmount)"
                                self.updateTotalGain()
                            }
                        }
                    } else {
                        // Kullanıcı bu kripto birimine daha önce sahip değil, yeni bir belge oluştur
                        let fireStoreCrypto: [String: Any] = [
                            "CurrencyName": self.cryptoName,
                            "CurrencyPrice": self.cryptoPrice,
                            "CurrencyAmount": 1, // İlk kez alındığı için miktarı 1 olarak ayarlıyoruz
                            "User": currentUserId
                        ]
                        
                        // Belgeyi ekle
                        self.db.collection("Cryptos").addDocument(data: fireStoreCrypto) { error in
                            if let error = error {
                                print("Error adding document: \(error.localizedDescription)")
                            } else {
                                print("Buy operation successful")
                                self.cryptoAmount = 1
                                self.currencynumber.text = "\(self.cryptoAmount)"
                                self.updateTotalGain()
                            }
                        }
                    }
                }
            }
        }

        
        
        @IBAction func buyButton(_ sender: Any) {
            guard let userId = Auth.auth().currentUser?.uid else { return }

               // Kullanıcının sahip olduğu kripto para biriminin bilgilerini kontrol et
               checkIfHave(userId: userId)
        }
        
        
        
        
        
        
        @IBAction func sellButton(_ sender: Any) {
            let user=Auth.auth().currentUser
            let userId=user?.uid
            //Satmak için ömce elimde olması lazım
            let RefCryptos = db.collection("Cryptos").whereField("CurrencyName", isEqualTo: cryptoName).whereField("User", isEqualTo: userId)
            RefCryptos.getDocuments { querySnapshot, error in
                if let error = error{
                    print("error getting documents-sell: \(error.localizedDescription)")
                    return
                }
                guard let documents=querySnapshot?.documents else {
                    print("no documents")
                    return }
                //dokumana erişmeye çalışıyoeuz
                if let document=documents.first{
                    //eğer varsa birimini azalt
                    var currentAmount = document.get("CurrencyAmount") as? Int ?? 0
                    if currentAmount==1 {
                        document.reference.delete { error in
                                if let error = error {
                                    print("Error deleting document: \(error.localizedDescription)")
                                } else {
                                    print("Document deleted successfully")
                                    // Döküman başarıyla silindikten sonra ek işlemleriniz,
                                    currentAmount=0
                                    self.currencynumber.text="0"
                                    self.totalResult.text="0"
                                }
                            }
                    }
                    else{
                        currentAmount -= 1
                        
                        //şimdi güncellicez
                        document.reference.updateData(["CurrencyAmount":currentAmount]) { error in
                            if let error = error{
                                print("error updating document-sell")
                            }else{
                                print("sell operation successful")
                                self.cryptoAmount = currentAmount
                                self.currencynumber.text="\(self.cryptoAmount)"
                                self.updateTotalGain()
                                
                            }
                        }
                    }
                    
                } else{
                    self.makeAlert(title: "ERROR", message: "YOU DONT HAVE COIN TO SELL")
                    //sildiğimiz için komple koleksiyondan dosyay bulamaz
                    print("no document found for user and currency")
                }
                
            }
            
        }
    
    func updateTotalGain() {
        let totalGain = Double(cryptoAmount) * (Double(cryptoPrice) ?? 0)
        totalResult.text = "   TOTAL: \(totalGain)"
    }
    
    
    func makeAlert(title:String,message:String){
        let alert=UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton=UIAlertAction(title: "ok", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okButton)
        self.present(alert,animated: true,completion: nil)
        
    }
    
        
        @IBAction func homeButton(_ sender: Any) {
            let homeVC=storyboard?.instantiateViewController(withIdentifier: "main") as! MainViewController
            navigationController?.pushViewController(homeVC, animated: false)
        }
        
        @IBAction func coinButton(_ sender: Any) {
            
            let coinVc=storyboard?.instantiateViewController(withIdentifier: "sell") as! SellViewController
            navigationController?.pushViewController(coinVc, animated: false)
        }
        @IBAction func settingsButton(_ sender: Any) {
            
            let settingsVc=storyboard?.instantiateViewController(withIdentifier: "settings") as! SettingsViewController
            navigationController?.pushViewController(settingsVc, animated: false)
        }
        
    }
        

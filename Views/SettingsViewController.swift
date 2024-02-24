//
//  SettingsViewController.swift
//  BTCrypto
//
//  Created by beyza nur on 4.02.2024.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var person=String()
    
    let setArray=["Load money","Change the password","Log out"]
    
    override func viewDidLoad() {
       super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
        
            checkIf()
        
    }
    
        func checkIf(){
            if person != "" && person != " " {
                nameLabel.text=person.uppercased()
            }else{
                //KULLANICININ EMAİL ADRESİNDE @ İŞARETİNDEN ÖNCEKİ KISMI YZMAYI SAĞLIYOR
                if let currentUser = Auth.auth().currentUser {
                    if let email = currentUser.email {
                        // E-posta adresinden @ işaretinden önceki kısmı al
                        let username = email.components(separatedBy: "@")[0].uppercased()
                        nameLabel.text = username
                    }
                } else {
                    nameLabel.text = "No user signed in"
                }
            }
        }
        
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "celll", for: indexPath) as! SettingsTableViewCell
        var content=cell.defaultContentConfiguration()
        content.text=setArray[indexPath.row]
        cell.contentConfiguration=content
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
           case 0: // İlk row için
            let walletVc=storyboard?.instantiateViewController(identifier: "wallet") as! WalletViewController
            navigationController?.pushViewController(walletVc, animated: false)
          
            
           case 1: // İkinci row için
            let passwordVc=storyboard?.instantiateViewController(identifier: "password") as! ChangePasswordViewController
            navigationController?.pushViewController(passwordVc, animated: false)
            
            
           case 2 :
            func makeAlert(title: String, message: String, firstButtonTitle: String, secondButtonTitle: String) {
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                // İlk buton için UIAlertAction oluştur
                let yesButton = UIAlertAction(title: firstButtonTitle, style: .default) { (action) in
                    print("yes button tapped")
                    do {
                       //kullanıcı cıksın
                       try Auth.auth().signOut()
                        let logoutVVc=self.storyboard?.instantiateViewController(withIdentifier: "sign") as! ViewController
                        self.navigationController?.pushViewController(logoutVVc, animated: false)
                   } catch {
                       print("error")
                   }
                }
                let noButton=UIAlertAction(title: "NO", style: UIAlertAction.Style.cancel, handler: nil)
                // UIAlertAction'ları UIAlertController'a ekle
                alertController.addAction(yesButton)
                alertController.addAction(noButton)
                
                // UIAlertController'ı göster
                present(alertController, animated: true, completion: nil)
            }
            
            makeAlert(title: "SURE ?", message: "DO YOU WANT TO LOG OUT ?", firstButtonTitle: "YES", secondButtonTitle: "NO")
            
           default:
               break
           }
        
        
    }
    @IBAction func coinButton(_ sender: Any) {
        let coinVc=storyboard?.instantiateViewController(withIdentifier: "sell") as! SellViewController
        navigationController?.pushViewController(coinVc, animated: false)
    }
    

    @IBAction func homeButton(_ sender: Any) {
        let homeVc=storyboard?.instantiateViewController(withIdentifier: "main") as! MainViewController
        navigationController?.pushViewController(homeVc, animated: false)
    }
    
}

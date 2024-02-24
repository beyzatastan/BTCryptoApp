//
//  SellViewController.swift
//  BTCrypto
//
//  Created by beyza nur on 4.02.2024.
//

import UIKit
import Firebase

class SellViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //arama kısmında yazılcak olanlar
    var filteredArray:[Crypto]=[]
    var searching:Bool?

    var owneddCoins: [Crypto] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        ownedCoins()
        
        
}
    
    //verileri koleksiyondan çekiyorrum ve diziye ekliyorum
    func ownedCoins(){
        let db=Firestore.firestore()
        let user=Auth.auth().currentUser
        let userId=user?.uid
        
        let refDb = db.collection("Cryptos").whereField("User", isEqualTo: userId)
        refDb.getDocuments { (snapshot, error) in
               if let error = error {
                   print("Error getting documents: \(error.localizedDescription)")
               } else {
                   guard let documents = snapshot?.documents else { return }
                   
                   for document in documents {
                       let data = document.data()
                       if let currencyName = data["CurrencyName"] as? String,
                          let currencyPrice = data["CurrencyPrice"] as? String {
                           let crypto = Crypto(currency: currencyName,
                                               price: currencyPrice)
                           self.owneddCoins.append(crypto)
                       }
                   }
                   
                   // Verileri diziye ekledikten sonra bu diziyi kullanabilirsiniz
                   print("Owned coins: \(self.owneddCoins)")
                   self.tableView.reloadData()

               }
           }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searching ?? false){
           return filteredArray.count
        }else{
            return owneddCoins.count
        }
       
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "sell", for: indexPath) as! SellTableViewCell
        if(!(searching ?? false)){
            var content=cell.defaultContentConfiguration()
            content.text=owneddCoins[indexPath.row].currency
            content.secondaryText=owneddCoins[indexPath.row].price
            cell.contentConfiguration=content
        }else{
            var content=cell.defaultContentConfiguration()
            content.text=filteredArray[indexPath.row].currency
            content.secondaryText=filteredArray[indexPath.row].price
            cell.contentConfiguration=content

        }
        
        return cell
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.isEmpty){
            filteredArray=owneddCoins
        }else{
            
            filteredArray = owneddCoins.filter { $0.currency.lowercased().contains(searchText.lowercased()) }
        }
        searching=true
        tableView.reloadData()
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCrypto=owneddCoins[indexPath.row]
        let detailsVc=storyboard?.instantiateViewController(identifier: "details") as! DetailsViewController
        detailsVc.cryptoName=selectedCrypto.currency
        detailsVc.cryptoPrice=selectedCrypto.price
        navigationController?.pushViewController(detailsVc, animated: false)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
      

    @IBAction func homeButton(_ sender: Any) {
        
            let homeVc=storyboard?.instantiateViewController(withIdentifier: "main") as! MainViewController
            navigationController?.pushViewController(homeVc, animated: false)
    }
    
    @IBAction func settingsButton(_ sender: Any) {
        
            let settingsVc=storyboard?.instantiateViewController(withIdentifier: "settings") as! SettingsViewController
            navigationController?.pushViewController(settingsVc, animated: false)
    }
}

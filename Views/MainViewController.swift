//
//  MainViewController.swift
//  BTCrypto
//
//  Created by beyza nur on 1.02.2024.
//

import UIKit

class MainViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
   
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //diziye erişebilmek için viewmodel i kullanak zorunadım
    var cryptoViewModel=CryptoViewModel()
  
    
    var filteredArray:[Crypto]=[]
    var searching:Bool?
    
    var personM=String()
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource=self
        tableView.delegate=self
        searchBar.delegate=self
        
        cryptoViewModel.fetchData {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searching ?? false){
           return filteredArray.count
        }else{
            return cryptoViewModel.cryptos.count
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainTableViewCell
        if(!(searching ?? false)){
            var content=cell.defaultContentConfiguration()
            content.text=cryptoViewModel.cryptos[indexPath.row].currency
            content.secondaryText=cryptoViewModel.cryptos[indexPath.row].price
            cell.contentConfiguration=content
        }else{
            var content=cell.defaultContentConfiguration()
            content.text=filteredArray[indexPath.row].currency
            content.secondaryText=filteredArray[indexPath.row].price
            cell.contentConfiguration=content

        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCrypto=cryptoViewModel.cryptos[indexPath.row]
        let detailsVc=storyboard?.instantiateViewController(identifier: "details") as! DetailsViewController
        detailsVc.cryptoName=selectedCrypto.currency
        detailsVc.cryptoPrice=selectedCrypto.price
        navigationController?.pushViewController(detailsVc, animated: false)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
      
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.isEmpty){
            filteredArray=cryptoViewModel.cryptos
        }else{
            
            filteredArray = cryptoViewModel.cryptos.filter { $0.currency.lowercased().contains(searchText.lowercased()) }
        }
        searching=true
        tableView.reloadData()
    }
    
    
    @IBAction func coinButton(_ sender: Any) {
        let coinVc=storyboard?.instantiateViewController(withIdentifier: "sell") as! SellViewController
        navigationController?.pushViewController(coinVc, animated: false)
    }
    
    @IBAction func settingsButton(_ sender: Any) {
        
            let settingsVc=storyboard?.instantiateViewController(withIdentifier: "settings") as! SettingsViewController
            settingsVc.person=personM
            navigationController?.pushViewController(settingsVc, animated: false)
        
    }
    

}

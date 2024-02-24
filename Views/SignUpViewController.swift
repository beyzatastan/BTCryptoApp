//
//  SıgnUpViewController.swift
//  BTCrypto
//
//  Created by beyza nur on 11.02.2024.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var expDateText: UITextField!
    @IBOutlet weak var cvvText: UITextField!
    @IBOutlet weak var creditCardNumber: UITextField!
    @IBOutlet weak var password2Text: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
     
      
    }
    

    @IBAction func nextButton(_ sender: Any) {
        if emailText.text != " " && passwordText.text != " " && passwordText.text==password2Text.text{
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { authData, error in
                if error != nil {
                    self.makeAlert(title: "ERROR", message: error!.localizedDescription)
                }else{
                    let girisVc=self.storyboard?.instantiateViewController(withIdentifier: "wallet") as! WalletViewController
                    self.navigationController?.pushViewController(girisVc, animated: false)
                    girisVc.personW=self.nameText.text ?? " "
                    
                    
                }
            
            }
        }else{
            self.makeAlert(title: "ERROR", message: "USERNAME/PASSWORD ERROR")
        }
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        let backVc=storyboard?.instantiateViewController(identifier: "sign") as! ViewController
        navigationController?.pushViewController(backVc, animated: false)
        
    }
    
    
    
    func makeAlert(title:String,message:String){
        let alert=UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton=UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okButton)
        self.present(alert,animated: true,completion: nil)
    }
    
}

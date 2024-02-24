//
//  ViewController.swift
//  BTCrypto
//
//  Created by beyza nur on 1.02.2024.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentUser=Auth.auth().currentUser
        if currentUser != nil {
            let begginning=storyboard?.instantiateViewController(withIdentifier: "main") as! MainViewController
            navigationController?.pushViewController(begginning, animated: false)
        }

    }
    
    @IBAction func signUpButton(_ sender: Any) {
        let signUpVc=storyboard?.instantiateViewController(identifier: "signUp") as! SignUpViewController
        navigationController?.pushViewController(signUpVc, animated: false)
    }
    
    @IBAction func signInButton(_ sender: Any) {
        if emailText.text != " " && passwordText.text != " " {
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { authData, error in
                if error != nil {
                    self.makeAlert(title: "ERROR", message: error!.localizedDescription)
                }else{
                    let girissVc=self.storyboard?.instantiateViewController(withIdentifier: "main") as! MainViewController
                    self.navigationController?.pushViewController(girissVc, animated: false)
                
                }
            }
            
        }else{
            self.makeAlert(title: "ERROR", message: "USERNAME/PASSWORD ERROR" )
        }
    }
    
    
    func makeAlert(title:String,message:String){
        let alert=UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton=UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okButton)
        self.present(alert,animated: true,completion: nil)
    }
}

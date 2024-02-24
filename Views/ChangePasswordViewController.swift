//
//  ChangePasswordViewController.swift
//  BTCrypto
//
//  Created by beyza nur on 13.02.2024.
//

import UIKit
import Firebase

class ChangePasswordViewController: UIViewController {

    
    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var newPassword2: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
  
    
    @IBAction func changePasswordButtonClicked(_ sender: Any) {
        
        guard let user = Auth.auth().currentUser,
              let oldPassword = oldPassword.text,
              let newPassword = newPassword.text,
              let newPassword2 = newPassword2.text else {return}
        
        if newPassword == newPassword2 {
            // Kullanıcı yeni şifreleri doğru girdi, şimdi mevcut şifreyi doğrulayın
            let credential = EmailAuthProvider.credential(withEmail: user.email!, password: oldPassword)
            user.reauthenticate(with: credential) { result, error in
                if let error = error {
                    // Eski şifre yanlışsa veya doğrulanamazsa
                    print("Error reauthenticating user: \(error.localizedDescription)")
                    self.makeAlert(title: "ERROR", message: "YOUR OLD PASSWORD IS NOT TRUE")
                } else {
                    // Eski şifre doğru, şimdi yeni şifreyi güncelleyin
                    user.updatePassword(to: newPassword) { error in
                        if let error = error {
                            // Şifre güncelleme işlemi sırasında bir hata oluştu
                            print("Error updating password: \(error.localizedDescription)")
                            self.makeAlert(title: "Error", message: "An error occurred.")
                        } else {
                            // Şifre başarıyla güncellendi
                                let settingsVC=self.storyboard?.instantiateViewController(identifier: "settings") as! SettingsViewController
                                self.navigationController?.pushViewController(settingsVC, animated: false)
                            print("Password updated successfully")
                            self.makeAlert(title: "CHANGED", message: "Your password has been succesfully changed.")
                        
                            
                        }
                    }
                }
            }
        } else {
            makeAlert(title: "ERROR", message: "PASWORDS ARE DOESN'T MATCH")
        }
        
        
        
    }
    
    
    func makeAlert(title:String,message:String){
        let alert=UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton=UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okButton)
        self.present(alert,animated: true,completion: nil)
    }

    
    
    
    @IBAction func backButton(_ sender: Any) {
        let settingsVC=storyboard?.instantiateViewController(identifier: "settings") as! SettingsViewController
        navigationController?.pushViewController(settingsVC, animated: false)
    }
}

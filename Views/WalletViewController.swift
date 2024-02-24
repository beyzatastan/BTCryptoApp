//
//  WalletViewController.swift
//  BTCrypto
//
//  Created by beyza nur on 13.02.2024.
//

import UIKit

class WalletViewController: UIViewController {

    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var moneyText: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    var personW=String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        labelText.text="HOW MUCH MONEY DO YOU WANT TO LOAD INTO YOUR WALLET ?"
        let stepperValue=stepper.value
        moneyText.text="\(stepperValue)"
        
        
        stepper.frame = CGRect(x: 150, y: 550, width: 300, height: 150)
        stepper.stepValue=10
        stepper.minimumValue=0
        // Diğer yapılandırma işlemleri veya ekleme işlemleri devam edebilir
        view.addSubview(stepper)
    }
    
    

    @IBAction func stepperClicked(_ sender: UIStepper) {
        let stepperValue=stepper.value
        moneyText.text="\(stepperValue)"
    }
    
    
    @IBAction func nextButton(_ sender: Any) {
        // StepperClicked fonksiyonunu çağırarak moneyText değerini güncelleyin
        stepperClicked(stepper)
        
        // Geldiği değer nil değilse devam edin
        guard let moneyValue = moneyText.text else {
            print("Money value is nil")
            return
        }
     
        //butona tıklanınca main e kişinin cüzdan bakiyesi gitsin istedik
        let mainVc = storyboard?.instantiateViewController(identifier: "main") as! MainViewController
        mainVc.personM=personW
        navigationController?.pushViewController(mainVc, animated: false)
        
    }
    
    
    @IBAction func backButtonClicked(_ sender: Any) {
        let settings = storyboard?.instantiateViewController(identifier: "settings") as! SettingsViewController
        navigationController?.pushViewController(settings, animated: false)
        
    }
    
    

}

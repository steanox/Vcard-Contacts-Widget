//
//  ViewController.swift
//  Vcard-Conctacts-Widget
//
//  Created by octavianus on 18/04/19.
//  Copyright © 2019 octavianus. All rights reserved.
//

import UIKit

class ViewController: UIViewController{

    @IBOutlet weak var phoneTextField: AnimatedPhoneTextField!
    let defaults = UserDefaults(suiteName: "group.vcard.contact")
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let defaults = defaults, let phone = defaults.object(forKey: "phoneNumber") as? String{
            phoneTextField.set(phone: phone)
        }
    
    }
    
    
    
    @IBAction func saveData(_ sender: UIButton) {
        let phoneNumber = phoneTextField.text
        
        if let defaults = defaults{
            defaults.set(phoneNumber, forKey: "phoneNumber")
            
            let successAlert = UIAlertController(title: "Data saved", message: "Successfully update the contact data", preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "Close", style: .cancel) { (alert) in
                self.dismiss(animated: true, completion: nil)
            }
            successAlert.addAction(closeAction)
            
            present(successAlert, animated: true, completion: nil)
        }

    }
    


}


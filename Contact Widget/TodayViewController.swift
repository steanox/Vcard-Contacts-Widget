//
//  TodayViewController.swift
//  Contact Widget
//
//  Created by octavianus on 18/04/19.
//  Copyright © 2019 octavianus. All rights reserved.
//

import UIKit
import NotificationCenter
import Contacts

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var personalMailSwitch: UISwitch!
    
    @IBOutlet weak var workMailSwitch: UISwitch!
    
    @IBOutlet weak var qrImage: UIImageView!
    let defaults = UserDefaults(suiteName: "group.vcard.contact")

    override func viewDidLoad() {
        super.viewDidLoad()
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        generateQR()
        // Do any additional setup after loading the view.
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        
        switch activeDisplayMode {
        case .expanded:
            self.qrImage.isHidden = false
            preferredContentSize = CGSize(width: maxSize.width, height: 400)
        case .compact:
            self.qrImage.isHidden = true
            preferredContentSize = maxSize
        }
     
    }
    
    @IBAction func generateAction(_ sender: UISwitch) {
        generateQR()
    }
    
    
    
    private func generateQR(){
        let myContact = CNMutableContact()
        guard let phoneNumber = defaults?.object(forKey: "phoneNumber") as? String else { return }
        print(phoneNumber)
        myContact.givenName = "Octavianus"
        myContact.familyName = "Gandadjaja"
        myContact.phoneNumbers = [
            CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue: "\(phoneNumber)"))
        ]
        
        if personalMailSwitch.isOn{
          myContact.emailAddresses.append(CNLabeledValue(label: CNLabelHome, value: "oktagandajaya@gmail.com"))
        }
        
        if workMailSwitch.isOn{
            myContact.emailAddresses.append(CNLabeledValue(label: CNLabelWork, value: "octavianus.g@binus.edu"))
        }
        do{
            let vcard = try CNContactVCardSerialization.data(with: [myContact])
            
            guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return }
            qrFilter.setValue(vcard, forKey: "inputMessage")
            guard let qrImage = qrFilter.outputImage else { return }
            
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let scaledQrImage = qrImage.transformed(by: transform)
            
            let image = UIImage(ciImage: scaledQrImage)
            self.qrImage.image = image
            
            
        }catch{
            print("error")
        }
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        generateQR()
        completionHandler(NCUpdateResult.newData)
    }
    
}

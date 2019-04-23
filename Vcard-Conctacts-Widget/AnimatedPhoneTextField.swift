//
//  AnimatedTextField.swift
//  Vcard-Conctacts-Widget
//
//  Created by octavianus on 23/04/19.
//  Copyright © 2019 octavianus. All rights reserved.
//

import UIKit

typealias Phone = (countryCode: [Character], number: [Character])


extension String.StringInterpolation{
    mutating func appendInterpolation(_ phone: Phone){
        let countryNumber = String(phone.countryCode)
        let phoneNumber = String(phone.number)
        
        appendLiteral(countryNumber + phoneNumber)
    }
}

final class AnimationTextFieldAttributes: UICollectionViewFlowLayout{
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = self.layoutAttributesForItem(at: itemIndexPath)
        attr?.transform = CGAffineTransform(translationX: 5, y: 0)
        attr?.alpha = 0
        return attr
    }
}

class AnimatedTextFieldCell: UICollectionViewCell{
    
    var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = NSTextAlignment.center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    var number: Character! {
        didSet{
            self.textLabel.text = String(number)
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textLabel)
        setupConstraint()
    }
    
    private func setupConstraint(){
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textLabel.widthAnchor.constraint(equalTo: textLabel.widthAnchor),
            textLabel.heightAnchor.constraint(equalTo: textLabel.heightAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("coder")
    }
    

}



final class AnimatedPhoneTextField: UIView,UITextInputTraits{
    
    internal var phone: Phone = (["+","6","2"," "],[])

    var text: String{
        return "\(phone)"
    }
    
    var hasText: Bool = false
    var collectionNumbers: UICollectionView!
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    override var canResignFirstResponder: Bool {
        return true
    }
    
    var keyboardType: UIKeyboardType = .numberPad

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        setupCollection()
    }
    
    private func setupCollection(){
        self.collectionNumbers = UICollectionView(frame: self.frame, collectionViewLayout: AnimationTextFieldAttributes())
        collectionNumbers.register(AnimatedTextFieldCell.self, forCellWithReuseIdentifier: "animatedCell")
        collectionNumbers.translatesAutoresizingMaskIntoConstraints = false
        collectionNumbers.backgroundColor = UIColor.clear
        collectionNumbers.delegate = self
        collectionNumbers.dataSource = self
        
        self.addSubview(collectionNumbers)
        
        
        collectionNumbers.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(typeAction)))
        
        NSLayoutConstraint.activate([
            collectionNumbers.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            collectionNumbers.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            collectionNumbers.widthAnchor.constraint(equalTo: self.widthAnchor),
            collectionNumbers.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
    
    @objc func typeAction(){
        if self.isFirstResponder{
            self.resignFirstResponder()
        }else{
            becomeFirstResponder()
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCollection()
    }
    
    public func set(phone: String){
        self.phone = ([],[])
        for (index,char) in phone.enumerated(){
            if index <= 3{
                self.phone.countryCode.append(char)
            }else{
                self.phone.number.append(char)
            }
        }
    }
}

extension AnimatedPhoneTextField: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (phone.countryCode + phone.number).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "animatedCell", for: indexPath) as! AnimatedTextFieldCell
        
        if indexPath.row <= 3{
            cell.number = phone.countryCode[indexPath.row]
            cell.textLabel.textColor = UIColor.gray
        }else{
            cell.number = phone.number[indexPath.row - phone.countryCode.count]
        }
        return cell
    }
}

extension AnimatedPhoneTextField: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 25, height: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return -5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -5
    }
}

extension AnimatedPhoneTextField: UIKeyInput{
    func insertText(_ text: String) {
        collectionNumbers.performBatchUpdates({
            let char = text.first ?? Character("")
            if phone.number.count < 11{
                self.phone.number.append(char)
                collectionNumbers.insertItems(at: [IndexPath(row: (phone.countryCode + phone.number).count - 1, section: 0)])
                
            }
        })
    }
    
    func deleteBackward() {
        collectionNumbers.performBatchUpdates({
            
            if let _ = self.phone.number.popLast(){
                collectionNumbers.deleteItems(at: [IndexPath(row: (phone.countryCode + phone.number).count, section: 0)])
            }
            
            
        }, completion: nil)
    }
}





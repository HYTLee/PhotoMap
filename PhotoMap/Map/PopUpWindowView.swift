//
//  ChoosedPhotoPopUP.swift
//  PhotoMap
//
//  Created by AP Yauheni Hramiashkevich on 2/28/21.
//

import Foundation
import UIKit
import RealmSwift
import CoreLocation

// Settings of view that appear while user chooses photo from galery
class PopUpWindowView: UIView, UITextViewDelegate {
    
    // MARK: Set variables
    var categories = try! Realm().objects(Category.self)
    var category = Category()
    private let dateFormatter = DateFormattering()
    let popupView = UIView(frame: CGRect.zero)
    let popupImage = UIImageView(frame: CGRect.zero)
    let popupDateLabel = UILabel(frame: CGRect.zero)
    let popupTextView = UITextView(frame: CGRect.zero)
    let popupPicker = UIPickerView(frame: CGRect.zero)
    let popupOkButton = UIButton(frame: CGRect.zero)
    let popupCancelButton = UIButton(frame: CGRect.zero)
    let BorderWidth: CGFloat = 2.0

    // MARK: Set all UI elements and theis constraints
    init() {
        super.init(frame: CGRect.zero)
        
        categories = try! Realm().objects(Category.self)
        category.name = "Nature"
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        popupView.backgroundColor = .lightGray
        popupView.layer.borderWidth = BorderWidth
        popupView.layer.masksToBounds = true
        popupView.layer.borderColor = UIColor.gray.cgColor
        
        popupDateLabel.textColor = .black
        popupDateLabel.text = dateFormatter.converDateForImagePickerPopUp(Date())
        
        popupTextView.textColor = UIColor.white
        popupTextView.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        popupTextView.delegate = self
        popupTextView.text = "Enter description for you text"
        popupTextView.textColor = UIColor.lightGray
        popupTextView.textAlignment = .left
        
        popupOkButton.setTitleColor(UIColor.white, for: .normal)
        popupOkButton.setTitle("DONE", for: .normal)
        popupOkButton.setTitleColor(.blue, for: .normal)
        popupOkButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        popupOkButton.backgroundColor = UIColor.lightGray
        
        popupCancelButton.setTitleColor(UIColor.white, for: .normal)
        popupCancelButton.setTitle("CANCEL", for: .normal)
        popupCancelButton.setTitleColor(.red, for: .normal)
        popupCancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        popupCancelButton.backgroundColor = UIColor.lightGray
        
        popupPicker.dataSource = self
        popupPicker.delegate = self
        popupPicker.backgroundColor = .lightGray
        
    
        popupView.addSubview(popupImage)
        popupView.addSubview(popupDateLabel)
        popupView.addSubview(popupTextView)
        popupView.addSubview(popupOkButton)
        popupView.addSubview(popupCancelButton)
        popupView.addSubview(popupPicker)

        addSubview(popupView)
        
        // PopupView constraints
        popupView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupView.widthAnchor.constraint(equalToConstant: 400),
            popupView.heightAnchor.constraint(equalToConstant: 580),
            popupView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            popupView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
                    ])
        
        // ImageView constraints
        popupImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupImage.heightAnchor.constraint(equalToConstant: 300),
            popupImage.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 5),
            popupImage.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 5),
            popupImage.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -5),

        ])
        
        // DateLabel constraints
        popupDateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupDateLabel.heightAnchor.constraint(equalToConstant: 20),
            popupDateLabel.topAnchor.constraint(equalTo: popupImage.bottomAnchor, constant: 15),
            popupDateLabel.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 5),
            popupDateLabel.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -5),
        ])
        
        // TextView constraints
        popupTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupTextView.heightAnchor.constraint(equalToConstant: 100),
            popupTextView.topAnchor.constraint(equalTo: popupPicker.bottomAnchor),
            popupTextView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 5),
            popupTextView.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -5),
        ])
        
        popupPicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupPicker.heightAnchor.constraint(equalToConstant: 100),
            popupPicker.widthAnchor.constraint(equalTo: popupView.widthAnchor, multiplier: 1),
            popupPicker.topAnchor.constraint(equalTo: popupDateLabel.bottomAnchor),
            popupPicker.leadingAnchor.constraint(equalTo: popupView.leadingAnchor)
        ])
        
        // Cancel button constraints
        popupCancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupCancelButton.heightAnchor.constraint(equalToConstant: 40),
            popupCancelButton.widthAnchor.constraint(equalToConstant: 120),
            popupCancelButton.topAnchor.constraint(equalTo: popupTextView.bottomAnchor),
            popupCancelButton.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 40)
        ])
        
        // Ok button constraints
        popupOkButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupOkButton.heightAnchor.constraint(equalToConstant: 40),
            popupOkButton.widthAnchor.constraint(equalToConstant: 120),
            popupOkButton.topAnchor.constraint(equalTo: popupTextView.bottomAnchor),
            popupOkButton.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -40)
        ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Working with textView delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
                textView.text = nil
                textView.textColor = UIColor.black
            }
    }
}

// MARK: Working with PickerView
extension PopUpWindowView: UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        category.name = categories[row].name
    }
    
}




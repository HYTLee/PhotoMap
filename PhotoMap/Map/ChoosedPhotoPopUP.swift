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

 class PopUpWindowView: UIView {
    
    let popupView = UIView(frame: CGRect.zero)
    let popupImage = UIImageView(frame: CGRect.zero)
    let popupTextView = UITextView(frame: CGRect.zero)
    let popupOkButton = UIButton(frame: CGRect.zero)
    let popupCancelButton = UIButton(frame: CGRect.zero)
    let BorderWidth: CGFloat = 2.0

    
    init() {
        super.init(frame: CGRect.zero)
        
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
        popupView.backgroundColor = .black
        popupView.layer.borderWidth = BorderWidth
        popupView.layer.masksToBounds = true
        popupView.layer.borderColor = UIColor.gray.cgColor
        
        popupTextView.textColor = UIColor.white
        popupTextView.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        popupTextView.textAlignment = .center
        popupTextView.textAlignment = .left
        popupTextView.textColor = .black
//        popupTextView.text = "Enter the story for the photo"
//        popupTextView.textColor = UIColor.lightGray
//        popupTextView.becomeFirstResponder()
//        popupTextView.selectedTextRange = popupTextView.textRange(from: popupTextView.beginningOfDocument, to: popupTextView.beginningOfDocument)
        
        
        popupOkButton.setTitleColor(UIColor.white, for: .normal)
        popupOkButton.setTitle("OK", for: .normal)
        popupOkButton.titleLabel?.font = UIFont.systemFont(ofSize: 23.0, weight: .bold)
        popupOkButton.backgroundColor = UIColor.black
        
        popupCancelButton.setTitleColor(UIColor.white, for: .normal)
        popupCancelButton.setTitle("Cancel", for: .normal)
        popupCancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 23.0, weight: .bold)
        popupCancelButton.backgroundColor = UIColor.black
        
        popupView.addSubview(popupImage)
        popupView.addSubview(popupTextView)
        popupView.addSubview(popupOkButton)
        popupView.addSubview(popupCancelButton)

        addSubview(popupView)
        
        // PopupView constraints
        popupView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupView.widthAnchor.constraint(equalToConstant: 400),
            popupView.heightAnchor.constraint(equalToConstant: 440),
            popupView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            popupView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
                    ])
        
        // ImageView constraints
        popupImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupImage.heightAnchor.constraint(equalToConstant: 300),
            popupImage.widthAnchor.constraint(equalTo: popupView.widthAnchor, multiplier: 1),
            popupImage.topAnchor.constraint(equalTo: popupView.topAnchor),
            popupImage.leadingAnchor.constraint(equalTo: popupView.leadingAnchor)
        ])
        
        // TextView constraints
        popupTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupTextView.heightAnchor.constraint(equalToConstant: 100),
            popupTextView.widthAnchor.constraint(equalTo: popupView.widthAnchor, multiplier: 1),
            popupTextView.topAnchor.constraint(equalTo: popupImage.bottomAnchor),
            popupTextView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor)
        ])
        
        // Ok button constraints
        popupOkButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupOkButton.heightAnchor.constraint(equalToConstant: 40),
            popupOkButton.widthAnchor.constraint(equalToConstant: 140),
            popupOkButton.topAnchor.constraint(equalTo: popupTextView.bottomAnchor),
            popupOkButton.leadingAnchor.constraint(equalTo: popupView.leadingAnchor)
        ])
        
        // Cancel button constraints
        popupCancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupCancelButton.heightAnchor.constraint(equalToConstant: 40),
            popupCancelButton.widthAnchor.constraint(equalToConstant: 140),
            popupCancelButton.topAnchor.constraint(equalTo: popupTextView.bottomAnchor),
            popupCancelButton.trailingAnchor.constraint(equalTo: popupView.trailingAnchor)
        ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}




//
//  UIViewExtentions.swift
//  PhotoMap
//
//  Created by AP Yauheni Hramiashkevich on 3/13/21.
//

import Foundation
import UIKit

extension UIView {
  func addTapGesture(tapNumber: Int, target: Any, action: Selector) {
    let tap = UITapGestureRecognizer(target: target, action: action)
    tap.numberOfTapsRequired = tapNumber
    addGestureRecognizer(tap)
    isUserInteractionEnabled = true
  }
}

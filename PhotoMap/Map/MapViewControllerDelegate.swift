//
//  MapViewControllerDelegate.swift
//  PhotoMap
//
//  Created by AP Yauheni Hramiashkevich on 3/1/21.
//

import Foundation

protocol MapViewControllerDelegate: class {
    func filterAnnotations(categories: [String])
}

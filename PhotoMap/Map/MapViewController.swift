//
//  ViewController.swift
//  PhotoMap
//
//  Created by AP Yauheni Hramiashkevich on 2/25/21.
//

import UIKit
import MapKit
import AVFoundation
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    let mapView = MKMapView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
    var locationManager: CLLocationManager?
    var choosedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setMapView()
        self.setNavigationBar()
        self.determineCurrentLocation()
    }

    private func setMapView()  {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0),
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0),
        mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0),
        mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0.0)
        ])
    }
    
    func setNavigationBar()  {
        let type = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(openCategories))
        let camera = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(openCamera))
        navigationItem.rightBarButtonItems = [type, camera]
    }
    
    @objc func openCategories(){
        
    }
    
    @objc func openCamera(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let openCameraButton = UIAlertAction(title: "Open Camera", style: .default) { (_) in
            self.showImagePickerController(sourceType: .camera)
        }
        let openGaleryButton = UIAlertAction(title: "Open Galery", style: .default) { [self] (_) in
            showImagePickerController(sourceType: .photoLibrary)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            print("Canceled")
        }
        
        alertController.addAction(openCameraButton)
        alertController.addAction(openGaleryButton)
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func determineCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        locationManager?.distanceFilter = 20
       }
    
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
        }
    }
}


extension MapViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func showImagePickerController(sourceType: UIImagePickerController.SourceType)  {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
                                info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.choosedImage = editedImage
        } else if let originImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.choosedImage = originImage
        }

    }
}


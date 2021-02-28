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
import RealmSwift

class MapViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate {
    
    let mapView = MKMapView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
    var locationManager: CLLocationManager?
    var choosedImage: UIImage?
    var choosedLocation: CLLocation?
    var fileURL: URL?
    var photos = try! Realm().objects(Photo.self)
    var popUpWindow =  PopUpWindow(image: UIImage(named: "tree")!)


    
    let realm = try! Realm()
    lazy var categories: Results<Category> = { self.realm.objects(Category.self) }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setMapView()
        self.setNavigationBar()
        self.determineCurrentLocation()
        self.populateDefaultCategories()
        self.updateAnnotations()
        self.tapHandlerInit()

    }
    
    private func setMapView()  {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mapView)
        self.mapView.delegate = self

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
        self.openSourceForPhotoAlert(sourceOfLocation: .curentLocation)
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
    private func populateDefaultCategories() {
      if categories.count == 0 {
        try! realm.write() {
          let defaultCategories =
            ["Nature", "Friends", "Default" ]
    
          for category in defaultCategories {
            let newCategory = Category()
            newCategory.name = category
            realm.add(newCategory)
          }
        }
        categories = realm.objects(Category.self)
      }
    }
    
    func saveImageToLocalStorage(image: UIImage)  {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let fileName = "image\(Date()).jpg"
        self.fileURL = documentsDirectory.appendingPathComponent(fileName)

        if let data = image.jpegData(compressionQuality:  1.0),
           !FileManager.default.fileExists(atPath: fileURL!.path) {
            do {
                // writes the image data to disk
                try data.write(to: fileURL!)
                print("file saved")
            } catch {
                print("error saving file:", error)
            }
        }
    }
    
    
    func updateAnnotations()  {
        mapView.removeAnnotations(mapView.annotations)
        photos = try! Realm().objects(Photo.self)
        for photo in photos {
            let coordinates = CLLocationCoordinate2D(latitude: photo.latitude, longitude: photo.longitude)
            let photoAnnotation = PhotoAnnotation(coordinate: coordinates, text: photo.imageDescription, photo: photo)
            mapView.addAnnotation(photoAnnotation)
        }
    }
    
    func tapHandlerInit()  {
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleTap))
            gestureRecognizer.delegate = self
            mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
        
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        self.choosedLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        openSourceForPhotoAlert(sourceOfLocation: .mapAnnotation)
    }
    
    
    func openSourceForPhotoAlert(sourceOfLocation: SourceOfLocation)  {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let openCameraButton = UIAlertAction(title: "Open Camera", style: .default) { (_) in
            self.showImagePickerController(sourceType: .camera, sourceOfLocation: sourceOfLocation)
        }
        let openGaleryButton = UIAlertAction(title: "Open Galery", style: .default) { [self] (_) in
            showImagePickerController(sourceType: .photoLibrary, sourceOfLocation: sourceOfLocation)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            print("Canceled")
        }
        
        alertController.addAction(openCameraButton)
        alertController.addAction(openGaleryButton)
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension MapViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func showImagePickerController(sourceType: UIImagePickerController.SourceType, sourceOfLocation: SourceOfLocation)  {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        switch sourceOfLocation {
        case .curentLocation:
            choosedLocation = locationManager?.location
        case .mapAnnotation: break
            
        }
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
                                info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true) { [self] in
            if self.choosedImage != nil {
                popUpWindow = PopUpWindow(image: ((self.choosedImage ?? UIImage(contentsOfFile: fileURL!.absoluteString))!))
                popUpWindow.popUpWindowView.popupCancelButton.addTarget(self, action: #selector(cancelPopUPWithoutSaving), for: .touchUpInside)
                popUpWindow.popUpWindowView.popupOkButton.addTarget(self, action: #selector(okActionOnPopUp), for: .touchUpInside)

                popUpWindow.currentLocation = self.choosedLocation
                popUpWindow.imageURL = self.fileURL?.absoluteString
                self.present(popUpWindow, animated: true, completion: nil)
            }
       
        }
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.choosedImage = editedImage
            saveImageToLocalStorage(image: choosedImage!)
        } else if let originImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.choosedImage = originImage
            saveImageToLocalStorage(image: choosedImage!)
        }
    }
    
    @objc func cancelPopUPWithoutSaving(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func okActionOnPopUp(){
        popUpWindow.addNewPhotoRecord()
        self.updateAnnotations()
        self.dismiss(animated: true, completion: nil)
    }
    
    
}


extension MapViewController: MKMapViewDelegate {
    
     func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
//            annotationView.markerTintColor = UIColor.blue
        
        guard annotation is PhotoAnnotation else { return nil }

        let identifier = "Photo"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
    
        if annotationView == nil {

                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            
                let btn = UIButton(type: .detailDisclosure)
                annotationView?.rightCalloutAccessoryView = btn
            } else {
                annotationView?.annotation = annotation
            }

            return annotationView
        }
    

}


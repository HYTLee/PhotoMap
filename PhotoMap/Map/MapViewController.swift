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

class MapViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate, MapViewControllerDelegate {
    
    private let defaults = UserDefaults.standard
    private let imageLoader = ImageLoader()
    private let imageResizer = ImageResizer()
    let mapView = MKMapView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
    var locationManager: CLLocationManager?
    var choosedImage: UIImage?
    var choosedLocation: CLLocation?
    var photos = try! Realm().objects(Photo.self)
    var popUpWindow =  PopUpWindow(image: UIImage(named: "tree")!)
    var filteredCategories: [String] = [""]
    let centerOfCurrentLocationImage = UIImageView(frame: CGRect.zero)
    var trackingMode: TrackingMode = .discover
    
    // Bar button item to change after interraction
    var followType = UIBarButtonItem()
    var discoveryType = UIBarButtonItem()
    var camera = UIBarButtonItem()
    
    let realm = try! Realm()
    lazy var categories: Results<Category> = { self.realm.objects(Category.self) }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setMapView()
        self.setNavigationBar()
        self.determineCurrentLocation()
        self.populateDefaultCategories()
        self.readRowsFormUserDefaults()
        self.tapHandlerInit()
        self.setLocationCenterImage()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.updateAnnotations()
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
        
        self.checkForTrackingMode()
    }
    
    func setNavigationBar()  {
        
        followType = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(changeTypeOfMap))
        discoveryType = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(changeTypeOfMap))
        camera = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(openCamera))
        navigationItem.rightBarButtonItems = [discoveryType, camera]
        let categoryButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(openCategoryViewController))
        navigationItem.leftBarButtonItem = categoryButton
    }
    
    func checkForTrackingMode()  {
        switch trackingMode {
        case .follow:
            centerOfCurrentLocationImage.isHidden = false
            mapView.isScrollEnabled = false
            self.determineCurrentLocation()
        case .discover:
            centerOfCurrentLocationImage.isHidden = true
            mapView.isScrollEnabled = true
        }
    }
    
    @objc func changeTypeOfMap(){
        
        if trackingMode == .discover {
            trackingMode = .follow
            self.checkForTrackingMode()
            navigationItem.setRightBarButtonItems([followType, camera], animated: false)
        }
        else if trackingMode == .follow {
            trackingMode = .discover
            self.checkForTrackingMode()
            navigationItem.setRightBarButtonItems([discoveryType, camera], animated: false)
        }
        
    }
    
    @objc func openCamera(){
        self.openSourceForPhotoAlert(sourceOfLocation: .curentLocation)
    }
    
    @objc func openCategoryViewController(){
        let categoryViewController = CategoryViewController()
        categoryViewController.hidesBottomBarWhenPushed = true
        categoryViewController.delegate = self
        self.navigationController?.pushViewController(categoryViewController, animated: true)
    }
    
    private func setLocationCenterImage() {
        self.centerOfCurrentLocationImage.translatesAutoresizingMaskIntoConstraints = false
        self.centerOfCurrentLocationImage.image = UIImage(named: "center")
        self.centerOfCurrentLocationImage.clipsToBounds = true
        self.mapView.addSubview(centerOfCurrentLocationImage)
        
        NSLayoutConstraint.activate([
        centerOfCurrentLocationImage.centerYAnchor.constraint(equalTo: self.mapView.centerYAnchor, constant: 0.0),
        centerOfCurrentLocationImage.centerXAnchor.constraint(equalTo: self.mapView.centerXAnchor, constant: 0.0),
        centerOfCurrentLocationImage.heightAnchor.constraint(equalToConstant: 20),
        centerOfCurrentLocationImage.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func determineCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        locationManager?.distanceFilter = 20
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.startUpdatingLocation()
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
    
    private func readRowsFormUserDefaults()  {
        filteredCategories = defaults.object(forKey: "categories") as? [String] ?? [""]
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
        }

    }

    
    func updateAnnotations()  {
        mapView.removeAnnotations(mapView.annotations)
        photos = try! Realm().objects(Photo.self)
        if filteredCategories != [""]{
            for category in filteredCategories {
                for photo in photos {
                    if photo.category == category {
                    let coordinates = CLLocationCoordinate2D(latitude: photo.latitude, longitude: photo.longitude)
                    let photoAnnotation = PhotoAnnotation(coordinate: coordinates, photo: photo)
                    mapView.addAnnotation(photoAnnotation)
                    }
                }
            }
        }
    }
        
    func filterAnnotations(categories: [String]) {
        mapView.removeAnnotations(mapView.annotations)
        photos = try! Realm().objects(Photo.self)
        self.filteredCategories = categories
        updateAnnotations()
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
                popUpWindow = PopUpWindow(image: ((self.choosedImage ?? UIImage(contentsOfFile: imageLoader.fileURL!.absoluteString))!))
                popUpWindow.popUpWindowView.popupCancelButton.addTarget(self, action: #selector(cancelPopUPWithoutSaving), for: .touchUpInside)
                popUpWindow.popUpWindowView.popupOkButton.addTarget(self, action: #selector(okActionOnPopUp), for: .touchUpInside)

                popUpWindow.currentLocation = self.choosedLocation
                popUpWindow.imageName = imageLoader.fileName
                self.present(popUpWindow, animated: true, completion: nil)
            }
       
        }
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.choosedImage = editedImage
            imageLoader.saveImageToLocalStorage(image: choosedImage!)
        } else if let originImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.choosedImage = originImage
            imageLoader.saveImageToLocalStorage(image: choosedImage!)
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
                
        guard annotation is PhotoAnnotation else { return nil }
        
        let photoAnnotation =  annotation as! PhotoAnnotation

        let identifier = "Photo"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)  as? MKMarkerAnnotationView
            
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.glyphImage = UIImage()
                annotationView?.titleVisibility = MKFeatureVisibility.hidden
            
           switch photoAnnotation.text {
            case "Default":
                annotationView?.markerTintColor = .blue
           
            case "Nature":
                annotationView?.markerTintColor = .green

            case "Friends":
                annotationView?.markerTintColor = .yellow

            default:
                annotationView?.markerTintColor = .blue
            }
            
            let imageView = UIImageView()
            imageView.sizeToFit()
            let originalImage = imageLoader.loadImageFromDiskWith(fileName: photoAnnotation.photo!.imageName)!
            let resizedImage = imageResizer.resizeImage(image: originalImage, targetSize: CGSize(width: 70, height: 200))
            imageView.image = resizedImage
            imageView.sizeToFit()
            annotationView?.leftCalloutAccessoryView = imageView
           
            return annotationView
    }

}


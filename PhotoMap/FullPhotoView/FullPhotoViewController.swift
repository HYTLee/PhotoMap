//
//  FullPhotoViewController.swift
//  PhotoMap
//
//  Created by AP Yauheni Hramiashkevich on 3/13/21.
//

import UIKit

// View that appears while user chooses cell in timeline table view 
class FullPhotoViewController: UIViewController {
    
    // MARK: setting variables
    let fullPhotoImageView = UIImageView(frame: CGRect.zero)
    let viewForDescription = UIView(frame: CGRect.zero)
    let scrollView = UIScrollView(frame: CGRect.zero)
    let desciptionLabel = UILabel(frame: CGRect.zero)
    let dateLabel = UILabel(frame: CGRect.zero)
    var photo: Photo? = nil
    
    private let dateFormatter = DateFormattering()
    private let imageLoader = ImageLoader()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setScrollView()
        self.setFullPhotoImage()
        self.setViewForDescription()
        self.setDescriptionLabel()
        self.setDateLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Make the navigation bar background clear
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor(white: 0.1, alpha: 0.8)
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Restore the navigation bar to default
        self.navigationController?.navigationBar.tintColor = UIColor.systemBlue
        self.navigationController?.navigationBar.barTintColor = UIColor(white: 1, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false


    }
    
    // MARK: Setting all UI elements and constraints
    private func setScrollView(){
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollView)
        self.scrollView.maximumZoomScale = 4
        self.scrollView.minimumZoomScale = 1
        self.scrollView.delegate = self
        
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
        ])
    }
    
    private func setFullPhotoImage(){
        self.fullPhotoImageView.sizeToFit()
        self.fullPhotoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(fullPhotoImageView)
        self.fullPhotoImageView.backgroundColor = .gray
        if photo?.imageName != nil {
            self.fullPhotoImageView.image = imageLoader.loadImageFromDiskWith(fileName: photo?.imageName ?? "")
        }
        self.fullPhotoImageView.addTapGesture(tapNumber: 1, target: self, action: #selector(handleTap))
        
        NSLayoutConstraint.activate([
            fullPhotoImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            fullPhotoImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            fullPhotoImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            fullPhotoImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
        ])
    }
    
    private func setViewForDescription(){
        self.viewForDescription.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(viewForDescription)
        self.viewForDescription.backgroundColor = UIColor(white: 0.1, alpha: 0.8)
        
        NSLayoutConstraint.activate([
            viewForDescription.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            viewForDescription.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            viewForDescription.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            viewForDescription.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func setDescriptionLabel() {
        self.desciptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.viewForDescription.addSubview(desciptionLabel)
        self.desciptionLabel.numberOfLines = 2
        self.desciptionLabel.textColor = .white
        self.desciptionLabel.text = self.photo?.imageDescription
        
        NSLayoutConstraint.activate([
            desciptionLabel.leadingAnchor.constraint(equalTo: self.viewForDescription.leadingAnchor, constant: 20),
            desciptionLabel.trailingAnchor.constraint(equalTo: self.viewForDescription.trailingAnchor, constant: -20),
            desciptionLabel.topAnchor.constraint(equalTo: self.viewForDescription.topAnchor, constant: 10),
            desciptionLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setDateLabel() {
        self.dateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.viewForDescription.addSubview(dateLabel)
        self.dateLabel.numberOfLines = 1
        self.dateLabel.textColor = .white
        self.dateLabel.text = "\(dateFormatter.converDateForFullPhotoScreenFirstPart(self.photo?.created ?? Date())) at \(dateFormatter.converDateForFullPhotoScreenSecondPart(self.photo?.created ?? Date()))"
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: self.viewForDescription.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: self.viewForDescription.trailingAnchor, constant: -20),
            dateLabel.topAnchor.constraint(equalTo: self.desciptionLabel.bottomAnchor, constant: 10),
            dateLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // Hide all view except image view by taping on image view 
    @objc func handleTap() {
        switch viewForDescription.isHidden {
        case true:
            viewForDescription.isHidden = false
            self.navigationController?.navigationBar.isHidden = false
        case false:
            viewForDescription.isHidden = true
            self.navigationController?.navigationBar.isHidden = true
        }
       }
    
}

extension FullPhotoViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return fullPhotoImageView
    }
}

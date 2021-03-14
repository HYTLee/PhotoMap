//
//  TimelineViewController.swift
//  PhotoMap
//
//  Created by AP Yauheni Hramiashkevich on 2/25/21.
//

import UIKit
import RealmSwift

// TimeLine View Controller
class TimelineViewController: UIViewController {
    
    // MARK: Set variables
    private let imageLoader = ImageLoader()
    private var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 250, height: 20))
    private let defaults = UserDefaults.standard
    private var filteredCategories: [String] = [""]
    private var photosFromReal = try! Realm().objects(Photo.self)
    private var photos:[Photo] = []
    private let timeLineTableView = UITableView(frame: CGRect.zero)
    private let dateFormatter = DateFormattering()
    var photosForTimeLine: [TimeLinePhoto] = []
    var timeLineFilteredPhotos:[String:[TimeLinePhoto]] = [:]
    var monthAndYearDates: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar()
        self.timeLineTableView.register(TimelineCell.self, forCellReuseIdentifier: "TimelineCell")
        self.setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.appendPhotosArray()
        self.fullFilltimeLinePhotos()
        self.filterPhotosForTimeLine()
        self.timeLineTableView.reloadData()
        }
  
    // MARK: Set UI elements and their constraints
    private func setSearchBar() {
        self.searchBar.placeholder = "Filter photos"
        self.searchBar.delegate = self

    }
    
    func setTableView()  {
        timeLineTableView.translatesAutoresizingMaskIntoConstraints = false
        timeLineTableView.delegate = self
        timeLineTableView.allowsMultipleSelection = true
        timeLineTableView.dataSource = self
        timeLineTableView.tableFooterView = UIView()

        self.view.addSubview(timeLineTableView)
    
        NSLayoutConstraint.activate([
        timeLineTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0),
        timeLineTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0),
        timeLineTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0),
        timeLineTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0.0)
        ])
    }
    
    private func setNavigationBar()  {
        self.setSearchBar()
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        let category = UIBarButtonItem(title: "Category", style: .done, target: self, action: #selector(openCategoriesScreen))
        navigationItem.rightBarButtonItem = category
            }
    
    @objc func openCategoriesScreen(){
        let categoryViewController = CategoryViewController()
        categoryViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(categoryViewController, animated: true)
    }
    
    //MARK: Obtainig data from realm data base and filtrating this data
    private func readCategoriesFormUserDefaults()  {
        filteredCategories = []
        filteredCategories = defaults.object(forKey: "categories") as? [String] ?? [""]
    }
    
    func appendPhotosArray()  {
        photos = []
        for photo in photosFromReal {
            photos.append(photo)
        }
        photos.sort { $0.created > $1.created }
    }
    
    private func fullFilltimeLinePhotos(){
        photosForTimeLine = []
        self.readCategoriesFormUserDefaults()
        for photo in photos {
            let timelinePhoto = TimeLinePhoto(photo: photo)
            for category in filteredCategories {
                if timelinePhoto.photo.category == category {
                    photosForTimeLine.append(timelinePhoto)
                }
            }
        }
    }
    
    func filterPhotosForTimeLine()  {
        self.timeLineFilteredPhotos = [:]
        self.monthAndYearDates = []
        for photo in photosForTimeLine {
            var timeLinePhotos = timeLineFilteredPhotos[photo.creationMonthAndYear] ?? []
            if timeLinePhotos.count == 0 {
                monthAndYearDates.append(photo.creationMonthAndYear)
                timeLineFilteredPhotos[photo.creationMonthAndYear] = [photo]
          } else {
            timeLinePhotos.append(photo)
            timeLineFilteredPhotos[photo.creationMonthAndYear] = timeLinePhotos
          }
        }
    }
}

//MARK: Setting data for table view
extension TimelineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeLineFilteredPhotos[monthAndYearDates[section]]?.count ?? 0

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: "TimelineCell") as! TimelineCell
        DispatchQueue.global().async { [self] in
            let value = timeLineFilteredPhotos[self.monthAndYearDates[indexPath.section]]
            DispatchQueue.main.async {
                categoryCell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
                categoryCell.photoDescriptionLabel.text = value?[indexPath.row].photo.imageDescription
                categoryCell.photoView.image = imageLoader.loadImageFromDiskWith(fileName: (value?[indexPath.row].photo.imageName)!)
                categoryCell.photoDateLabel.text = "\(dateFormatter.convertDateToDMYFormat((value?[indexPath.row].photo.created)!)) / \(value?[indexPath.row].photo.category ?? "") "
            }
        }
    
        return categoryCell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return timeLineFilteredPhotos.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       return tableView.dataSource?.tableView(tableView, numberOfRowsInSection: section) == 0 ? nil: monthAndYearDates[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = timeLineFilteredPhotos[monthAndYearDates[indexPath.section]]
        let fullPhotoViewController = FullPhotoViewController()
        fullPhotoViewController.photo = value?[indexPath.row].photo
        fullPhotoViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(fullPhotoViewController, animated: true)
    }
}

//MARK: Setting method to filtrate table view while searching via searbar
extension TimelineViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            self.appendPhotosArray()
            photos = photos.filter{ $0.imageDescription.contains(searchText)
            }
            self.fullFilltimeLinePhotos()
            self.filterPhotosForTimeLine()
            self.timeLineTableView.reloadData()
        }
        else {
            self.appendPhotosArray()
            self.fullFilltimeLinePhotos()
            self.filterPhotosForTimeLine()
            self.timeLineTableView.reloadData()
        }
        }
    
}

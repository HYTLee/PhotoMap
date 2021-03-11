//
//  CategoryViewController.swift
//  PhotoMap
//
//  Created by AP Yauheni Hramiashkevich on 3/1/21.
//

import UIKit
import RealmSwift

class CategoryViewController: UIViewController {
    
   private let defaults = UserDefaults.standard
    let categoryTableView = UITableView(frame: CGRect.zero)
    var categories = try! Realm().objects(Category.self)
    var choosedCategories = [""]
    var choosedRows: [Int] = []
    weak var delegate: MapViewControllerDelegate?


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setTableView()
        self.setNavigationBar()
        self.categories = try! Realm().objects(Category.self)
        self.categoryTableView.register(CountryTableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        self.readRowsFormUserDefaults()
        self.setSelectedRowsAfterReloadingViewController()
    }
    
    
    func setTableView()  {
        categoryTableView.translatesAutoresizingMaskIntoConstraints = false
        categoryTableView.delegate = self
        categoryTableView.allowsMultipleSelection = true
        categoryTableView.dataSource = self
        self.view.addSubview(categoryTableView)
    
        NSLayoutConstraint.activate([
        categoryTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0),
        categoryTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0),
        categoryTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0),
        categoryTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0.0)
        ])
    }
    
    func setNavigationBar(){
        self.navigationItem.title = "Categories"
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func doneAction(){
        delegate?.filterAnnotations(categories: choosedCategories)
        self.navigationController?.popViewController(animated: true)
        saveRowsToUserDefaults()
    }
    
    
    func saveRowsToUserDefaults()  {
        defaults.setValue(choosedRows, forKey: "rows")
        defaults.setValue(choosedCategories, forKey: "categories")
    }
    
    func readRowsFormUserDefaults()  {
        choosedRows = defaults.object(forKey:"rows") as? [Int] ?? []
        choosedCategories = defaults.object(forKey: "categories") as? [String] ?? [""]
    }
    
    func setSelectedRowsAfterReloadingViewController()  {
        if choosedRows != []{
            for row in choosedRows {
                categoryTableView.selectRow(at: IndexPath(row: row, section: 0), animated: true, scrollPosition: .top)
            }
        }
    }
}


extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CountryTableViewCell
        categoryCell.categoryNameLabel.text = "\(categories[indexPath.row].name)"
        switch categoryCell.categoryNameLabel.text {
        case "Nature":
            categoryCell.circleView.layer.borderColor = UIColor.green.cgColor
        case "Friends":
            categoryCell.circleView.layer.borderColor = UIColor.yellow.cgColor
        case "Default":
            categoryCell.circleView.layer.borderColor = UIColor.blue.cgColor
        default:
            break
        }
        if choosedRows != []{
            for row in choosedRows {
                if indexPath.row == row {
                    categoryCell.circleView.backgroundColor = UIColor(cgColor: categoryCell.circleView.layer.borderColor!)
                }
            }
        }
        
        return categoryCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = categoryTableView.cellForRow(at: indexPath) as! CountryTableViewCell
        selectedCell.circleView.backgroundColor = UIColor(cgColor: selectedCell.circleView.layer.borderColor!)
        self.choosedCategories.append(selectedCell.categoryNameLabel.text!)
        self.choosedRows.append(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let deselectedCell = categoryTableView.cellForRow(at: indexPath) as! CountryTableViewCell
        deselectedCell.circleView.backgroundColor = .white
        self.choosedCategories = choosedCategories.filter(){$0 != deselectedCell.categoryNameLabel.text}
        self.choosedRows = choosedRows.filter(){$0 != indexPath.row}
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

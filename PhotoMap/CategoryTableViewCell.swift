//
//  CategoryTableViewCell.swift
//  PhotoMap
//
//  Created by AP Yauheni Hramiashkevich on 3/1/21.
//

import UIKit

class CountryTableViewCell: UITableViewCell {
    
    let categoryNameLabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
          super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.setCaseLabel()
      }
      
      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCaseLabel() {
        categoryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(categoryNameLabel)
        
        NSLayoutConstraint.activate([
            categoryNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            categoryNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            categoryNameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    

}

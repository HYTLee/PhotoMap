//
//  CategoryTableViewCell.swift
//  PhotoMap
//
//  Created by AP Yauheni Hramiashkevich on 3/1/21.
//

import UIKit

class CountryTableViewCell: UITableViewCell {
    
    let categoryNameLabel = UILabel()
    
    let circleView = UIView(frame: CGRect(x: 210, y: 10, width: 50, height: 50))

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
          super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.setCaseLabel()
            self.setCircleView()
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
            categoryNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 80),
            categoryNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            categoryNameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    override func prepareForReuse() {
        circleView.backgroundColor = .white
    }
    
    func setCircleView()  {
        circleView.translatesAutoresizingMaskIntoConstraints = false
        circleView.backgroundColor = .white
        circleView.layer.borderWidth = 3
        circleView.layer.borderColor = UIColor.red.cgColor
        circleView.clipsToBounds = true
        circleView.layer.masksToBounds = true
        contentView.addSubview(circleView)

        NSLayoutConstraint.activate([
            circleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            circleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            circleView.heightAnchor.constraint(equalToConstant: 50),
            circleView.widthAnchor.constraint(equalToConstant: 50)
        ])
        circleView.layer.cornerRadius = circleView.frame.size.width/2

        
    }
}

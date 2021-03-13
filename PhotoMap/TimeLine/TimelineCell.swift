//
//  TimelineCell.swift
//  PhotoMap
//
//  Created by AP Yauheni Hramiashkevich on 3/12/21.
//

import UIKit

class TimelineCell: UITableViewCell {

    let photoDescriptionLabel = UILabel()
    let photoDateLabel = UILabel()

    let photoView = UIImageView(frame: CGRect(x: 210, y: 10, width: 50, height: 50))

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
          super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.setPhotoDescriptionLabel()
            self.setPhotoView()
            self.setPhotoDateLabel()
      }
      
      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setPhotoDescriptionLabel() {
        photoDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(photoDescriptionLabel)
        
        NSLayoutConstraint.activate([
            photoDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 80),
            photoDescriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            photoDescriptionLabel.heightAnchor.constraint(equalToConstant: 20),
            photoDescriptionLabel.widthAnchor.constraint(equalToConstant: 250)

        ])
    }
    
    func setPhotoDateLabel() {
        photoDateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(photoDateLabel)
        
        NSLayoutConstraint.activate([
            photoDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 80),
            photoDateLabel.topAnchor.constraint(equalTo: photoDescriptionLabel.bottomAnchor, constant: 5),
            photoDateLabel.heightAnchor.constraint(equalToConstant: 20),
            photoDateLabel.widthAnchor.constraint(equalToConstant: 250)

        ])
    }
    
    override func prepareForReuse() {
        photoView.image = nil
    }
    
    func setPhotoView()  {
        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoView.backgroundColor = .white
        photoView.clipsToBounds = true
        photoView.layer.masksToBounds = true
        contentView.addSubview(photoView)

        NSLayoutConstraint.activate([
            photoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            photoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            photoView.heightAnchor.constraint(equalToConstant: 70),
            photoView.widthAnchor.constraint(equalToConstant: 70)
        ])

        
    }

}

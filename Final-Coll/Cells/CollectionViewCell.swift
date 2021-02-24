//
//  CollectionViewCell.swift
//  Final-Coll
//
//  Created by ECENUR on 21.02.2021.
//

import UIKit
import Nuke

class CollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CollectionViewCell"
    
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCellShadow()
    }
    static func nib() -> UINib {
        return UINib(nibName: "CollectionViewCell", bundle: nil)
    }

    public func configure(with movie: Result){
        //Example link of a image:
        //https://image.tmdb.org/t/p/original/ueoUHgATjj7ePyOZbFmBFzB3kHi.jpg
        if let path = movie.posterPath {
                downImageWithNuke(path: path)
            }
            else{
                self.img.image = UIImage(named: "nopic.png")
            }
    }

    func downImageWithNuke(path: String) {
        let mPath = "https://image.tmdb.org/t/p/original" + path
        let url = URL(string: mPath)
        Nuke.loadImage(with: url!, into: self.img)
    }
    //Customize movie images
    func setCellShadow() {
        let radius: CGFloat = 7
        contentView.layer.cornerRadius = radius
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 0.5, height: 1.5)
        layer.shadowRadius = 3.0
        layer.shadowOpacity = 1
        layer.masksToBounds = false
        layer.cornerRadius = radius
    }
}

//
//  CollectionViewCell.swift
//  Final-Coll
//
//  Created by ECENUR on 21.02.2021.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var lbl: UILabel!
    
    static let identifier = "CollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(with movie: Result){
        //Example link of a image:
        //https://image.tmdb.org/t/p/original/ueoUHgATjj7ePyOZbFmBFzB3kHi.jpg
        if let path = movie.posterPath {
            let mPath = "https://image.tmdb.org/t/p/original" + path
            let url = URL(string: mPath)
            let data = try! Data(contentsOf: url!)
            self.img.image = UIImage(data: data)
        }
        else{
            self.img.image = UIImage(named: "nopic.png")
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "CollectionViewCell", bundle: nil)
    }

}

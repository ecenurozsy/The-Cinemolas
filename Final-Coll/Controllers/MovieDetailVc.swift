//
//  MovieDetailVc.swift
//  Final-Coll
//
//  Created by ECENUR on 21.02.2021.
//

import UIKit
import Nuke


class MovieDetailVc: UIViewController {

    @IBOutlet weak var lblMovieTitle: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var forwardImg: UIImageView!
    @IBOutlet weak var txtDetail: UITextView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblStar: UILabel!
    @IBOutlet weak var lblLanguage: UILabel!
    
    @IBOutlet weak var imgAdult: UIImageView!
    var movie: Result?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }
    
    func setData(){
        
        if movie?.adult == true {
            imgAdult.image = UIImage(named: "adultY.png")
        }else{
            imgAdult.image = UIImage(named: "adultN.png")
        }
        lblMovieTitle.text = movie?.originalTitle
        txtDetail.text = movie?.overview
        lblDate.text = movie?.releaseDate
        if let voteAverage = movie?.voteAverage{
            lblStar.text = String(voteAverage) + "/10"
        }
        else{
            lblStar.text = "*" + "/10"
        }
        lblLanguage.text = movie?.originalLanguage.uppercased()
        if let backPath = movie?.backdropPath, let forwardPath = movie?.posterPath{
            downImageWithNuke(pathForward: forwardPath, pathBack: backPath)
        }
        
    }
    
    func downImageWithNuke(pathForward: String, pathBack: String) {
        let fPath = "https://image.tmdb.org/t/p/original" + pathForward
        let fUrl = URL(string: fPath)
        
        let bPath = "https://image.tmdb.org/t/p/original" + pathBack
        let bUrl = URL(string: bPath)
        
        Nuke.loadImage(with: fUrl!, into: forwardImg)
        Nuke.loadImage(with: bUrl!, into: image)

    }

    func downImage(path: String) -> UIImage{
        let mPath = "https://image.tmdb.org/t/p/original" + path
        let url = URL(string: mPath)
        let data = try! Data(contentsOf: url!)
        return UIImage(data: data)!
    }
    
}




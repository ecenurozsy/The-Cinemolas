//
//  MovieDetailVc.swift
//  Final-Coll
//
//  Created by ECENUR on 21.02.2021.
//

import UIKit

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
        }else{
            lblStar.text = "*" + "/10"
        }
        lblLanguage.text = movie?.originalLanguage.uppercased()
        if let backPath = movie?.backdropPath{
            image.image = downImage(path: backPath)
        }else{
            image.image = UIImage(named: "nopic.png")
        }
        if let forwardPath = movie?.posterPath{
            forwardImg.image = downImage(path: forwardPath)
        }else{
            forwardImg.image = UIImage(named: "nopic.png")
        }
       
        
    }

    func downImage(path: String) -> UIImage{
        let mPath = "https://image.tmdb.org/t/p/original" + path
        let url = URL(string: mPath)
        let data = try! Data(contentsOf: url!)
        return UIImage(data: data)!
    }
    
}




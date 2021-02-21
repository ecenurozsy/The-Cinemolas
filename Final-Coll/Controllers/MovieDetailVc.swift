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
    
    var movie: Result?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMovieTitle.text = movie?.originalTitle
        
        
    }
    

    
}

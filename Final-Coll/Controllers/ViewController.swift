//
//  ViewController.swift
//  Final-Coll
//
//  Created by ECENUR on 21.02.2021.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var moviesPopularity: [Result]? = []
    var moviesRevenue: [Result]? = []
    var moviesTopRated: [Result]? = []
    var moviesReleaseDate: [Result]? = []
    var movies: [[Result]?]?
    
    @IBOutlet weak var collectionV: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionV.dataSource = self
        collectionV.delegate = self
        collectionV.register(CollectionViewCell.nib(), forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionV.collectionViewLayout = ColumnFlowLayout(sutunSayisi: 2, minSutunAraligi: 5, minSatirAraligi: 20)
        collectionV.heightAnchor.constraint(equalTo: collectionV.widthAnchor, multiplier: 0.5).isActive = true
        collectionV.register(Header.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Header.identifier)
        getConnectionRevenue()
        getConnectionPopularity()
        getConnectionTopRated()
        getConnectionReleaseDate()
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return movies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies?[section]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        let movie = movies?[indexPath.section]?[indexPath.row]
        cell.configure(with: movie!)
        
        return cell
    }
    
    
    //select the movie
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let movieVC = mainStoryboard.instantiateViewController(withIdentifier: "MovieDetailVc") as! MovieDetailVc
        movieVC.movie = movies?[indexPath.section]?[indexPath.row]
        self.navigationController?.pushViewController(movieVC, animated: true)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        if section == 0{
//            return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
//        }
//        return UIEdgeInsets(top: 10, left: 4, bottom: 10, right: 4)
//    }
//
    
    
    //https://api.themoviedb.org/3/discover/movie?api_key=c8c52447cfc2f01cd29e552111b5b99a&sort_by=release_date.desc
    func getConnectionPopularity(){
        let params = [ "api_key" : Constants.APIkey,"sort_by": "popularity.desc"]
        let url = "https://api.themoviedb.org/3/discover/movie"
        AF.request(url, method: .get, parameters: params).responseJSON { (res) in
            
            if (res.response?.statusCode == 200) {
                print("status==200")
                let movie_api = try? JSONDecoder().decode(MovieAPI.self, from: res.data!)
                self.moviesPopularity = movie_api?.results
                self.movies = [self.moviesPopularity,self.moviesPopularity,self.moviesReleaseDate,self.moviesRevenue]
                self.collectionV.reloadData()
            }
        }
    }
    let titles = ["Popularity","Top Rated","Release Date","Revenue"]

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Header.identifier, for: indexPath) as! Header 
        header.label.text = titles[indexPath.section]
        if(indexPath.section == 0){
            header.setLabel(size: 30, bold: true)
        }else{
            header.setLabel(size: 26, bold: false)
        }
        return header
    }
    //Başlangıç boyutunu
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: view.frame.size.width, height: 60)
        }else{
            return CGSize(width: view.frame.size.width, height: 40)
        }
        
    }
    
    func getConnectionRevenue(){
        let params = [ "api_key" : Constants.APIkey,"sort_by": "revenue.desc"]
        let url = "https://api.themoviedb.org/3/discover/movie"
        AF.request(url, method: .get, parameters: params).responseJSON { (res) in
            
            if (res.response?.statusCode == 200) {
                print("status==200")
                let movie_api = try? JSONDecoder().decode(MovieAPI.self, from: res.data!)
                self.moviesRevenue = movie_api?.results
                self.movies = [self.moviesPopularity,self.moviesTopRated,self.moviesReleaseDate,self.moviesRevenue]
                self.collectionV.reloadData()
                
            }
        }
    }
    
    func getConnectionTopRated(){
        let params = [ "api_key" : Constants.APIkey,"sort_by": "vote_count.desc"]
        let url = "https://api.themoviedb.org/3/discover/movie"
        AF.request(url, method: .get, parameters: params).responseJSON { (res) in
            
            if (res.response?.statusCode == 200) {
                print("status==200")
                let movie_api = try? JSONDecoder().decode(MovieAPI.self, from: res.data!)
                self.moviesTopRated = movie_api?.results
                self.movies = [self.moviesPopularity,self.moviesTopRated,self.moviesReleaseDate,self.moviesRevenue]
                self.collectionV.reloadData()
            }
        }
    }
 
    func getConnectionReleaseDate(){
        let params = [ "api_key" : Constants.APIkey,"sort_by": "release_date.desc"]
        let url = "https://api.themoviedb.org/3/discover/movie"
        AF.request(url, method: .get, parameters: params).responseJSON { (res) in
            
            if (res.response?.statusCode == 200) {
                print("status==200")
                let movie_api = try? JSONDecoder().decode(MovieAPI.self, from: res.data!)
                self.moviesReleaseDate = movie_api?.results
                self.movies = [self.moviesPopularity,self.moviesTopRated,self.moviesReleaseDate,self.moviesRevenue]
                self.collectionV.reloadData()

            }
        }
    }
}


extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat
        let height : CGFloat
        if indexPath.section == 0 {
            // First section
            width = collectionView.frame.width/2
            height = width*1.5
        } else {
            // Second section
            width = collectionView.frame.width/2.5
            height = width*1.5
        }
        return CGSize(width: width, height: height)
//        return CGSize(width: collectionView.frame.width/2.5, height: collectionView.frame.width/2)
    }
    
    
    
}


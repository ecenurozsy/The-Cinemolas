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
    var names = ["ecenur","sehanr","figen"]
    
    @IBOutlet weak var collectionV: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionV.dataSource = self
        collectionV.delegate = self
        collectionV.register(CollectionViewCell.nib(), forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionV.collectionViewLayout = ColumnFlowLayout(sutunSayisi: 3, minSutunAraligi: 10, minSatirAraligi: 20)
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
    
    //https://api.themoviedb.org/3/discover/movie?api_key=c8c52447cfc2f01cd29e552111b5b99a&sort_by=release_date.desc
    func getConnectionPopularity(){
        let params = [ "api_key" : Constants.APIkey,"sort_by": "popularity.desc"]
        let url = "https://api.themoviedb.org/3/discover/movie"
        AF.request(url, method: .get, parameters: params).responseJSON { (res) in
            
            if (res.response?.statusCode == 200) {
                print("status==200")
                let movie_api = try? JSONDecoder().decode(MovieAPI.self, from: res.data!)
                self.moviesPopularity = movie_api?.results
                self.collectionV.reloadData()
            }
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
                self.movies = [self.moviesPopularity,self.moviesPopularity,self.moviesReleaseDate,self.moviesRevenue]
                self.collectionV.reloadData()

            }
        }
    }
}


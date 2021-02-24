//
//  ViewController.swift
//  Final-Coll
//
//  Created by ECENUR on 21.02.2021.
//

import UIKit
import Alamofire
import JEKScrollableSectionCollectionViewLayout

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    var moviesPopularity: [Result]? = []
    var moviesRevenue: [Result]? = []
    var moviesTopRated: [Result]? = []
    var moviesReleaseDate: [Result]? = []
    var movies: [[Result]?]?
    var pages = [2,2,2,2]
    var lastIndex = [19,19,19,19]
    let titles = ["  Popularity","  Top Rated","  Release Date","  Revenue"]
    var isLoading = false
    
    @IBOutlet weak var collectionV: UICollectionView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //to provide come back with swipe
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
        
        //register
        collectionV.dataSource = self
        collectionV.delegate = self
        collectionV.register(CollectionViewCell.nib(), forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionV.heightAnchor.constraint(equalTo: collectionV.widthAnchor, multiplier: 0.5).isActive = true
        collectionV.register(Header.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Header.identifier)
        
        //for horizontol scroll
        let layout = JEKScrollableSectionCollectionViewLayout()
        layout.itemSize = CGSize(width: 50, height: 50);
        layout.headerReferenceSize = CGSize(width: 0, height: 22)
        layout.minimumInteritemSpacing = 9
        collectionV.collectionViewLayout = layout
        
        //load data
        getConnectionRevenue()
        getConnectionPopularity()
        getConnectionTopRated()
        getConnectionReleaseDate()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
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
    //Go to Movie Detail Page
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let movieVC = mainStoryboard.instantiateViewController(withIdentifier: "MovieDetailVc") as! MovieDetailVc
        movieVC.movie = movies?[indexPath.section]?[indexPath.row]
        splitViewController?.showDetailViewController(movieVC, sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 15, right: 4)
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: view.frame.size.width, height: 60)
        }else{
            return CGSize(width: view.frame.size.width, height: 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.lastIndex[indexPath.section]{
            self.loadData(page: pages[indexPath.section], section: indexPath.section)
            self.lastIndex[indexPath.section] += lastIndex[indexPath.section]
        }
    }

    //API REQUEST SIDE:
    func loadData(page: Int, section: Int){
        if page > 500 {
            return
        }
        if !self.isLoading {
                    self.isLoading = true
                    DispatchQueue.global().async {
                        // Fake background loading task for 2 seconds
                        sleep(2)
                        // Download more data here
                        DispatchQueue.main.async {
                            //Popularity
                            if section == 0 {
                                self.getConnectionPopularity(page: String(page))
                            }
                            //Top Rated
                            if section == 1 {
                                self.getConnectionTopRated(page: String(page))
                            }
                            //Release Date
                            if section == 2 {
                                self.getConnectionReleaseDate(page: String(page))
                            }
                            //Revenue
                            if section == 3 {
                                self.getConnectionRevenue(page: String(page))
                            }
                            self.isLoading = false
                        }
                    }
                }
        self.pages[section] += 1
    }
    
    //https://api.themoviedb.org/3/discover/movie?api_key=c8c52447cfc2f01cd29e552111b5b99a&sort_by=release_date.desc&page=2
    func getConnectionPopularity(page: String = "1"){
        let params = [ "api_key" : Constants.APIkey,"sort_by": "popularity.desc","page": page]
        let url = "https://api.themoviedb.org/3/discover/movie"
        AF.request(url, method: .get, parameters: params).responseJSON { (res) in
            
            if (res.response?.statusCode == 200) {
                print("status==200")
                let movie_api = try? JSONDecoder().decode(MovieAPI.self, from: res.data!)
                let movie = movie_api?.results
                //self.moviesPopularity = movie_api?.results
                self.moviesPopularity = self.moviesPopularity! + movie!
                self.movies = [self.moviesPopularity,self.moviesTopRated,self.moviesReleaseDate,self.moviesRevenue]
                self.collectionV.reloadData()
            }
        }
    }
    
    func getConnectionRevenue(page: String = "1"){
        let params = [ "api_key" : Constants.APIkey,"sort_by": "revenue.desc", "page": page]
        let url = "https://api.themoviedb.org/3/discover/movie"
        AF.request(url, method: .get, parameters: params).responseJSON { (res) in
            if (res.response?.statusCode == 200) {
                print("status==200")
                let movie_api = try? JSONDecoder().decode(MovieAPI.self, from: res.data!)
                let movie = movie_api?.results
                //self.moviesRevenue = movie_api?.results
                self.moviesRevenue = self.moviesRevenue! + movie!
                self.movies = [self.moviesPopularity,self.moviesTopRated,self.moviesReleaseDate,self.moviesRevenue]
                self.collectionV.reloadData()
            }
        }
    }
    
    func getConnectionTopRated(page: String = "1"){
        let params = [ "api_key" : Constants.APIkey,"sort_by": "vote_count.desc", "page": page]
        let url = "https://api.themoviedb.org/3/discover/movie"
        AF.request(url, method: .get, parameters: params).responseJSON { (res) in
            
            if (res.response?.statusCode == 200) {
                print("status==200")
                let movie_api = try? JSONDecoder().decode(MovieAPI.self, from: res.data!)
                let movie = movie_api?.results
                //self.moviesTopRated = movie_api?.results
                self.moviesTopRated = self.moviesTopRated! + movie!
                self.movies = [self.moviesPopularity,self.moviesTopRated,self.moviesReleaseDate,self.moviesRevenue]
                self.collectionV.reloadData()
            }
        }
        
    }
 
    func getConnectionReleaseDate(page: String = "1"){
        let params = [ "api_key" : Constants.APIkey,"sort_by": "release_date.desc", "page": page ]
        let url = "https://api.themoviedb.org/3/discover/movie"
        AF.request(url, method: .get, parameters: params).responseJSON { (res) in
            
            if (res.response?.statusCode == 200) {
                print("status==200")
                let movie_api = try? JSONDecoder().decode(MovieAPI.self, from: res.data!)
                let movie = movie_api?.results
                //self.moviesReleaseDate = movie_api?.results
                self.moviesReleaseDate = self.moviesReleaseDate! + movie!
                self.movies = [self.moviesPopularity,self.moviesTopRated,self.moviesReleaseDate,self.moviesRevenue]
                self.collectionV.reloadData()

            }
        }
    }
}


//Different movie images size for different sections
extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat
        let height : CGFloat
        if indexPath.section == 0 {
            // First section
            width = collectionView.frame.width/1.75
            height = width*1.5
        } else {
            // Second section
            width = collectionView.frame.width/2.25
            height = width*1.5
        }
        return CGSize(width: width, height: height)
    }
}



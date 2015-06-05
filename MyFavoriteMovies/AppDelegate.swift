//
//  AppDelegate.swift
//  MyFavoriteMovies
//
//  Created by Suthananth Arulanantham on 14.05.15.
//  Copyright (c) 2015 Suthananth Arulanantham. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    /* Constants for TheMovieDB */
    let API_KEY = "9349ca41d1a46590e380dd1cfffc0fd8"
    let BASE_URL_STRING = "http://api.themoviedb.org/3/"
    let BASE_URL_SECURED = "https://api.themoviedb.org/3/"
    let POSTER_BASE_URL = "https://image.tmdb.org/t/p/w154"
    
    var requestToken : String? = nil
    var sessionID : String? = nil
    var userID : String? = nil
    
    let genres = [
        "Action": 28,
        "Comedy": 35,
        "Sci-Fi":878
    ]
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
}

extension AppDelegate {
    func createURL(url:String, methodParameters : [String:String])-> NSURLComponents?{
        let url = NSURLComponents(string:url)
        var queries : [NSURLQueryItem] = [NSURLQueryItem(name: "api_key", value: self.API_KEY)]
        for (key, value) in methodParameters{
            let query = NSURLQueryItem(name: key, value: value)
            queries.append(query)
        }
        url?.queryItems = queries
        return url
    }
    
    func returnGenre(genre:String)->Int?{
        return self.genres[genre]
    }
    
    func createMovieList(movies : [[String:AnyObject]], inout movieList: [Movie]){
        for movie in movies {
            let title = movie["title"] as! String
            let id = movie["id"] as! Int
            let averageScore = movie["vote_average"] as! Double
            let posterPath = movie["poster_path"] as! String
            let posterURL : NSURL = NSURL(string: self.POSTER_BASE_URL + posterPath)!
            let posterData = NSData(contentsOfURL: posterURL)!
            let image = UIImage(data: posterData)
            let mov = Movie(movieTitle: title, movieID: id, movieScore: averageScore, moviePoster: image)
            movieList.append(mov)
            
        }
    }
}


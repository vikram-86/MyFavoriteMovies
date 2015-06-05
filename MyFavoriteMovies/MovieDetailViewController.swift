//
//  MovieDetailViewController.swift
//  MyFavoriteMovies
//
//  Created by Suthananth Arulanantham on 16.05.15.
//  Copyright (c) 2015 Suthananth Arulanantham. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var averageScoreLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var movie :Movie!
    var isFavorite : Bool! = false
    
    var appDelegate : AppDelegate!
    var session : NSURLSession!
    
    override func viewDidLoad() {
        self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.session = NSURLSession.sharedSession()
        
        //TODO: fix 'isfavorite' button by getting the favorite from web
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let urlString = self.appDelegate.BASE_URL_SECURED + "account/\(self.appDelegate.userID!)/favorite/movies"
        let methodParameters = [
            "session_id" : self.appDelegate.sessionID!
        ]
        let url = self.appDelegate.createURL(urlString, methodParameters: methodParameters)!.URL!
        let request = NSMutableURLRequest(URL: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = self.session.dataTaskWithRequest(request, completionHandler: { (data, response, downloadError) -> Void in
                if let error = downloadError {
                    println("Error getting data for favorite movies")
                }
            var parsingError : NSError? = nil
            let parsedData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
            if let movieList = parsedData["results"] as? [[String:AnyObject]]{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    for mov in movieList{
                        let movID = mov["id"] as! Int
                        if movID == self.movie.id{
                            self.updateView(true)
                           
                        }
                    }
                    self.posterImage.image = self.movie.poster
                    self.titleLabel.text = self.movie.title
                    self.averageScoreLabel.text = "Score: \(self.movie.averageScore)"
                })
            }
            
        })
        task.resume()
    }
    @IBAction func favoriteButtonTouchUp(sender: UIButton) {
        self.toggleFavoriteButton()
    }
    
    func toggleFavoriteButton(){
        if self.isFavorite == true{
            self.updateMovie(false)
        }
        else{
            self.updateMovie(true)
        }
    }
    
    func updateView(favorite : Bool){
        self.isFavorite = favorite
        if favorite {
            let img = UIImage(named: "Favorite.png")
            self.favoriteButton.setImage(img, forState: .Normal)
        }
        else{
            let img = UIImage(named: "unfavorite.png")
            self.favoriteButton.setImage(img, forState: .Normal)
        }
    }
    
    func updateMovie(favorited : Bool){
        let urlString = self.appDelegate.BASE_URL_SECURED + "account/\(self.appDelegate.userID!)/favorite"
        let methodParameters = [
            "session_id" : self.appDelegate.sessionID!
        ]
        let url = appDelegate.createURL(urlString, methodParameters: methodParameters)!.URL!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"media_type\": \"movie\",\"media_id\": \(self.movie.id),\"favorite\": \(favorited)}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = self.session.dataTaskWithRequest(request, completionHandler: { (data, response, downloadError) -> Void in
            if let error = downloadError {
                println("Error posting to server")
            }
            else{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.updateView(favorited)
                })
                
            }
        })
        task.resume()
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
}


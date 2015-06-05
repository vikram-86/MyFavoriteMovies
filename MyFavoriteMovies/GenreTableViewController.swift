//
//  GenreTableViewController.swift
//  MyFavoriteMovies
//
//  Created by Suthananth Arulanantham on 15.05.15.
//  Copyright (c) 2015 Suthananth Arulanantham. All rights reserved.
//

import UIKit

class GenreTableViewController: UITableViewController {
    
    var appDelegate : AppDelegate!
    var session : NSURLSession!
    
    var genreID : Int?
    var movies = [Movie]()
    
    
    // Get the title and genre id when view loads
    override func viewDidLoad() {
        self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.session = NSURLSession.sharedSession()
        
        self.genreID = self.appDelegate.returnGenre(self.tabBarItem.title!)!
    }
    
    // load movies from themoviesdb.org using the genreID
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.movies.removeAll(keepCapacity: false)
        let urlString = self.appDelegate.BASE_URL_SECURED + "genre/\(self.genreID!)/movies"
        let methodParameters = [
            "api_key" : self.appDelegate.API_KEY
        ]
        let url = self.appDelegate.createURL(urlString, methodParameters: methodParameters)!.URL!
        let request = NSMutableURLRequest(URL: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = self.session.dataTaskWithRequest(request, completionHandler: { (data, response, downloadError) -> Void in
            if let error = downloadError {
                println("could not complete request")
            }
            var parsingError : NSError? = nil
            let parsedData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
            if let moviesArray = parsedData.valueForKey("results") as? [[String : AnyObject]]{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.appDelegate.createMovieList(moviesArray, movieList: &self.movies)
                    self.tableView.reloadData()
                })
            }
            else{
                println("Error getting movies")
            }
        })
        task.resume()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        let movie = self.movies[indexPath.row]
        
        cell.textLabel!.text = movie.title
        cell.imageView!.image = movie.poster
        cell.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        
        return cell
    }
        
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.storyboard?.instantiateViewControllerWithIdentifier("movieDetail") as! MovieDetailViewController
        cell.movie = movies[indexPath.row]
        self.navigationController?.pushViewController(cell, animated: true)
    }
}

//
//  FavoriteMoviesTableViewController.swift
//  MyFavoriteMovies
//
//  Created by Suthananth Arulanantham on 17.05.15.
//  Copyright (c) 2015 Suthananth Arulanantham. All rights reserved.
//

import UIKit

class FavoriteMoviesTableViewController: UITableViewController {
    var appdelegate : AppDelegate!
    var session : NSURLSession!
    
    var movies = [Movie]()
    
    override func viewDidLoad() {
        self.appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.session = NSURLSession.sharedSession()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.movies.removeAll(keepCapacity: false)
        let urlString = self.appdelegate.BASE_URL_SECURED + "account/\(self.appdelegate.userID!)/favorite/movies"
        let methodParameters = [
            "session_id": self.appdelegate.sessionID!
        ]
        let url = self.appdelegate.createURL(urlString, methodParameters: methodParameters)!.URL!
        let request = NSMutableURLRequest(URL: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = self.session.dataTaskWithRequest(request, completionHandler: { (data, response, downloadError) -> Void in
            if let error = downloadError{
                println("Error getting data from server")
            }
            var parsingError : NSError? = nil
            let parsedData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
            
            if let movieResult = parsedData["results"] as? [[String:AnyObject]]{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.appdelegate.createMovieList(movieResult, movieList: &self.movies)
                    self.tableView.reloadData()
                })
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
        
        cell.textLabel?.text = movie.title
        cell.imageView?.image = movie.poster
        cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.storyboard?.instantiateViewControllerWithIdentifier("movieDetail") as! MovieDetailViewController
        cell.movie = self.movies[indexPath.row]
        self.navigationController?.pushViewController(cell, animated: true)
    }
}

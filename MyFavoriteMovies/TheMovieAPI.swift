//
//  LoginViewController+TheMovieDBAPI.swift
//  MyFavoriteMovies
//
//  Created by Suthananth Arulanantham on 14.05.15.
//  Copyright (c) 2015 Suthananth Arulanantham. All rights reserved.
//
import UIKit

extension LoginViewController{
    
    // gets a request token from the webservice
    func getRequestToken(){
        /* TASK: Get a requestToken, then store it (Appdelegate.requestToken) and login with the token */
        /* 1. Set the parameters */
        /* 2. Build the URL */
        /* 3. Configure the request */
        /* 4. Make the request */
        /* 5. Parse the data */
        /* 6. Use the data! */
        /* 7. Start the request */
        var baseURL = self.appdelegate.BASE_URL_SECURED + "authentication/token/new"
        let query = [NSURLQueryItem(name: "api_key", value: self.appdelegate.API_KEY)]
        let url = NSURLComponents(string: baseURL)
        url?.queryItems = query
        let request = NSMutableURLRequest(URL: url!.URL!)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, downloadError) -> Void in
            if let error = downloadError{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.debugLabel.text = "Error during fetching data"
                })
            }
            var parsedError : NSError? = nil
            let parsedData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsedError) as! NSDictionary
            if let token = parsedData["request_token"] as? String{
                self.appdelegate.requestToken = token
                self.loginWithToken(token)
            }
            else{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.debugLabel.text = "Error fetching request token"
                })
            }
        })
        task.resume()
    }
    
    // loging in with the webservice
    func loginWithToken(token : String){
        let urlString = self.appdelegate.BASE_URL_SECURED + "authentication/token/validate_with_login"
        let methodParameters = [
            "request_token":token,
            "username":self.userNameTextfield.text as String,
            "password":self.passwordTextfield.text as String
        ]
        let url = self.appdelegate.createURL(urlString, methodParameters: methodParameters)!
        let request = NSMutableURLRequest(URL: url.URL!)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, downloadError) -> Void in
            if let error = downloadError{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.debugLabel.text = "Error signing in with token"
                })
            }
            var parsedError : NSError? = nil
            let parsedData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsedError) as! NSDictionary
            
            if let request_token = parsedData["request_token"] as? String {
                self.appdelegate.requestToken = request_token
                self.getSessionID()
            }
            else{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.debugLabel.text = "Invalid username/password"
                })
            }
        })
        task.resume()
    }
    
    // get session ID from the webservice
    func getSessionID(){
        let urlString = self.appdelegate.BASE_URL_SECURED + "authentication/session/new"
        let methodParameters = [
            "request_token" : self.appdelegate.requestToken!
        ]
        let url = self.appdelegate.createURL(urlString, methodParameters: methodParameters)!
        let request = NSMutableURLRequest(URL: url.URL!)
        request.addValue("json/application", forHTTPHeaderField: "Accept")
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, downloadError) -> Void in
            if let error = downloadError {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.debugLabel.text = "Error Fetching SessionID"
                })
            }
            var parsingError : NSError? = nil
            let parsedData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
            
            if let sessionID = parsedData["session_id"] as? String{
                self.appdelegate.sessionID = sessionID
                self.getUserID()
            }
            else{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.debugLabel.text = "Error getting Session ID"
                })
            }
        })
        task.resume()
    }
    
    // get userID form webService
    func getUserID(){
        let urlString = self.appdelegate.BASE_URL_SECURED + "account"
        let methodParameters = [
            "session_id":self.appdelegate.sessionID!
        ]
        if let url = self.appdelegate.createURL(urlString, methodParameters: methodParameters)?.URL {
            let request = NSMutableURLRequest(URL: url)
            request.addValue("json/application", forHTTPHeaderField: "Accept")
            let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, downloadError) -> Void in
                if let error = downloadError{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.debugLabel.text = "Error getting data for user ID"
                    })
                }
                var parsingError : NSError? = nil
                let parsedData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
                if let id = parsedData["id"] as? Int{
                    self.appdelegate.userID = NSNumberFormatter().stringFromNumber(id)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.debugLabel.text = "Success!"
                    })
                    self.completeLogin()
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.debugLabel.text = "Error getting user ID"
                    })
                }
                
            })
            task.resume()
        }
        else{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.debugLabel.text = "Error getting user ID"
            })
        }
    }
    
    func completeLogin(){
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("genreView") as! UIViewController
        self.presentViewController(controller, animated: true, completion: nil)
    }

}
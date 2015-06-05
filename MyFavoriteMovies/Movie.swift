//
//  Movie.swift
//  MyFavoriteMovies
//
//  Created by Suthananth Arulanantham on 15.05.15.
//  Copyright (c) 2015 Suthananth Arulanantham. All rights reserved.
//

import UIKit
class Movie {
    var title : String!
    var id : Int!
    var averageScore : Double!
    var poster : UIImage!
    
    init(movieTitle : String!, movieID : Int!,movieScore : Double!, moviePoster:UIImage!){
        self.title = movieTitle
        self.id = movieID
        self.averageScore = movieScore
        self.poster = moviePoster
    }
}

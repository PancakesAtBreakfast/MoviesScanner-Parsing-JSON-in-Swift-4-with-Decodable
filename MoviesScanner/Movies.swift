//
//  Movies.swift
//  MoviesScanner
//
//  Created by Niso on 10/26/17.
//  Copyright © 2017 Niso. All rights reserved.
//

import Foundation

struct Movies: Decodable {
    
    let title:String
    let image:String
    let rating:Double
    let releaseYear:Int
    let genre: [String]
    
}

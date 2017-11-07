//
//  MovieDetailsViewController.swift
//  MoviesScanner
//
//  Created by Niso on 10/23/17.
//  Copyright © 2017 Niso. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var movieGenre: UILabel!
    

    var MovieDetailsData:Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        movieTitle.text = MovieDetailsData.title
        movieYear.text = String(MovieDetailsData.releaseYear)
        movieRating.text = String(MovieDetailsData.rating)
        
        let imageString = MovieDetailsData.image
        let imageUrl = NSURL(string: imageString!)! as URL
        let imageData = NSData(contentsOf: imageUrl)! as Data
        movieImage.image = UIImage(data: imageData)
        
        let genreArray = MovieDetailsData.genre! as! NSArray
        var genreString:String = ""
        for genre in genreArray{
             genreString = genreString + " \(genre as! String),"
        }
        genreString = String(genreString.characters.dropLast())
        movieGenre?.text = genreString
        
    }

}


//
//  ViewController.swift
//  MoviesScanner
//
//  Created by Niso on 10/23/17.
//  Copyright © 2017 Niso. All rights reserved.
//

import UIKit
import CoreData

class MovieListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Core Data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var moviesList:[Movie]! = []
    
    var selectedCellNumberFromDataList:Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveDataFromCoreData()
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        retrieveDataFromCoreData()
        self.tableView.reloadData()
    }
    
    // Retrieve data from CoreData
    func retrieveDataFromCoreData(){
        // Sort movies by release year
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Movie.releaseYear), ascending: false)
        fetchRequest.sortDescriptors = [sort]
        // Retrieve data
        do {
            moviesList = try context.fetch(fetchRequest)
            //print(moviesList)
        } catch {
            print("Failed to fetch data from CoreData")
        }
    }
    
    // MARK: TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if moviesList != nil{
            return moviesList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let item = moviesList[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = String(item.releaseYear)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedCellNumberFromDataList = moviesList[indexPath.row]

        // Move to next screen
        performSegue(withIdentifier: "MovieDetailsSegue", sender: self)
    }
    
    // MARK: - Navigation to Movie Details screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MovieDetailsSegue" {
            let MovieDetailsScreen = segue.destination as! MovieDetailsViewController
            
            MovieDetailsScreen.MovieDetailsData = selectedCellNumberFromDataList
        }
    }
    
}


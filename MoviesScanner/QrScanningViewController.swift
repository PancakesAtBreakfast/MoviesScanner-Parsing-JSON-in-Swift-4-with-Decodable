//
//  QrScanningViewController.swift
//  MoviesScanner
//
//  Created by Niso on 10/23/17.
//  Copyright © 2017 Niso. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class QrScanningViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var target: UIImageView!
    var Video = AVCaptureVideoPreviewLayer()
    
    // Core Data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var moviesList:[Movie]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveDataFromCoreData()
        
        let session = AVCaptureSession()
        
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        }
        catch{
            print("Erorr")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        Video = AVCaptureVideoPreviewLayer(session: session)
        Video.frame = view.layer.bounds
        view.layer.addSublayer(Video)
        
        self.target.layer.borderWidth = 2
        self.target.layer.borderColor = UIColor.init(red:1.0, green:0.0, blue:0.0, alpha: 1.0).cgColor
        
        self.view.bringSubview(toFront: target)
        
        session.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects != nil && metadataObjects.count != 0 {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject{
                if object.type == AVMetadataObject.ObjectType.qr {
                    
                    let alert = UIAlertController(title: "Code Scanned", message: "What would you like to do?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (nil) in
                        UIPasteboard.general.string = object.stringValue
                        
                        let moviesData = NSEntityDescription.entity(forEntityName: "Movie", in: self.context)
                        
                        let movie = Movie(entity: moviesData!, insertInto: self.context)
                        
                        let stringOfWords = object.stringValue?.components(separatedBy: ",")
                        var movieInfoArray:[String]=[]
                        
                        for word in stringOfWords!{
                            movieInfoArray.append(word)
                        }
                        
                        movie.title = movieInfoArray[0]
                        movie.releaseYear = Int16(movieInfoArray[1])!
                        movie.rating = Double(movieInfoArray[2])!
                        movie.image = movieInfoArray[3]
                        movie.genre = [movieInfoArray[4]] as NSArray
                        
                        (UIApplication.shared.delegate as! AppDelegate).saveContext()
                        
                        // Navigate to the movie details screen
                        let movieDetailsScreen = self.storyboard?.instantiateViewController(withIdentifier: "movie details") as! MovieDetailsViewController;
                        movieDetailsScreen.MovieDetailsData = movie
                        self.navigationController?.show(movieDetailsScreen, sender: self)
                    }))
                    
                    present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    // Retrieve Data From CoreData
    func retrieveDataFromCoreData(){
        do {
            moviesList = try context.fetch(Movie.fetchRequest())
            //print(moviesList)
        } catch {
            print("Failed to fetch data from CoreData")
        }
    }
}

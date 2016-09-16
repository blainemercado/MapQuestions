//
//  ViewController.swift
//  MapQuestions
//
//  Created by Blaine Mercado on 9/16/16.
//  Copyright © 2016 Blaine Mercado. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate, GameOverViewControllerDelegate {
    
    var landmarksList = [MKMapItem]()
    var landmark1 = MKMapItem()
    var landmark2 = MKMapItem()
    var currentLandmark = MKMapItem()
    var score: Double = 0
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var answerLabel: UILabel!
    
    @IBAction func resetButtonPressed(sender: UIButton) {
        self.score = 0
        scoreLabel.text = "Score: " + String(self.score)
        answerLabel.text = ""
        let allAnnotations = self.map.annotations
        self.map.removeAnnotations(allAnnotations)
        searchForLandmark()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answerLabel.text = ""
        scoreLabel.text = "Score: " + String(score)
        searchForLandmark()
        polyLine()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(pressedMap))
        map.addGestureRecognizer(tap)
        tap.delegate = self

    }
    func pressedMap(sender: AnyObject?) {
        let allAnnotations = self.map.annotations
        self.map.removeAnnotations(allAnnotations)
//        print("tapped")
        let touchPoint = sender! .locationInView(map)
        let locationCoordinate = map.convertPoint(touchPoint, toCoordinateFromView: map)
//        print("THis is locationCoordinate \(locationCoordinate)")
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate
        let source = MKMapItem( placemark: MKPlacemark(coordinate: locationCoordinate, addressDictionary: nil))
        map.addAnnotation(annotation)
        let answerAnnotation = MKPointAnnotation()
        answerAnnotation.coordinate = currentLandmark.placemark.coordinate
        map.addAnnotation(answerAnnotation)
        let distance = findDistance(source, destination: currentLandmark)
        score += round(100/(distance+1))
        scoreLabel.text = "Score: " + String(score)
        let rand = Int(arc4random_uniform(UInt32(self.landmarksList.count)))
        self.answerLabel.text = "You were \(round(distance*69)) miles away from \(self.currentLandmark.name!)"
        self.currentLandmark = self.landmarksList[rand]
        self.landmarksList.removeAtIndex(rand)
        self.locationLabel.text = self.currentLandmark.name

        if landmarksList.count == 0 {
            gameOver()
        }
        
        
        
    }
    
    func gameOver(){
        performSegueWithIdentifier("gameOver", sender: self)
    }
    
    func searchForLandmark() {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "landmark"
        request.region = map.region
        
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler({
            response, error in
            if error != nil {
                print(error)
            } else if let mapItems = response?.mapItems {
//                print(response)
                print(mapItems)
                self.landmark1 = mapItems[0]
                self.landmark2 = mapItems[1]
//                print("This is landmark2", self.landmark2)
                for landmark in mapItems {
//                    print("*^*^*^*^*^*^*^*")
//                    print(landmark.placemark.coordinate)
                    self.landmarksList.append(landmark)
//                    let annotation = MKPointAnnotation()
//                    annotation.coordinate = landmark.placemark.coordinate
//                    annotation.title = landmark.name
//                    self.map.addAnnotation(annotation)
                }
//                self.findDistance()
                self.currentLandmark = self.landmarksList[Int(arc4random_uniform(UInt32(self.landmarksList.count)))]
                self.locationLabel.text = self.currentLandmark.name
                print (self.currentLandmark)
            }
        })
    }
    
    
    func polyLine() {
        var coordinates = [landmark1.placemark.coordinate, landmark2.placemark.coordinate]
        let line = MKGeodesicPolyline(coordinates: &coordinates, count: 2)
        map.addOverlay(line)
    }
    
    func findDistance(source: MKMapItem, destination: MKMapItem) -> Double {
//        print("These are landmark 1 and 2")
        print(source)
        print(destination)
        var distance: Double?
        let directionsRequest = MKDirectionsRequest()
        directionsRequest.source = source
        directionsRequest.destination = destination
        distance = sqrt(pow((source.placemark.coordinate.latitude - destination.placemark.coordinate.latitude),2) + pow((source.placemark.coordinate.longitude - destination.placemark.coordinate.longitude),2))
        
        return round(distance!)
//        let directions = MKDirections(request: directionsRequest)
//        print(directions)
        
//        directions.calculateDirectionsWithCompletionHandler{(response, error) -> Void in
//            print(error)
//            print (response)
//            distance = response!.routes.first?.distance
//            print("the distance", distance!/1000)
//            self.putintoLabelDouble(distance!)
//        }
        
    }
    
    func gameOverViewController(controller: UIViewController, didFinishGame score: Double) {
        dismissViewControllerAnimated(true, completion: nil)
        self.score = 0
        scoreLabel.text = "Score: " + String(self.score)
        answerLabel.text = ""
        let allAnnotations = self.map.annotations
        self.map.removeAnnotations(allAnnotations)
        searchForLandmark()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? GameOverViewController {
            controller.delegate = self
            controller.score = self.score
            
        }

    }

}


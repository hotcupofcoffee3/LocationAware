//
//  ViewController.swift
//  LocationAware
//
//  Created by Adam Moore on 4/16/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var streetAddressLabel: UILabel!
    @IBOutlet weak var cityAndStateLabel: UILabel!
    @IBOutlet weak var zipLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    
    // In the main part of the app, under "Build Phase", then "Link Binary with Libraries", then "CoreLocation.framework" was added.
    // Two Info.plist Privacy things added for requesting and using location services
    
    // Generally create a location manager variable at the beginning
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

        
        // Setting view controller as delegate
        locationManager.delegate = self
        
        
        // Specificity of location. Multiple options, such as 10 meters, kilometer, etc.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        // Pop up to request
        locationManager.requestWhenInUseAuthorization()
        
        
        // Starts updating the location
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        // "userLocation" here gives us all of this information based on the user's current location.
        
        let userLocation: CLLocation = locations[0]
        
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        let speed = userLocation.speed
        let course = userLocation.course
        
        let altitude = userLocation.altitude
        
        // This function gives us a constant called "placemarks" from the "userLocation" constant, using the "CLGeocoder().reverseGeocodeLocation()" function
        // An error is checked first, and is printed if so.
        // After that, if there is no error, "placemarks" is checked to see if it has something in the first array index, using optional binding.
        // If it does, then all of the specific address information is extracted from the "placemark" constant.
        CLGeocoder().reverseGeocodeLocation(userLocation) { (placemarks, error) in
            
            if error != nil {
                
                print(error!)
                
            } else {
                
                if let placemark = placemarks?[0] {
                    
                    if let streetNumber = placemark.subThoroughfare,
                        let street = placemark.thoroughfare,
                        let city = placemark.locality,
                        let state = placemark.administrativeArea,
                        let zip = placemark.postalCode,
                        let country = placemark.country {
                        
                            // Top labels
                            self.latitudeLabel.text = String(format: "%0.4f", Double(latitude))
                            self.longitudeLabel.text = String(format: "%0.4f", Double(longitude))
                            self.speedLabel.text = String(format: "%0.1f", Double(speed))
                            self.courseLabel.text = String(format: "%0.2f", Double(course))
                            self.altitudeLabel.text = String(format: "%0.2f", Double(altitude))
                        
                            // Address labels
                            self.streetAddressLabel.text = "\(streetNumber) \(street)"
                            self.cityAndStateLabel.text = "\(city), \(state)"
                            self.zipLabel.text = "\(zip)"
                            self.countryLabel.text = "\(country)"
                        

                    }
                    
                }
                
            }
            
        }
        
    }

}













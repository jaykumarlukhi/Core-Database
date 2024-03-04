//
//  MainViewController.swift


import UIKit
import MapKit
import CoreLocation


class MainViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, NewsViewControllerDelegate, MapViewControllerDelegate, WeatherViewControllerDelegate {
    

    // Background Image View with 0.25 Alpha
    @IBOutlet var backgroundImageView: UIImageView!

    // UIView & ImageView for profile picture
    @IBOutlet var profileParentView: UIView!
    @IBOutlet var profileImage: UIImageView!
    
    // UIView & MapView for map
    @IBOutlet var mapParentView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
    // ButtonView for discover News, Direction, Weather
    @IBOutlet var discoverButton: UIButton!
    
    
    // Variable declaration
    let locationManager = CLLocationManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    @IBAction func OpenAlertForCity(_ sender: Any) {
        
        // Create alert for discover the world
        let alertDialog = UIAlertController(
            title: "Where would you like to go",
            message: "Enter your destination",
            preferredStyle: .alert)
        
        // Add textfield in alert box
        alertDialog.addTextField{ (textField : UITextField!) -> Void in
            textField.placeholder = "City name"
        }
        
        // It will redirect to the News tab and display the news of the entered city
        alertDialog.addAction(UIAlertAction(title: "News", style: .default, handler: { alert -> Void in
            let cityNewsField = alertDialog.textFields![0] as UITextField
            self.dismissKeyboard()
            if(!(cityNewsField.text ?? "").isEmpty){
               if let tabBarController = self.tabBarController {
                    tabBarController.selectedIndex = 1// Navigate to the NewsViewController
                    if let navigation = tabBarController.viewControllers?[1] as? UINavigationController, let screen = navigation.viewControllers[0] as? NewsTableViewController{
                        screen.newsDelegate = self
                        screen.newsFromMainFunction(cityName: cityNewsField.text ?? "")
                    }
                }
            }
        }))
        
        // It will redirect to the Map tab and display directions to the entered city
        alertDialog.addAction(UIAlertAction(title: "Directions", style: .default, handler: { alert -> Void in
            let destinationCityField = alertDialog.textFields![0] as UITextField
            self.dismissKeyboard()
            if(!(destinationCityField.text ?? "").isEmpty){
                    if let tabBarController = self.tabBarController {
                    tabBarController.selectedIndex = 2// Navigate to the NewsViewController
                    if let navigation = tabBarController.viewControllers?[2] as? UINavigationController, let screen = navigation.viewControllers[0] as? MapViewController{
                        screen.mapDelegate = self
                        screen.directionsFromMainFunction(destinationCity: destinationCityField.text ?? "")
                    }
                }
            }
        }))
        
        // It will redirect to the Weatther tab and display weather of entered city
        alertDialog.addAction(UIAlertAction(title: "Weather", style: .default, handler: { alert -> Void in
            let cityWeatherField = alertDialog.textFields![0] as UITextField
            self.dismissKeyboard()
            if(!(cityWeatherField.text ?? "").isEmpty){
                if let tabBarController = self.tabBarController {
                    tabBarController.selectedIndex = 3// Navigate to the NewsViewController
                    if let navigation = tabBarController.viewControllers?[3] as? UINavigationController, let screen = navigation.viewControllers[0] as? WeatherViewController{
                        screen.weatherDelegate = self
                        screen.weatherFromMainFunction(cityName: cityWeatherField.text ?? "")
                    }
                }
            }
        }))
        present(alertDialog, animated: true)
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ------ Initialization of map and location service
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
//        mapView.showsUserLocation = true
        
        // ------ Background Image UI
        backgroundImageView.alpha = 0.25
        
        // ------ Profile Image UI
        profileImage.layer.cornerRadius = 10
        profileParentView.layer.shadowRadius = 14.0
        profileParentView.layer.shadowColor = UIColor.black.cgColor
        profileParentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        profileParentView.layer.shadowOpacity = 0.7
        
        // ------ Map UI
        mapView.layer.cornerRadius = 10
        mapParentView.layer.shadowRadius = 14.0
        mapParentView.layer.shadowColor = UIColor.black.cgColor
        mapParentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        mapParentView.layer.shadowOpacity = 0.7
        
        // ------ Discover Button UI
        discoverButton.layer.cornerRadius = 7
        
        // ------ Tap event recognizer
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    
    
    // Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
     
     
     
     // Function for Location Manager Service
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         if let location = locations.first?.coordinate {
             let region = MKCoordinateRegion(center: location, latitudinalMeters: Double(200), longitudinalMeters: Double(200))
             mapView?.addAnnotation(createPin(at: location, title: "Jaykumar Lukhi"))
             mapView?.setRegion(region, animated: true)
         }
     }
    
    
     
     // Function for Create location pin
     func createPin(at coordinate: CLLocationCoordinate2D?, title: String) -> MKPointAnnotation {
         let pin = MKPointAnnotation()
         pin.coordinate = coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
         pin.title = title
         return pin
     }
    
    
    
    // These three functions for data parsing in another view controller using protocol
    func newsDidCallFunction(data: String) {
         print("NewsViewController Function Call From MainViewController")
     }
    
    func mapDidCallFunction(data: String) {
         print("MapViewController Function Call From MainViewController")
     }
    
    func weatherDidCallFunction(data: String) {
         print("WeatherViewController Function Call From MainViewController")
     }
    
}


// Reference
/*
 
 I am using a protocol for parsing data from one viewcontroller to another viewcontroller, I refer from the following site
 
 I used that protocol in NewsTableViewController, MapViewController and WeatherViewController for data parsing. Moreover, these protocol can call another function which is present in another tab when user goes into one tab to another tab.
 
 https://stackoverflow.com/questions/54647662/using-delegate-how-to-pass-data-between-classes-ios

*/

//
//  MapViewController.swift

import UIKit
import MapKit
import CoreLocation


protocol MapViewControllerDelegate: AnyObject {
    func mapDidCallFunction(data: String)
}

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate  {

    
    // MapView to display user location and direction
    @IBOutlet weak var mapView: MKMapView!
    
    // SliderView for zoom control of map
    @IBOutlet weak var zoomSlider: UISlider!
    
    // Error LabelView
    @IBOutlet var errorLabel: UILabel!
        
    // Car, Bike, Walk ButtonView
    @IBOutlet var carButton: UIButton!
    @IBOutlet var bikeButton: UIButton!
    @IBOutlet var walkButton: UIButton!

    
    
    // Variables Initialization
    let locationManager = CLLocationManager()
    var startLocation: CLLocationCoordinate2D?
    var endLocation: CLLocationCoordinate2D?
    var startPointAddress = ""
    var endPointAddress = ""
    weak var mapDelegate: MapViewControllerDelegate?

    
    // Function for Zoom in/out Slider for Map
    @IBAction func zoomSliderValueChanged(_ sender: UISlider) {
        let region = MKCoordinateRegion(center: startLocation!, latitudinalMeters: 2050 - Double(sender.value * 10000), longitudinalMeters: 2050 - Double(sender.value * 10000))
        mapView?.setRegion(region, animated: true)
    }

    
    // Function for Car Button
    @IBAction func byAutoMobile(_ sender: Any) {

        if(endLocation != nil){
            self.drawPolyline(myTansportType : "car", cityName: "", fromPage: "")

        }else{
            errorDialog()
        }
    }
    
    
    // Function for Bike Button
    @IBAction func byTransit(_ sender: Any) {
        if(endLocation != nil){
            self.drawPolyline(myTansportType : "transit", cityName: "", fromPage: "")

        }else{
            errorDialog()
        }
    }
    

    // Function for Walk Button
    @IBAction func byWalking(_ sender: Any) {
        if(endLocation != nil){
            self.drawPolyline(myTansportType : "walk", cityName: "", fromPage: "")

        }else{
            errorDialog()
        }
    }
    
    
    // Alert box for city name
    @IBAction func OpenAlertForCity(_ sender: Any) {
        
        // Create alert for discover the map
        let alertDialog = UIAlertController(
            title: "Which city do you want to go to?",
            message: "Enter your destination",
            preferredStyle: .alert)
        
        // Add textfield in alert box
        alertDialog.addTextField{ (textField : UITextField!) -> Void in
            textField.placeholder = "City name"
        }
        
        // Cancel Button
        alertDialog.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        // Go to Button
        alertDialog.addAction(UIAlertAction(title: "Go to", style: .default, handler: { alert -> Void in
            let destinationCityField = alertDialog.textFields![0] as UITextField
            self.dismissKeyboard()
            if(!(destinationCityField.text ?? "").isEmpty){
                self.convertAddress(destinationCityField.text!, "News")
            }
        }))
        present(alertDialog, animated: true)
    }
    
    
    // Jump to Home Tab
    @IBAction func goToHomeTab(_ sender: Any) {
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 0 // Navigate to the first tab
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ------ Initialization of map and location service
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        
        // ------ Set UI for 3 Buttons
        self.UIDesign("")
        
        // ------ Tap event recognizer
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    
    // Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    // Update UI Button function
    func UIDesign(_ tranporationMode : String){
        if(tranporationMode == "car"){
            self.carButton?.layer.backgroundColor = UIColor.systemGreen.cgColor
            self.bikeButton?.layer.backgroundColor = UIColor.black.cgColor
            self.walkButton?.layer.backgroundColor = UIColor.black.cgColor
        }else if(tranporationMode == "transit"){
            carButton?.layer.backgroundColor = UIColor.black.cgColor
            bikeButton?.layer.backgroundColor = UIColor.systemGreen.cgColor
            walkButton?.layer.backgroundColor = UIColor.black.cgColor
        }else if(tranporationMode == "walk"){
            carButton?.layer.backgroundColor = UIColor.black.cgColor
            bikeButton?.layer.backgroundColor = UIColor.black.cgColor
            walkButton?.layer.backgroundColor = UIColor.systemGreen.cgColor
        }else{
            carButton?.layer.backgroundColor = UIColor.black.cgColor
            bikeButton?.layer.backgroundColor = UIColor.black.cgColor
            walkButton?.layer.backgroundColor = UIColor.black.cgColor
        }
        carButton?.layer.cornerRadius = 10
        bikeButton?.layer.cornerRadius = 10
        walkButton?.layer.cornerRadius = 10
    }
    
    
    
    // My Location Manager Service function
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first?.coordinate {
            startLocation = location
            let region = MKCoordinateRegion(center: startLocation!, latitudinalMeters: Double(500), longitudinalMeters: Double(500))
            mapView?.setRegion(region, animated: true)
        }
    }
    
    
    
    // Function for Convert text to location
    func convertAddress(_ cityName : String, _ fromPage: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(cityName) { (placemarks, error) in
            if let placemarks = placemarks,
                let location = placemarks.first?.location{
                    print(location)
                    self.endLocation = location.coordinate
                    self.errorLabel?.text = ""
                self.getAddressFromLatLon(pdblLatitude: self.startLocation?.latitude, withLongitude: self.startLocation?.longitude, isStartPoint: true)
                self.getAddressFromLatLon(pdblLatitude: self.endLocation?.latitude, withLongitude: self.endLocation?.longitude, isStartPoint: false)
                    self.drawPolyline(myTansportType : "car", cityName: cityName, fromPage: fromPage )
                  }else {
                      self.errorLabel?.text = "Your entered location not found"
                      self.errorLabel?.textColor = UIColor.systemRed
                      self.mapView?.removeAnnotations(self.mapView.annotations)
                      self.mapView?.removeOverlays(self.mapView.overlays)
                      let region = MKCoordinateRegion(center: self.startLocation!, latitudinalMeters: Double(200), longitudinalMeters: Double(200))
                      self.mapView?.setRegion(region, animated: true)
                      return
                  }
        }
    }
    
    
    
    // Function for Draw Polyine Between Two Locations
    func drawPolyline( myTansportType: String, cityName : String, fromPage: String) {
        
        // Update My Button UI
        self.UIDesign(myTansportType)
        
        // Remove Previous Polyline and Pins
        mapView?.removeAnnotations(mapView.annotations)
        mapView?.removeOverlays(mapView.overlays)
        
        // Create Location pins
        mapView?.addAnnotation(createPin(at: startLocation, title: "Start Point"))
        mapView?.addAnnotation(createPin(at: endLocation, title: cityName))

        // Create MKPlacemark for starting point and ending point
        let startLocationPlacemark = MKPlacemark(coordinate: startLocation ?? CLLocationCoordinate2D(), addressDictionary: nil)
        let endLocationPlacemark = MKPlacemark(coordinate: endLocation ?? CLLocationCoordinate2D(), addressDictionary: nil)

        // Create MKMapItems with the locationd placemarks
        let startLocationItem = MKMapItem(placemark: startLocationPlacemark)
        let endLocationItem = MKMapItem(placemark: endLocationPlacemark)

        // Create MKDirectionsRequest with start location and end location items and set transportation type
        let request = MKDirections.Request()
        request.source = startLocationItem
        request.destination = endLocationItem
        if(myTansportType == "car"){
            request.transportType = .automobile
        }else if(myTansportType == "transit"){
            request.transportType = .transit
        }else{
            request.transportType = .walking
        }

        // Find the Route for endered locations
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let route = response?.routes.first else {
                print(error!)
                self.errorLabel?.text = "There is no route for selected mode ( Trasnit )"
                self.errorLabel?.textColor = UIColor.systemRed
                return
            }
            
            self.errorLabel?.text = "Total Distance: \(String(format: "%.2f", route.distance/1000)) km"
            self.errorLabel?.textColor = UIColor.systemGreen
            self.mapView?.addOverlay(route.polyline, level: .aboveRoads)
            self.mapView?.showAnnotations(self.mapView.annotations, animated: true)
            self.mapView?.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            
            // Add searched direction to the local history
            if(fromPage != ""){
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                
                let mapHistory = History(context: context)
                mapHistory.historyType = "directions"
                mapHistory.from = fromPage
                mapHistory.city = cityName
                mapHistory.startPoint = self.startPointAddress
                mapHistory.endPoint = self.endPointAddress
                mapHistory.totalDistance = "\(String(format: "%.2f", route.distance/1000)) km"
                mapHistory.travelMode = "By \(myTansportType)"
                do{
                    try context.save()
                }catch{
                    let alertDialog = UIAlertController(
                        title: "Sorry",
                        message: "We have some problem here to add your data in local history.",
                        preferredStyle: .alert)

                    // Ok Button
                    alertDialog.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { alert -> Void in }))
                    self.present(alertDialog, animated: true)
                }
                
                
            }
        }
    }


    
    
    // Create location pin function
    func createPin(at coordinate: CLLocationCoordinate2D?, title: String) -> MKPointAnnotation {
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
        pin.title = title
        return pin
    }

    
    
    
    // MapView for Polyline
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 4.0
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    
    
    // This Function can return address from Latitude and Longitude
    func getAddressFromLatLon(pdblLatitude: Double?, withLongitude pdblLongitude: Double?, isStartPoint : Bool) {
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let ceo: CLGeocoder = CLGeocoder()
        center.latitude = pdblLatitude ?? 0.0
        center.longitude = pdblLongitude ?? 0.0
            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)

            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    let pm = placemarks! as [CLPlacemark]

                    if pm.count > 0 {
                        let pm = placemarks![0]
                        var addressString : String = ""
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }
                        
                        if(isStartPoint == true){
                            self.startPointAddress = addressString
                        }else{
                            self.endPointAddress = addressString
                        }
                        print(addressString)
                    }else{
                        // If Address not found then show latitude and longitude
                        if(isStartPoint == true){
                            self.startPointAddress = "Lat : \(self.startLocation?.latitude ?? 0.0 as Double), Lng : \(self.startLocation?.latitude ?? 0.0 as Double)"
                        }else{
                            self.endPointAddress = "Lat : \(self.endLocation?.latitude ?? 0.0 as Double), Lng : \(self.endLocation?.latitude ?? 0.0 as Double)"
                        }
                    }
                
            })

        }
    
    
    func errorDialog(){
        let alertDialog = UIAlertController(
            title: "Sorry",
            message: "We can not find your destination location. Please enter your destination location first and then select the travel mode.",
            preferredStyle: .alert)

        // Ok Button
        alertDialog.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { alert -> Void in }))
        present(alertDialog, animated: true)
    }
    
    
    
    // This Protocol Function trigger when user directly come from another view controller
    func directionsFromMainFunction(destinationCity: String) {
        convertAddress(destinationCity, "Main")
        mapDelegate?.mapDidCallFunction(data: destinationCity)
    }
    
}


// Reference
/*
 
 I am using a reverse geocoding for getting address from latitude and longitude
 
 https://stackoverflow.com/questions/41358423/swift-generate-an-address-format-from-reverse-geocoding
 
*/

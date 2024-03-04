//
//  WeatherViewController.swift


import UIKit
import CoreLocation
import Foundation

protocol WeatherViewControllerDelegate: AnyObject {
    func weatherDidCallFunction(data: String)
}

class WeatherViewController: UIViewController , CLLocationManagerDelegate{

    
    // Background ImageView
    @IBOutlet var backgroundImageView: UIImageView!
    
    // Weather Image View
    @IBOutlet var weatherImageView: UIImageView!
    
    // City Name LabelView
    @IBOutlet weak var cityNameLabelView: UILabel!
    
    // Weather Title LabelView
    @IBOutlet var weatherTitleLabelView: UILabel!
    
    // Weather Description LabelView
    @IBOutlet var weatherDescriptionLabelView: UILabel!
    
    // weather Temperature LabelView
    @IBOutlet var weatherTempretureLabelView: UILabel!
    
    // weather Temperature Feels Like LabelView
    @IBOutlet var weatherTempretureFeesLikeLabelView: UILabel!
    
    // Weather Humidity LabelView
    @IBOutlet var weatherHumidityLabelView: UILabel!
    
    // Weather Wind LabelView
    @IBOutlet var windSpeedLabelView: UILabel!
    
    // Api Call Refresh ButtonView
    @IBOutlet var refreshApiCallButtonView: UIButton!
    
    // Junp to Waterloo ButtonView
    @IBOutlet var junpToWaterlooButtonView: UIButton!
    
    
    
    // Variable Declaration
    let myLocationManager  = CLLocationManager()
    var apicalling = false
    var areYouJumpingToWaterloo = false
    var myLocation = CLLocation()
    weak var weatherDelegate: WeatherViewControllerDelegate?
    
    
    
    // Refresh my Api data
    @IBAction func refreshMyApi(_ sender: Any) {
        resetMyAllData()
        self.myWeatherApiCalling(myLocation.coordinate.latitude, myLocation.coordinate.longitude, "")
    }
    
    
    // Function for
    @IBAction func jumpToWaterloo(_ sender: Any) {
        areYouJumpingToWaterloo = true
        resetMyAllData()
        self.myWeatherApiCalling(myLocation.coordinate.latitude, myLocation.coordinate.longitude, "")
    }
     
    
    
    // Function for alert box to which can find weather for perticular city
    @IBAction func OpenAlertForCity(_ sender: Any) {
        
        // Create alert for discover the map
        let alertDialog = UIAlertController(
            title: "Which city do you want the weather for?",
            message: "Enter city name",
            preferredStyle: .alert)
        
        // Add textfield in alert box
        alertDialog.addTextField{ (textField : UITextField!) -> Void in
            textField.placeholder = "City name"
        }
        
        // Cancel Button
        alertDialog.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        // Go to Button
        alertDialog.addAction(UIAlertAction(title: "Search", style: .default, handler: { alert -> Void in
            let weatherCityField = alertDialog.textFields![0] as UITextField
            self.dismissKeyboard()
            if(!(weatherCityField.text ?? "").isEmpty){
                self.convertAddress(weatherCityField.text!, "Weather")
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

        // --------- NavigationBar colors
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.tintColor = UIColor.white
        
        // --------- Initialize Location Manager
        myLocationManager.delegate = self
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        myLocationManager.requestWhenInUseAuthorization()
        myLocationManager.startUpdatingLocation()
        
        // --------- UI for Refresh Button
        refreshApiCallButtonView.layer.cornerRadius = 10
        refreshApiCallButtonView.layer.shadowColor = UIColor.white.cgColor
        refreshApiCallButtonView.layer.shadowRadius = 10
        refreshApiCallButtonView.layer.shadowOffset = CGSize(width: 0, height: 0)
        refreshApiCallButtonView.layer.shadowOpacity = 0.7
        
        // --------- UI for JumpToWaterloo Button
        junpToWaterlooButtonView.layer.cornerRadius = 10
        junpToWaterlooButtonView.layer.shadowColor = UIColor.white.cgColor
        junpToWaterlooButtonView.layer.shadowRadius = 10
        junpToWaterlooButtonView.layer.shadowOffset = CGSize(width: 0, height: 0)
        junpToWaterlooButtonView.layer.shadowOpacity = 0.7
        
        // --------- Background Image
        self.backgroundImageView.image = UIImage(named: "weather")
        
        // ------ Tap event recognizer
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
    // This is my Location Manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        myLocation = locations[0]
        self.myWeatherApiCalling(myLocation.coordinate.latitude, myLocation.coordinate.longitude, "Weather")
        
    }
    
   
    
    // Function for reset all data as default
    func resetMyAllData(){
        apicalling = false
        self.cityNameLabelView.text = "Loading..."
        self.weatherDescriptionLabelView.text = "Loading..."
        self.weatherTitleLabelView.text = "Loading..."
        self.weatherTempretureLabelView.text = "Loading..."
        self.weatherTempretureFeesLikeLabelView.text = "Loading..."
        self.weatherHumidityLabelView.text = "Loading..."
        self.windSpeedLabelView.text = "Loading..."
        self.weatherImageView.load(urlString: "")
        self.backgroundImageView.image = UIImage(named: "weather")
    }
    
    
    
    // Convert text to location function
    func convertAddress(_ cityName : String, _ fromPage: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(cityName) { (placemarks, error) in
            if let placemarks = placemarks,
                let location = placemarks.first?.location{
                    print(location)
                self.resetMyAllData()
                self.myWeatherApiCalling(location.coordinate.latitude, location.coordinate.longitude, fromPage)
                  }else {
                      let alertDialog = UIAlertController(
                          title: "Not Found",
                          message: "Sorry, we cannot find your entered location, Please try another city for weather.",
                          preferredStyle: .alert)
                      alertDialog.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                      self.present(alertDialog, animated: true)
                      return
                  }
        }
    }
    
    
    
    // Api Calling for selected weather location
    func myWeatherApiCalling(_ latitude : CLLocationDegrees, _ longitude : CLLocationDegrees, _ fromPage: String) {
        if(apicalling == false){
            apicalling = true
            var urlString = ""
            if(areYouJumpingToWaterloo == true){
                areYouJumpingToWaterloo = false;
                urlString = "https://api.openweathermap.org/data/2.5/weather?lat=43.4936158&lon=-80.5652623&appid=ee083e447eca3842f05443803f458eb0"
            }else{
                urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=ee083e447eca3842f05443803f458eb0"
            }

            var myAPIRequest = URLRequest(url: URL(string: urlString)!,timeoutInterval: Double.infinity)
            myAPIRequest.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: myAPIRequest) { data, response, error in
                guard let data = data else {
                    print(String(describing: error))
                    return
                }
                do{
                    let weatherData = try
                    JSONDecoder().decode(WeatherData.self, from: data)
                    DispatchQueue.main.async {
                        // Set All API data in UI
                        self.cityNameLabelView?.text = "\((weatherData.name)!)"
                        self.weatherDescriptionLabelView?.text = "\((weatherData.weather?[0].description)!)"
                        self.weatherTitleLabelView?.text = "\((weatherData.weather?[0].main)!)"
                        self.weatherTempretureLabelView?.text = "\(String(format: "%.1f", (weatherData.main?.temp)! - 273.15)) °C"
                        self.weatherTempretureFeesLikeLabelView?.text = "Feels Like : \(String(format: "%.1f", (weatherData.main?.feelsLike)! - 273.15)) °C"
                        self.weatherHumidityLabelView?.text = "\((weatherData.main?.humidity)!) %"
                        self.windSpeedLabelView?.text = "\(String(format: "%.2f", (weatherData.wind?.speed)! * 3.6)) km/h"
                        self.weatherImageView?.load(urlString: "https://openweathermap.org/img/wn/\((weatherData.weather?[0].icon)!).png")
                        
                        // Set background image according to weather
                        if("\((weatherData.weather?[0].main)!)" == "Clouds"){
                            self.backgroundImageView?.image = UIImage(named: "cloud")
                        }else if("\((weatherData.weather?[0].main)!)" == "Atmosphere"){
                            self.backgroundImageView?.image = UIImage(named: "atmosphere")
                        }else if("\((weatherData.weather?[0].main)!)" == "Snow"){
                            self.backgroundImageView?.image = UIImage(named: "snow")
                        }else if("\((weatherData.weather?[0].main)!)" == "Clear"){
                            self.backgroundImageView?.image = UIImage(named: "clear")
                        }else if("\((weatherData.weather?[0].main)!)" == "Rain"){
                            self.backgroundImageView?.image = UIImage(named: "rain")
                        }else if("\((weatherData.weather?[0].main)!)" == "Thunderstorm"){
                            self.backgroundImageView?.image = UIImage(named: "thunderstrom")
                        }else if("\((weatherData.weather?[0].main)!)" == "Drizzle"){
                            self.backgroundImageView?.image = UIImage(named: "drizzel")
                        }else {
                            self.backgroundImageView?.image = UIImage(named: "weather")
                        }
                        
                    
                        // Add searched weather into history
                        if(fromPage != ""){
                            // Formatted Date
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "dd MMM, yyyy"
                            let formattedDate = dateFormatter.string(from: Date())
                            
                            // Formatted Time
                            let timeFormatter = DateFormatter()
                            timeFormatter.dateFormat = "h:mm a"
                            let formattedTime = timeFormatter.string(from: Date())

                            // Add searched history in local database
                            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                            let weatherHistory = History(context: context)
                            
                            weatherHistory.historyType = "weather"
                            weatherHistory.from = fromPage
                            weatherHistory.city = self.cityNameLabelView?.text
                            weatherHistory.date = formattedDate
                            weatherHistory.time = formattedTime
                            weatherHistory.temperature = self.weatherTempretureLabelView?.text
                            weatherHistory.wind = self.windSpeedLabelView?.text
                            weatherHistory.humidity = self.weatherHumidityLabelView?.text
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
                }catch{
                    self.cityNameLabelView?.text = "Error"
                    self.weatherDescriptionLabelView?.text = "Error"
                    self.weatherTitleLabelView?.text = "Error"
                    self.weatherTempretureLabelView?.text = "Error"
                    self.weatherTempretureFeesLikeLabelView?.text = "Error"
                    self.weatherHumidityLabelView.text = "Error"
                    self.windSpeedLabelView?.text = "Error"
                    let alertDialog = UIAlertController(
                        title: "Error",
                        message: "Sorry, we have some problem here to provide weather information. Please try again after some time.",
                        preferredStyle: .alert)
                    alertDialog.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alertDialog, animated: true)
                    
                    print(error.localizedDescription)
                }
                print(String(data: data, encoding: .utf8)!)
            }
            task.resume()
        }
    }
    
    
    

    // This Protocol Function trigger when user directly come from another view controller
    func weatherFromMainFunction(cityName: String) {
        convertAddress(cityName, "Main")
        weatherDelegate?.weatherDidCallFunction(data: cityName)
    }
    

}

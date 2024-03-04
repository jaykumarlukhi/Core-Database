//
//  NewsTableViewController.swift


import UIKit

// Protocol for news
protocol NewsViewControllerDelegate: AnyObject {
    func newsDidCallFunction(data: String)
}


class NewsTableViewController: UITableViewController {
    
    // TableView for news list
    @IBOutlet weak var newsTableView: UITableView!
    
    
    // Variable Declaration
    var cityNews = ""
    var newsList:[Article] = []
    weak var newsDelegate: NewsViewControllerDelegate?

    
    
    // Function for Alert box which can provide news for perticular city
    @IBAction func OpenAlertForCity(_ sender: Any) {
        
        // Create alert for discover city news
        let alertDialog = UIAlertController(
            title: "Which city's news do you want?",
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
            let newsCityField = alertDialog.textFields![0] as UITextField
            self.dismissKeyboard()
            if(!(newsCityField.text ?? "").isEmpty){
                self.newsApiCall(newsCityField.text!, "News")
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
    
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newsList.count
    }
    
    
    override func tableView(_ mytableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mytableView.dequeueReusableCell(withIdentifier: "MyNewsCell", for: indexPath) as! MyNewsCell
        cell.newsTitleTextView?.text = "Title : \(newsList[indexPath.item].title ?? "NA" as String)"
        cell.newsAuthorLabelView?.text = "Author : \(newsList[indexPath.item].author ?? "NA" as String)"
        cell.newsImageView?.load(urlString: "\(newsList[indexPath.item].urlToImage ?? "" as String)")
        cell.newsSourceLabelView?.text = "Source : \((newsList[indexPath.item].source?.name!) ?? "NA" as String)"
        cell.newsDescriptionLabelView?.text = "Description : \(newsList[indexPath.item].description ?? "NA" as String)"
        return cell
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ------ Initialization of TableView
        self.newsTableView?.dataSource = self
        self.newsTableView?.delegate = self
        
        // ------ Register Custom Cell in TableView
        let nib = UINib(nibName: "MyNewsCell", bundle: nil)
        self.newsTableView?.register(nib, forCellReuseIdentifier: "MyNewsCell")
        
        // ------ Tap event recognizer
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // ------ News API calling
        if(cityNews == ""){
            newsApiCall("trending", "News") //pdcif tma y jojo
        }
    }

    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
    
  
    
    // Function for news api calling
    func newsApiCall(_ cityName: String, _ fromPage : String) {
        
        self.newsList.removeAll() // Remove all data fromlist before calling an API
        
        let APIKey = "46cc49b183f248c3a2b681bae5bb6d94"
        var request = URLRequest(url: URL(string: "https://newsapi.org/v2/everything?q=\(cityName)&apiKey=\(APIKey)")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if(data != nil) {
                do {
                    let decoder = JSONDecoder()
                    let newData = try decoder.decode(NewsData.self, from: data!)
                    DispatchQueue.main.async {
                        // Assign data in list and Reload the view
                        self.newsList = newData.articles!
                        self.tableView.reloadData()

                        // Add first news in Search local History
                        if(cityName != "trending"){
                            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

                            let newsHistory = History(context: context)

                            newsHistory.historyType = "news"
                            newsHistory.from = fromPage
                            newsHistory.city = cityName
                            newsHistory.title = self.newsList[0].title ?? "NA"
                            newsHistory.descrip = self.newsList[0].description ?? "NA"
                            newsHistory.author = self.newsList[0].author ?? "NA"
                            newsHistory.sourceName = self.newsList[0].source?.name ?? "NA"
                            
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
                } catch let decodingError {
                    let alertDialog = UIAlertController(
                        title: "Error",
                        message: "Sorry, we have some problem here. Please try again after some time.",
                        preferredStyle: .alert)
                    alertDialog.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alertDialog, animated: true)
                }
            }
            print(String(data: data ?? Data(), encoding: .utf8)!)
        }
        task.resume()
    }
    
    // This Protocol Function trigger when user directly come from another view controller
    func newsFromMainFunction(cityName: String) {
        newsApiCall(cityName, "Main")
        newsDelegate?.newsDidCallFunction(data: cityName)
    }
    
}



// I am using a protocol for parsing data from one viewcontroller to another viewcontroller, I refer from the following site
// https://stackoverflow.com/questions/54647662/using-delegate-how-to-pass-data-between-classes-ios

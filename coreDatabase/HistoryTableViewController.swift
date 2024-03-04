//
//  HistoryTableViewController.swift


import UIKit

// Global variable for the history list
var mySearchHistoryList = [History]()


class HistoryTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    

    
    func getMySearchOrAddStaticHistory(){
        do{
            mySearchHistoryList = try context.fetch(History.fetchRequest())
            if(mySearchHistoryList.count == 0){
                // Local variable declaration
                let newsOne = History(context: context)
                let newsTwo = History(context: context)
                let weatherOne = History(context: context)
                let weatherTwo = History(context: context)
                let mapOne = History(context: context)

                // News history item
                newsOne.historyType = "news"
                newsOne.from = "News"
                newsOne.city = "Toronto"
                newsOne.title = "Tempting tech"
                newsOne.descrip = "The government of Prime Minister Srettha Thavisin has visited several large conglomerates over the past few months in an effort to increase foreign direct investment (FDI), notably in digital and high-tech industries."
                newsOne.author = "Harry"
                newsOne.sourceName = "google.com"
                
                
                // Weather history item
                weatherTwo.historyType = "weather"
                weatherTwo.from = "Main"
                weatherTwo.date = "05 Dec 2023"
                weatherTwo.time = "08:30 am"
                weatherTwo.city = "Toronto"
                weatherTwo.temperature = "-24 °C"
                weatherTwo.wind = "20 Km/h"
                weatherOne.humidity = "78 %"
                
                
                // Map history item
                mapOne.historyType = "directions"
                mapOne.from = "Map"
                mapOne.city = "Fergus"
                mapOne.startPoint = "Fergus"
                mapOne.endPoint = "Waterloo"
                mapOne.totalDistance = "40 Km"
                mapOne.travelMode = "car"
                
                
                // News history item
                newsTwo.historyType = "news"
                newsTwo.from = "Main"
                newsTwo.city = "Waterloo"
                newsTwo.title = "2025 Tesla Cybertruck - The Big Picture"
                newsTwo.descrip = "Earlier this week, as we awaited the introduction of the actual production vehicle of the Cybertruck, I jotted down some thoughts on Tesala’s latest. The actual reveal was both better (at the top end) and worse (at the entry-level) than anticipated: The truck…"
                newsTwo.author = "Scalan"
                newsTwo.sourceName = "facebook.com"
                
                
                // Weather history item
                weatherOne.historyType = "weather"
                weatherOne.from = "Weather"
                weatherOne.date = "01 Dec 2023"
                weatherOne.time = "10:00 am"
                weatherOne.city = "Cambridge"
                weatherOne.temperature = "4 °C"
                weatherOne.wind = "5 Km/h"
                weatherOne.humidity = "78 %"
                 
            
                try context.save()
         
            }else{
                getMySearchHistory()
            }
        }catch{
        }
    }
    
    
    
    // TableView for the recent events record in app
    @IBOutlet weak var historyTableView: UITableView!


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mySearchHistoryList.count
    }

    
    // Function for remove history item from the list
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            
            // Remove History from HistoryList
            context.delete(mySearchHistoryList[indexPath.row])
            do{
               try context.save()
            }catch{
            }
            
            // Reload Table
            getMySearchHistory()
            
        }
    }
    
    

    override func tableView(_ mytableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mytableView.dequeueReusableCell(withIdentifier: "MyHistoryCell", for: indexPath) as! MyHistoryCell
        
        // Cell UI & Set List data in a cell
        if(mySearchHistoryList[indexPath.item].historyType == "news"){
            cell.myCustomView.backgroundColor = UIColor(red: 160/255, green: 255/255, blue: 148/255, alpha: 1)
            cell.myCustomView.layer.borderColor = UIColor(red: 17/255, green: 148/255, blue: 0/255, alpha: 1).cgColor
            cell.myCustomLabelView?.text = "News"
            cell.myCustomTextView?.text = "City : \(mySearchHistoryList[indexPath.item].city ?? "NA" as String)\nTitle : \(mySearchHistoryList[indexPath.item].title ?? "NA" as String)\nDescription : \(String(describing: mySearchHistoryList[indexPath.item].descrip ?? "NA" as String))"
            cell.myCustomImageView.image = UIImage(named: "news")
        }else if(mySearchHistoryList[indexPath.item].historyType == "weather"){
            cell.myCustomView.backgroundColor = UIColor(red: 228/255, green: 227/255, blue: 255/255, alpha: 1)
            cell.myCustomView.layer.borderColor = UIColor.blue.cgColor
            cell.myCustomLabelView?.text = "Weather"
            cell.myCustomTextView?.text = "City : \(mySearchHistoryList[indexPath.item].city ?? "NA" as String)\nDate : \(mySearchHistoryList[indexPath.item].date ?? "NA" as String)\nTime : \(mySearchHistoryList[indexPath.item].time ?? "NA" as String)\nWind : \(mySearchHistoryList[indexPath.item].wind ?? "NA" as String)\nTemperature : \(mySearchHistoryList[indexPath.item].temperature ?? "NA" as String)\nHumidity : \(mySearchHistoryList[indexPath.item].humidity ?? "NA" as String)"
            cell.myCustomImageView.image = UIImage(named: "weatherIcon")
        }else{
            cell.myCustomView.backgroundColor = UIColor(red: 255/255, green: 229/255, blue: 112/255, alpha: 1)
            cell.myCustomView.layer.borderColor = UIColor(red: 199/255, green: 163/255, blue: 2/255, alpha: 1).cgColor
            cell.myCustomLabelView?.text = "Distance"
            cell.myCustomTextView?.text = "City : \(mySearchHistoryList[indexPath.item].city ?? "NA" as String)\nStart \u{1f4cd}: \(mySearchHistoryList[indexPath.item].startPoint ?? "NA" as String)\nEnd \u{1f4cd}: \(mySearchHistoryList[indexPath.item].endPoint ?? "NA" as String)\nTravel Distance : \(mySearchHistoryList[indexPath.item].totalDistance ?? "NA" as String)\nTravel Mode : \(mySearchHistoryList[indexPath.item].travelMode ?? "NA" as String)"
            cell.myCustomImageView.image = UIImage(named: "distance")
        }
        cell.myFromLabelView?.text = "From: \(mySearchHistoryList[indexPath.item].from ?? "NA" as String)"

        return cell
    }
    
    
    
    var i = 1, n = 5
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ------ Initialization of TableView
        self.historyTableView.dataSource = self
        self.historyTableView.delegate = self
        
        // ------ Register Custom Cell in TableView
        let nib = UINib(nibName: "MyHistoryCell", bundle: nil)
        historyTableView.register(nib, forCellReuseIdentifier: "MyHistoryCell")
        
        // ------ Get initial history
        getMySearchOrAddStaticHistory()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("History View Shown")
        getMySearchHistory()
    }
    
    
    // Function for get history from local
    func getMySearchHistory(){
        do{
            mySearchHistoryList = try context.fetch(History.fetchRequest())
            DispatchQueue.main.async {
                // Reverse my history list
                mySearchHistoryList.reverse() 
                self.historyTableView.reloadData()
            }
        }catch{
            
        }
    }
    
}




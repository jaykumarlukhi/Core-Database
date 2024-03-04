//
//  History+CoreDataProperties.swift


import Foundation
import CoreData


extension History {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<History> {
        return NSFetchRequest<History>(entityName: "History")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var city: String?
    @NSManaged public var historyType: String?
    @NSManaged public var from: String?
    @NSManaged public var date: String?
    @NSManaged public var time: String?
    @NSManaged public var temperature: String?
    @NSManaged public var totalDistance: String?
    @NSManaged public var travelMode: String?
    @NSManaged public var sourceName: String?
    @NSManaged public var author: String?
    @NSManaged public var title: String?
    @NSManaged public var urlToImage: String?
    @NSManaged public var descrip: String?
    @NSManaged public var wind: String?
    @NSManaged public var humidity: String?
    @NSManaged public var startPoint: String?
    @NSManaged public var endPoint: String?

}

extension History : Identifiable {

}

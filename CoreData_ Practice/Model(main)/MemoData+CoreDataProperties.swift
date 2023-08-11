//
//  MemoData+CoreDataProperties.swift
//  CoreData_ Practice
//
//  Created by Macbook on 2023/08/10.
//
//

import Foundation
import CoreData


extension MemoData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MemoData> {
        return NSFetchRequest<MemoData>(entityName: "MemoData")
    }

    @NSManaged public var text: String?
    @NSManaged public var date: Date?
    @NSManaged public var color: Int16

    
    var dateString: String? {
            let myFormatter = DateFormatter()
            myFormatter.dateFormat = "yyyy-MM-dd"
            guard let date = self.date else { return "" }
            let savedDateString = myFormatter.string(from: date)
            return savedDateString
        }

}

extension MemoData : Identifiable {

}

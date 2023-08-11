//
//  CompletionMemo+CoreDataProperties.swift
//  CoreData_ Practice
//
//  Created by Macbook on 2023/08/11.
//
//

import Foundation
import CoreData


extension CompletionMemo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CompletionMemo> {
        return NSFetchRequest<CompletionMemo>(entityName: "CompletionMemo")
    }

    @NSManaged public var color: Int16
    @NSManaged public var date: Date?
    @NSManaged public var text: String?
    
    var dateString: String? {
            let myFormatter = DateFormatter()
            myFormatter.dateFormat = "yyyy-MM-dd"
            guard let date = self.date else { return "" }
            let savedDateString = myFormatter.string(from: date)
            return savedDateString
        }

}

extension CompletionMemo : Identifiable {

}

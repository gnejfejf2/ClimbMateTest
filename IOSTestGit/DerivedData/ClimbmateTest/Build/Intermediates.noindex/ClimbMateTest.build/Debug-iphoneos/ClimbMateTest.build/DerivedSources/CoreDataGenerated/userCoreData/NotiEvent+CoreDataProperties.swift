//
//  NotiEvent+CoreDataProperties.swift
//  
//
//  Created by kang jiyoun on 2021. 1. 11..
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension NotiEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NotiEvent> {
        return NSFetchRequest<NotiEvent>(entityName: "NotiEvent")
    }

    @NSManaged public var eventDate: Date?
    @NSManaged public var eventNumber: String?
    @NSManaged public var eventType: String?

}

extension NotiEvent : Identifiable {

}

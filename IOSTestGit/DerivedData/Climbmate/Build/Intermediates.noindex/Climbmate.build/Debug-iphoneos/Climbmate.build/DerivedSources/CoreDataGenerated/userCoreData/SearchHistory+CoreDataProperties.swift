//
//  SearchHistory+CoreDataProperties.swift
//  
//
//  Created by kang jiyoun on 2020. 11. 4..
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension SearchHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchHistory> {
        return NSFetchRequest<SearchHistory>(entityName: "SearchHistory")
    }

    @NSManaged public var keyword: String?
    @NSManaged public var searchDate: Date?
    @NSManaged public var totalCount: Int16

}

extension SearchHistory : Identifiable {

}

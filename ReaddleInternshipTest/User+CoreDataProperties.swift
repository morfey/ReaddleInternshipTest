//
//  User+CoreDataProperties.swift
//  
//
//  Created by  Tim on 14.06.17.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?

}

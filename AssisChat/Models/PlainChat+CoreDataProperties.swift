//
//  PlainChat+CoreDataProperties.swift
//  AssisChat
//  Created by JoyTim on 2024/4/29
//  Copyright © 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import CoreData
import Foundation

public extension PlainChat {
    @nonobjc class func fetchRequest() -> NSFetchRequest<PlainChat> {
        return NSFetchRequest<PlainChat>(entityName: "PlainChat")
    }

    @NSManaged var rawAutoCopy: Bool
    @NSManaged var rawColor: String?
    @NSManaged var rawCreatedAt: Date?
    @NSManaged var rawHistoryLengthToSend: Int16
    @NSManaged var rawIcon: String?
    @NSManaged var rawMessagePrefix: String?
    @NSManaged var rawModel: String?
    @NSManaged var rawName: String?
    @NSManaged var rawOpenAIModel: String?
    @NSManaged var rawSystemMessage: String?
    @NSManaged var rawTemperature: Float
    @NSManaged var rawUpdatedAt: Date?
}

extension PlainChat: Identifiable {}

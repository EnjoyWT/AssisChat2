//
//  PlainChat+CoreDataClass.swift
//  AssisChat
//  Created by JoyTim on 2024/4/29
//  Copyright © 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import CoreData
import Foundation
import SwiftUI

@objc(PlainChat)
public class PlainChat: NSManagedObject {
    var name: String {
        return rawName ?? "[UNKNOWN]"
    }

    var icon: Chat.Icon {
        if let r = rawIcon {
            return Chat.Icon(rawValue: r) ?? .default
        } else {
            return .default
        }
    }

    var color: Chat.Color? {
        get {
            if let r = rawColor {
                return Chat.Color(rawValue: r) ?? .default
            } else {
                return nil
            }
        }
        set {
            rawColor = newValue?.rawValue
        }
    }

    var temperature: Chat.Temperature {
        return Chat.Temperature(rawValue: rawTemperature) ?? .balanced
    }

    var systemMessage: String? {
        return rawSystemMessage
    }

    var messagePrefix: String? {
        return rawMessagePrefix
    }

    /// The actual number of history length to send
    var historyLengthToSend: Int16 {
        return max(rawHistoryLengthToSend == .historyLengthToSendMax ? .max : rawHistoryLengthToSend, 1)
    }

    /// The actual number of history length to send, `-1` for max
    var storedHistoryLengthToSend: Int16 {
        return rawHistoryLengthToSend
    }

    var autoCopy: Bool {
        rawAutoCopy
    }

    var model: String? {
        rawOpenAIModel ?? rawModel
    }

    var predicate: NSPredicate {
        NSPredicate(format: "rChat == %@", self)
    }

    func preprocessContent(content: String) -> String? {
        return messagePrefix != nil ? messagePrefix! + "\n\n" + content : nil
    }

    /// Update the updatedAt field
    public func touch() {
        rawUpdatedAt = Date()
    }

    override public func awakeFromInsert() {
        rawCreatedAt = Date()
        touch()
    }

    var available: Bool {
        name.count > 0
    }
}

extension PlainChat {
    func convertToModel() -> PlainChatModel {
        .init(name: name, temperature: temperature, systemMessage: systemMessage, historyLengthToSend: historyLengthToSend, messagePrefix: messagePrefix, autoCopy: autoCopy, icon: icon, color: color, model: model ?? "")
    }
}

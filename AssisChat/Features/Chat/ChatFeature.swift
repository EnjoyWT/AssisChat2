//
//  ChatFeature.swift
//  AssisChat
//
//  Created by Nooc on 2023-03-05.
//

import Combine
import CoreData
import Foundation

struct PlainChatModel {
    let name: String
    let temperature: Chat.Temperature
    let systemMessage: String?
    let historyLengthToSend: Int16
    let messagePrefix: String?
    let autoCopy: Bool
    let icon: Chat.Icon
    let color: Chat.Color?
    var model: String

    var available: Bool {
        name.count > 0
    }
}

class ChatFeature: ObservableObject {
    let essentialFeature: EssentialFeature

    var objectsSavedCancelable: AnyCancellable?

    init(essentialFeature: EssentialFeature) {
        self.essentialFeature = essentialFeature
    }
}

// MARK: - Data

extension ChatFeature {
    func createChat(_ plainChat: PlainChatModel, forModel: String? = nil) {
        guard plainChat.available else { return }

        let chat = Chat(context: essentialFeature.context)

        chat.rawName = plainChat.name
        chat.rawIcon = plainChat.icon.rawValue
        chat.color = plainChat.color
        chat.rawTemperature = plainChat.temperature.rawValue
        chat.rawSystemMessage = plainChat.systemMessage
        chat.rawHistoryLengthToSend = plainChat.historyLengthToSend
        chat.rawMessagePrefix = plainChat.messagePrefix
        chat.rawAutoCopy = plainChat.autoCopy

        if let model = forModel {
            chat.rawModel = model
        } else {
            chat.rawModel = plainChat.model
        }

        essentialFeature.persistData()
    }

    func updateChat(_ plainChat: PlainChatModel, for chat: Chat) {
        guard plainChat.available else { return }

        chat.rawName = plainChat.name
        chat.rawIcon = plainChat.icon.rawValue
        chat.color = plainChat.color
        chat.rawTemperature = plainChat.temperature.rawValue
        chat.rawSystemMessage = plainChat.systemMessage
        chat.rawHistoryLengthToSend = plainChat.historyLengthToSend
        chat.rawMessagePrefix = plainChat.messagePrefix
        chat.rawAutoCopy = plainChat.autoCopy
        chat.rawModel = plainChat.model

        chat.touch()

        essentialFeature.persistData()
    }

    func clearMessages(for chat: Chat) {
        let messagesFetchRequest: NSFetchRequest<Message> = Message.fetchRequest()
        messagesFetchRequest.predicate = chat.predicate

        do {
            let messages = try essentialFeature.context.fetch(messagesFetchRequest)
            for message in messages {
                essentialFeature.context.delete(message)
            }

            try essentialFeature.context.save()
        } catch {
            print("Error fetching or deleting messages: \(error)")
        }
    }

    func deleteChats(_ chats: [Chat]) {
        chats.forEach(essentialFeature.context.delete)

        essentialFeature.persistData()
    }

    func pinChat(chat: Chat) {
        chat.rawPinOrder = Int64(Date().timeIntervalSince1970)

        essentialFeature.persistData()
    }

    func unpinChat(chat: Chat) {
        chat.rawPinOrder = Chat.unpinned

        essentialFeature.persistData()
    }
}

extension ChatFeature {
    func createChatModel(_ plainChat: PlainChatModel, forModel: String? = nil) {
        guard plainChat.available else { return }

        let chat = PlainChat(context: essentialFeature.context)

        chat.rawName = plainChat.name
        chat.rawIcon = plainChat.icon.rawValue
        chat.color = plainChat.color
        chat.rawTemperature = plainChat.temperature.rawValue
        chat.rawSystemMessage = plainChat.systemMessage
        chat.rawHistoryLengthToSend = plainChat.historyLengthToSend
        chat.rawMessagePrefix = plainChat.messagePrefix
        chat.rawAutoCopy = plainChat.autoCopy

        if let model = forModel {
            chat.rawModel = model
        } else {
            chat.rawModel = plainChat.model
        }

        essentialFeature.persistData()
    }

    func updateChatModel(_ plainChat: PlainChatModel, for chat: PlainChat) {
        guard plainChat.available else { return }

        chat.rawName = plainChat.name
        chat.rawIcon = plainChat.icon.rawValue
        chat.color = plainChat.color
        chat.rawTemperature = plainChat.temperature.rawValue
        chat.rawSystemMessage = plainChat.systemMessage
        chat.rawHistoryLengthToSend = plainChat.historyLengthToSend
        chat.rawMessagePrefix = plainChat.messagePrefix
        chat.rawAutoCopy = plainChat.autoCopy
        chat.rawModel = plainChat.model

        chat.touch()

        essentialFeature.persistData()
    }

}

// MARK: - Templates

extension ChatFeature {
//    func createPresets(presets: [PlainChatModel], forModel: String? = nil) {
//        // Reversed for correct order
//        for var template in presets.reversed() {
//            if let model = forModel {
//                template.model = model
//            }
//
//            createChat(template)
//        }
//    }
    func createPresets(presets: [PlainChatModel], forModel: String? = nil) {
        // Reversed for correct order
        for var template in presets.reversed() {
            if let model = forModel {
                template.model = model
            }

            createChatModel(template)
        }
    }
}

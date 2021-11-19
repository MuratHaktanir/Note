//
//  Notes.swift
//  Note
//
//  Created by Murat Haktanır on 15.11.2021.
//

import Foundation

// MARK: - Notes
struct Notes: Codable, Identifiable {

    let id: UUID
    var title: String
    var detail: String
    var day: Date
    var time: Date
    var notifyDay: Bool
    var notifyTime: Bool
    var isComplete: Bool
    
    init(id: UUID = UUID(), title: String, detail: String, day: Date, time: Date, notifyDay: Bool, notifyTime: Bool, isComplete: Bool) {
        self.id = id
        self.title = title
        self.detail = detail
        self.day = day
        self.time = time
        self.notifyDay = notifyDay
        self.notifyTime = notifyTime
        self.isComplete = isComplete
    }
}

extension Notes {
    static var data: [Notes] {
        [
            Notes(title: "Note 1",
                  detail: "Note 1 detail about something",
                  day: Date(),
                  time: Date(),
                  notifyDay: true,
                  notifyTime: true,
                  isComplete: true),
            
            Notes(title: "Note 2",
                  detail: "Note 2 detail about something",
                  day: Date(),
                  time: Date(),
                  notifyDay: true,
                  notifyTime: true,
                  isComplete: false)
        ]
    }
}

extension Notes {
    struct Data {
        var title: String = ""
        var detail: String = ""
        var day: Date = Date()
        var time: Date = Date()
        var notifyDay: Bool = false
        var notifyTime: Bool = false
        var isComplete: Bool = false
    }
    
    var data: Data {
        return Data(title: title,
                    detail: detail,
                    day: day,
                    time: time,
                    notifyDay: notifyDay,
                    notifyTime: notifyTime,
                    isComplete: isComplete)
    }
    
    mutating func update(from data: Data) {
        title = data.title
        detail = data.detail
        day = data.day
        time = data.time
        notifyDay = data.notifyDay
        notifyTime = data.notifyTime
        isComplete = data.isComplete
    }
}


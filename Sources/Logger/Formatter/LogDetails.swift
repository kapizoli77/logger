//
//  LogDetails.swift
//  Logger
//

import Foundation

public struct LogDetails: Encodable {
    public var message: String
    public var category: Category?
    public var level: Level
    public let metaInfo: LogMetaInfo

    public init(message: String,
                category: Category?,
                level: Level,
                metaInfo: LogMetaInfo) {
        self.message = message
        self.category = category
        self.level = level
        self.metaInfo = metaInfo
    }
}

public struct LogMetaInfo: Encodable {
    public var date: Date
    public var fileName: String
    public var functionName: String
    public var lineNumber: Int

    init(date: Date, fileName: String, functionName: String, lineNumber: Int) {
        self.date = date
        self.fileName = fileName
        self.functionName = functionName
        self.lineNumber = lineNumber
    }
}

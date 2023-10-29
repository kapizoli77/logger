//
//  LogDetails.swift
//  Logger
//

public struct LogDetails {
    public var message: String
    public var originalMessage: Any?
    public var category: Category?
    public var level: Level
    public let metaInfo: LogMetaInfo

    public init(message: String,
                originalMessage: Any?,
                category: Category?,
                level: Level,
                metaInfo: LogMetaInfo) {
        self.message = message
        self.originalMessage = originalMessage
        self.category = category
        self.level = level
        self.metaInfo = metaInfo
    }
}

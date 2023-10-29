//
//  MetaInfoFormatter.swift
//  Logger
//

import Foundation

public final class MetaInfoFormatter {
    // MARK: - Properties

    public var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()

    // MARK: - Initialization

    public init() {}

    // MARK: - Functions

    private func metaInfo(by metaInfo: LogMetaInfo) -> String {
        var metaInfoMessage = ""

        let fileName = (metaInfo.fileName as NSString).lastPathComponent

        metaInfoMessage += dateFormatter.string(from: metaInfo.date)
        metaInfoMessage += " [\(fileName)]"
        metaInfoMessage += " [\(metaInfo.lineNumber)]"
        metaInfoMessage += " [\(metaInfo.functionName)]\n"

        return metaInfoMessage
    }
}

// MARK: - FormatterProtocol

extension MetaInfoFormatter: Formatter {
    public func format(details: inout LogDetails) {
        details.message = metaInfo(by: details.metaInfo) + details.message
    }
}


//  LogDetails.swift
//  Logger
//

import Foundation

public struct LogMetaInfo {
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

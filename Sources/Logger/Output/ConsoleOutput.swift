//
//  ConsoleOutput.swift
//  Logger
//

import Foundation

public final class ConsoleOutput {
    // MARK: - Output properties

    public var logLevel: Level
    public var formatters = [Formatter]()
    public var filters = [Filter]()

    // MARK: - Initialization

    public init(logLevel: Level) {
        self.logLevel = logLevel
    }
}

// MARK: - Output

extension ConsoleOutput: Output {
    public func write(details: LogDetails, finalMessage: String) {
        print(finalMessage)
    }
}

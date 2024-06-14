//
//  ConsoleOutput.swift
//  Logger
//

import Foundation

public final class ConsoleOutput {

    // MARK: - Types

    public enum Mode {
        /// log messages will be visible only in Xcode
        case print
        /// log messages will be visible in Xcode and Console app
        case nsLog
    }

    // MARK: - Output properties

    public var formatters = [Formatter]()
    public var filters = [Filter]()

    private let mode: Mode
    private let minLogLevel: Level

    // MARK: - Initialization

    public init(minLogLevel: Level, mode: Mode = .print) {
        self.minLogLevel = minLogLevel
        self.mode = mode
    }
}

// MARK: - Output

extension ConsoleOutput: Output {
    public func write(details: LogDetails, finalMessage: String) {
        switch mode {
        case .print: print(finalMessage)
        case .nsLog: NSLog(finalMessage)
        }
    }

    public func shouldLog(by level: Level) -> Bool {
        level >= minLogLevel
    }
}

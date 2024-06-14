//
//  FileOutput.swift
//
//

import Foundation

public final class FileOutput {

    // MARK: Private properties

    private let fileLogWriter: FileLogWriter

    // MARK: Properties

    public var minLogLevel: Level
    public var formatters = [Formatter]()
    // Need to filter out every file log related log entry to avoid infinite loop
    public var filters: [Filter] = [CategoryFilter(category: .logToFile)]

    // MARK: Init

    public init(minLogLevel: Level, settings: FileLogWriter.Settings = .default) {
        self.minLogLevel = minLogLevel
        self.fileLogWriter = FileLogWriter(settings: settings)
    }
}

// MARK: - Actions

extension FileOutput {
    public func getLogFiles() -> [String] {
        fileLogWriter.getLogFiles()
    }
}

// MARK: - Output

extension FileOutput: Output {
    public func write(details: LogDetails, finalMessage: String) {
        fileLogWriter.appendToFile(finalMessage)
    }

    public func shouldLog(by level: Level) -> Bool {
        level >= minLogLevel
    }
}

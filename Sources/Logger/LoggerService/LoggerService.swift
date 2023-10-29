//
//  LoggerService.swift
//  Logger
//

import Foundation

// MARK: - Types

public struct LoggerServiceName: ExpressibleByStringLiteral, Codable, Equatable, CustomStringConvertible {
    public let value: String

    public var description: String {
        return value
    }

    public init(stringLiteral value: String) {
        self.value = value
    }
}

public protocol LoggerService {
    var name: LoggerServiceName { get }
    var outputs: [Output] { get set }

    func addFormatter(_ formatter: Formatter, for output: Output?)
    func removeFormatter(_ formatter: Formatter, for output: Output?)

    func addFilter(_ filter: Filter, for output: Output?)
    func removeFilter(_ filter: Filter, for output: Output?)

    func addOutput(output: Output)
    func removeOutput(output: Output)
}

// MARK: - Add default arguments

extension LoggerService {
    public func addFormatter(_ formatter: Formatter, for output: Output? = nil) {
        addFormatter(formatter, for: output)
    }

    public func removeFormatter(_ formatter: Formatter, for output: Output? = nil) {
        removeFormatter(formatter, for: output)
    }

    public func addFilter(_ filter: Filter, for output: Output? = nil) {
        addFilter(filter, for: output)
    }

    public func removeFilter(_ filter: Filter, for output: Output? = nil) {
        removeFilter(filter, for: output)
    }
}

// MARK: - Internal extension

extension LoggerService {
    func log(_ closure: @autoclosure @escaping () -> Any?,
             category: Category? = nil,
             level: Level,
             fileName: String = #file,
             functionName: String = #function,
             lineNumber: Int = #line) {
        let closureResult = closure() ?? "nil"

        let metaInfo = LogMetaInfo(date: Date(), fileName: fileName, functionName: functionName, lineNumber: lineNumber)
        let logDetails = LogDetails(message: String(describing: closureResult),
                                    originalMessage: closure(),
                                    category: category,
                                    level: level,
                                    metaInfo: metaInfo)

        log(details: logDetails)
    }

    func log(details: LogDetails) {
        for output in outputs {
            output.log(details: details)
        }
    }
}

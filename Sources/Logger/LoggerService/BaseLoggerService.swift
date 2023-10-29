//
//  BaseLoggerService.swift
//  Logger
//

import Foundation

class BaseLoggerService {
    // MARK: - LoggerService properties

    public let name: LoggerServiceName
    public var outputs: [Output] = {
        #if DEBUG
        let logLevel: Level = .debug
        #else
        let logLevel: Level = .error
        #endif
        return [ConsoleOutput(logLevel: logLevel)]
    }()

    // MARK: - Initialization

    init(name: LoggerServiceName) {
        self.name = name
    }
}

// MARK: - LoggerService

extension BaseLoggerService: LoggerService {
    func addFormatter(_ formatter: Formatter, for output: Output?) {
        guard let output = output else {
            outputs.forEach { $0.formatters.append(formatter) }
            return
        }

        output.formatters.append(formatter)
    }

    func removeFormatter(_ formatter: Formatter, for output: Output?) {
        guard let output = output else {
            outputs.forEach { $0.removeFormatter(formatter) }
            return
        }

        output.removeFormatter(formatter)
    }

    func addFilter(_ filter: Filter, for output: Output?) {
        guard let output = output else {
            outputs.forEach { $0.addFilter(filter) }
            return
        }

        output.addFilter(filter)
    }

    func removeFilter(_ filter: Filter, for output: Output?) {
        guard let output = output else {
            outputs.forEach { $0.removeFilter(filter) }
            return
        }

        output.removeFilter(filter)
    }

    func addOutput(output: Output) {
        guard !outputs.contains(where: { $0.name == output.name }) else {
            return
        }

        outputs.append(output)
    }

    func removeOutput(output: Output) {
        guard let index = outputs.firstIndex(where: { $0.name == output.name }) else {
            return
        }

        outputs.remove(at: index)
    }
}

// MARK: - LoggerServiceName

extension LoggerServiceName {
    public static let `default` = LoggerServiceName(stringLiteral: "Default")
}

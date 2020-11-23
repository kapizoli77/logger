//
//  RemoteOutput.swift
//  Logger
//

import Foundation
import Alamofire

// MARK: - Types

public protocol RemoteLogDecorator: class {
    func decorateLogMessage(with message: String) -> String
}

private class DefaultRemoteLogDecorator: RemoteLogDecorator {
    func decorateLogMessage(with message: String) -> String {
        return message
    }
}

public final class RemoteOutput {
    // MARK: - Properties

    public let endpoint: URL
    public var decorator: RemoteLogDecorator = DefaultRemoteLogDecorator()
    public var bodyCreator: (LogDetails, String) -> [String: Any] = { _, finalMessage in
        return ["message": finalMessage]
    }

    // MARK: - Output proiperties

    public var logLevel: Level
    public var formatters = [Formatter]()
    public var filters = [Filter]()

    // MARK: - Initialization

    public init(logLevel: Level, endpoint: URL) {
        self.logLevel = logLevel
        self.endpoint = endpoint
    }
}

// MARK: - Output

extension RemoteOutput: Output {
    public func log(details: LogDetails) {
        // Apply Filters
        for filter in filters {
            if !filter.shouldLog(details: details) {
                return
            }
        }

        var logDetails = details
        // Apply Formatters
        formatters.forEach { $0.format(details: &logDetails) }

        // Decorate the log message
        let finalMessage = decorator.decorateLogMessage(with: logDetails.message)

        // Send log String to the specific output
        write(details: logDetails, finalMessage: finalMessage)
    }

    public func write(details: LogDetails, finalMessage: String) {
        let params = bodyCreator(details, finalMessage)
        Alamofire.request(
            endpoint,
            method: HTTPMethod.post,
            parameters: params,
            encoding: Alamofire.URLEncoding.default,
            headers: nil).responseJSON { result in
                guard let response = result.response else { return }

                print(response.statusCode)
        }
    }
}

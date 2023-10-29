//
//  RemoteOutput.swift
//  Logger
//

import Foundation

// MARK: - Types

public protocol RemoteLogDecorator: AnyObject {
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

    private let urlSession: URLSession

    // MARK: - Output proiperties

    public var logLevel: Level
    public var formatters = [Formatter]()
    public var filters = [Filter]()

    // MARK: - Initialization

    public init(logLevel: Level, endpoint: URL, urlSession: URLSession = URLSession.shared) {
        self.logLevel = logLevel
        self.endpoint = endpoint
        self.urlSession = urlSession
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
        let bodyData = try? JSONSerialization.data(withJSONObject: params)
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        urlSession.dataTask(with: request) { _, _, _ in
            // TODO: - Handle at least error
        }
    }
}

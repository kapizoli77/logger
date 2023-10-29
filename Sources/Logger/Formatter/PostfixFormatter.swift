//
//  PostfixFormatter.swift
//  Logger
//

import Foundation

public final class PostfixFormatter {
    // MARK: - Initialization

    public init() {}

    // MARK: - Functions

    private func postfix(by level: Level) -> String {
        switch level {
        case .verbose:
            return "\n🗯 [VERBOSE]\n"
        case .debug:
            return "\n📟 [DEBUG]\n"
        case .info:
            return "\nℹ️ [INFO]\n"
        case .notice:
            return "\n📙 [NOTICE]\n"
        case .warning:
            return "\n⚠️ [WARNING]\n"
        case .error:
            return "\n⛔️ [ERROR]\n"
        case .severe:
            return "\n🆘 [SEVERE]\n"
        case .alert:
            return "\n🚨 [ALERT]\n"
        case .emergency:
            return "🚑 [EMERGERENCY]\n"
        case .none:
            assertionFailure("This is an invalid log level")
            return ""
        }
    }
}

// MARK: - FormatterProtocol

extension PostfixFormatter: Formatter {
    public func format(details: inout LogDetails) {
        details.message += postfix(by: details.level)
    }
}

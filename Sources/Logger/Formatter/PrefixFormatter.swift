//
//  PrefixFormatter.swift
//  Logger
//

public final class PrefixFormatter {
    // MARK: - Initialization

    public init() {}

    // MARK: - Functions

    private func prefix(by level: Level) -> String {
        switch level {
        case .verbose:
            return "🗯 [VERBOSE]\n"
        case .debug:
            return "📟 [DEBUG]\n"
        case .info:
            return "ℹ️ [INFO]\n"
        case .notice:
            return "📙 [NOTICE]\n"
        case .warning:
            return "⚠️ [WARNING]\n"
        case .error:
            return "⛔️ [ERROR]\n"
        case .severe:
            return "🆘 [SEVERE]\n"
        case .alert:
            return "🚨 [ALERT]\n"
        case .emergency:
            return "🚑 [EMERGERENCY]\n"
        case .none:
            assertionFailure("This is an invalid log level")
            return ""
        }
    }
}

// MARK: - FormatterProtocol

extension PrefixFormatter: Formatter {
    public func format(details: inout LogDetails) {
        details.message = prefix(by: details.level) + details.message
    }
}

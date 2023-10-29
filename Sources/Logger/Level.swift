//
//  Level.swift
//  Logger
//

import Foundation

public enum Level: String, Comparable, Encodable {
    case verbose
    case debug
    case info
    case notice
    case warning
    case error
    case severe
    case alert
    case emergency
    case none

    // MARK: - Properties

    public var precedenceLevel: Int {
        switch self {
        case .verbose:
            return 0
        case .debug:
            return 1
        case .info:
            return 2
        case .notice:
            return 3
        case .warning:
            return 4
        case .error:
            return 5
        case .severe:
            return 6
        case .alert:
            return 7
        case .emergency:
            return 8
        case .none:
            return 9
        }
    }

    // MARK: - Comparable

    public static func < (lhs: Level, rhs: Level) -> Bool {
        return lhs.precedenceLevel < rhs.precedenceLevel
    }
}

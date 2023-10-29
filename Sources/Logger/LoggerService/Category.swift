//
//  Category.swift
//  Logger
//

public struct Category: ExpressibleByStringLiteral, Codable, Equatable, CustomStringConvertible {
    public let value: String

    public var description: String {
        return value
    }

    public init(stringLiteral value: String) {
        self.value = value
    }
}

extension Category {
    public static let `default` = Category(stringLiteral: "Default")
    public static let dev = Category(stringLiteral: "Dev")
}

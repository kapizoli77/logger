//
//  CategoryFormatter.swift
//  Logger
//

public final class CategoryFormatter {
    // MARK: - Initialization

    public init() {}
}

// MARK: - Formatter

extension CategoryFormatter: Formatter {
    public func format(details: inout LogDetails) {
        if let category = details.category {
            details.message = "[Category: \(category)] " + details.message
        }
    }
}

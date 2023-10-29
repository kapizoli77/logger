//
//  CategoryFilter.swift
//  Logger
//

import Foundation

public final class CategoryFilter {
    // MARK: - Properties

    private let category: Category

    // MARK: - Initialization

    public init(category: Category) {
        self.category = category
    }
}

// MARK: - FilterProtocol

extension CategoryFilter: Filter {
    public func shouldLog(details: LogDetails) -> Bool {
        return category != details.category
    }
}

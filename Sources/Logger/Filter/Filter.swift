//
//  Filter.swift
//  Logger
//

import Foundation

public protocol Filter: AnyObject {
    var name: String { get }

    func shouldLog(details: LogDetails) -> Bool
}

extension Filter {
    public var name: String {
        String(describing: Self.self)
    }
}

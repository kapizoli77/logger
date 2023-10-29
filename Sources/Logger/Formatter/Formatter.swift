//
//  Formatter.swift
//  Logger
//

import Foundation

public protocol Formatter: AnyObject {
    var name: String { get }

    func format(details: inout LogDetails)
}

extension Formatter {
    public var name: String {
        String(describing: Self.self)
    }
}

//
//  StringExtensions.swift
//  Logger
//

import Foundation

extension String.StringInterpolation {
    public enum PrivacyLevel {
       case `public`, `private`
    }

    public mutating func appendInterpolation<T: LosslessStringConvertible>(_ str: T, privacy: PrivacyLevel = .public) {
        if Log.isPrivateDataLogEnabled {
            appendLiteral(String(str))
        } else {
            switch privacy {
            case .private:
                appendLiteral("<private>")
            case .public:
                appendLiteral(String(str))
            }
        }
    }
}

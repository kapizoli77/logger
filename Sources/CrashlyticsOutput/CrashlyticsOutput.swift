//
//  CrashlyticsOutput.swift
//  
//
//  Created by Kapi Zoltán on 2023. 10. 29..
//

import Logger
import Firebase

// NOTE: If you don't want to lose any message, setup Firebase Crashlytics first and
// than add CrashlyticsOutput to you logger service

// Note: Do not forget to mark properties as private in the logged structure,
// becase it's not allowed to send personal data to a 3rd pary (GDPR)

public final class CrashlyticsOutput {

    // MARK: - Types

    public enum Mode {
        case onlyNonFatals(nonFatalFrom: Level)
        case nonFatalsWithLog(logFrom: Level, nonFatalFrom: Level)

        var nonFatalFrom: Level {
            switch self {
            case .onlyNonFatals(let nonFatalFrom):
                return nonFatalFrom
            case .nonFatalsWithLog(_, let nonFatalFrom):
                return nonFatalFrom
            }
        }
    }

    // MARK: Properties

    public var formatters = [Logger.Formatter]()
    public var filters = [Filter]()

    private let mode: Mode

    // MARK: Init

    public init(mode: Mode) {
        self.mode = mode
    }
}

// MARK: - Output

extension CrashlyticsOutput: Output {
    public func write(details: LogDetails, finalMessage: String) {

        // Log everything to Crashlytics
        if case .nonFatalsWithLog(let logFrom, _) = mode,
           details.level >= logFrom {
            Crashlytics.crashlytics().log(finalMessage)
        }

        guard details.level >= mode.nonFatalFrom else { return }

        // Log non-fatal issues

        let userInfo = [ "Log message": finalMessage ]
        let fileName = details.metaInfo.fileName.split(separator: "/").last?.description ?? details.metaInfo.fileName
        let errorDomain = [fileName,
                           details.metaInfo.functionName,
                           details.metaInfo.lineNumber.description]
            .joined(separator: " ")
        let error = NSError(domain: errorDomain, code: -1001, userInfo: userInfo)

        Crashlytics.crashlytics().record(error: error)
    }
}

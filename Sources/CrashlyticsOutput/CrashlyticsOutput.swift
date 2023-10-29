//
//  CrashlyticsOutput.swift
//  
//
//  Created by Kapi Zoltán on 2023. 10. 29..
//

import Logger
import Firebase

public final class CrashlyticsOutput {

    // MARK: Properties

    public var logLevel: Level
    public var formatters = [KMCommon.Formatter]()
    public var filters = [Filter]()

    // MARK: Init

    public init(logLevel: Level) {
        self.logLevel = logLevel
    }
}

// MARK: - Output

extension CrashlyticsOutput: Output {
    public func write(details: LogDetails, finalMessage: String) {

        // Log everything to Crashlytics
        // Note: Do not forget to mark properties as private in the logged structure,
        // Note: becase it's not allowed to send personal data to a 3rd pary (GDPR)

        Crashlytics.crashlytics().log(finalMessage)

        guard details.level >= .error else { return }

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

//
//  Log.swift
//  Logger
//

public struct Log {
    // MARK: - Properties

    public private(set) static var `default`: LoggerService = DefaultLoggerService(name: .default)

    private static var loggers: [LoggerService] = [`default`]
    public static var isPrivateDataLogEnabled = true

    // MARK: - Initialization

    private init() {}

    // MARK: - Manage services

    @discardableResult
    public static func registerDefaultService(withName name: LoggerServiceName) -> LoggerService {
        let newService = DefaultLoggerService(name: name)
        loggers.append(newService)
        return newService
    }

    @discardableResult
    public static func registerService(_ service: LoggerService) -> LoggerService {
        loggers.append(service)
        return service
    }

    @discardableResult
    public static func removeService(by name: LoggerServiceName) -> LoggerService? {
        guard `default`.name == name else {
            assertionFailure("Default logger service is not deletable! Please configure it instead!")
            return nil
        }

        guard let loggerService = loggerRegistration(by: name),
            let index = loggers.firstIndex(where: { $0.name == name }) else {
                assertionFailure("There is no registered logger service with name: \(name)")
                return nil
        }

        loggers.remove(at: index)

        return loggerService
    }

    // MARK: - Log methods

    public static func verbose(_ closure: @autoclosure @escaping () -> Any?,
                               category: Category? = nil,
                               loggerServiceName: LoggerServiceName = .default,
                               fileName: String = #file,
                               functionName: String = #function,
                               lineNumber: Int = #line) {
        log(closure,
            category: category,
            level: .verbose,
            loggerServiceName: loggerServiceName,
            fileName: fileName,
            functionName: functionName,
            lineNumber: lineNumber)
    }

    public static func debug(_ closure: @autoclosure @escaping () -> Any?,
                             category: Category? = nil,
                             loggerServiceName: LoggerServiceName = .default,
                             fileName: String = #file,
                             functionName: String = #function,
                             lineNumber: Int = #line) {
        log(closure,
            category: category,
            level: .debug,
            loggerServiceName: loggerServiceName,
            fileName: fileName,
            functionName: functionName,
            lineNumber: lineNumber)
    }

    public static func info(_ closure: @autoclosure @escaping () -> Any?,
                            category: Category? = nil,
                            loggerServiceName: LoggerServiceName = .default,
                            fileName: String = #file,
                            functionName: String = #function,
                            lineNumber: Int = #line) {
        log(closure,
            category: category,
            level: .info,
            loggerServiceName: loggerServiceName,
            fileName: fileName,
            functionName: functionName,
            lineNumber: lineNumber)
    }

    public static func notice(_ closure: @autoclosure @escaping () -> Any?,
                              category: Category? = nil,
                              loggerServiceName: LoggerServiceName = .default,
                              fileName: String = #file,
                              functionName: String = #function,
                              lineNumber: Int = #line) {
        log(closure,
            category: category,
            level: .notice,
            loggerServiceName: loggerServiceName,
            fileName: fileName,
            functionName: functionName,
            lineNumber: lineNumber)
    }

    public static func warning(_ closure: @autoclosure @escaping () -> Any?,
                               category: Category? = nil,
                               loggerServiceName: LoggerServiceName = .default,
                               fileName: String = #file,
                               functionName: String = #function,
                               lineNumber: Int = #line) {
        log(closure,
            category: category,
            level: .warning,
            loggerServiceName: loggerServiceName,
            fileName: fileName,
            functionName: functionName,
            lineNumber: lineNumber)
    }

    public static func error(_ closure: @autoclosure @escaping () -> Any?,
                             category: Category? = nil,
                             loggerServiceName: LoggerServiceName = .default,
                             fileName: String = #file,
                             functionName: String = #function,
                             lineNumber: Int = #line) {
        log(closure,
            category: category,
            level: .error,
            loggerServiceName: loggerServiceName,
            fileName: fileName,
            functionName: functionName,
            lineNumber: lineNumber)
    }

    public static func severe(_ closure: @autoclosure @escaping () -> Any?,
                              category: Category? = nil,
                              loggerServiceName: LoggerServiceName = .default,
                              fileName: String = #file,
                              functionName: String = #function,
                              lineNumber: Int = #line) {
        log(closure,
            category: category,
            level: .severe,
            loggerServiceName: loggerServiceName,
            fileName: fileName,
            functionName: functionName,
            lineNumber: lineNumber)
    }

    public static func alert(_ closure: @autoclosure @escaping () -> Any?,
                             category: Category? = nil,
                             loggerServiceName: LoggerServiceName = .default,
                             fileName: String = #file,
                             functionName: String = #function,
                             lineNumber: Int = #line) {
        log(closure,
            category: category,
            level: .alert,
            loggerServiceName: loggerServiceName,
            fileName: fileName,
            functionName: functionName,
            lineNumber: lineNumber)
    }

    public static func emergency(_ closure: @autoclosure @escaping () -> Any?,
                                 category: Category? = nil,
                                 loggerServiceName: LoggerServiceName = .default,
                                 fileName: String = #file,
                                 functionName: String = #function,
                                 lineNumber: Int = #line) {
        log(closure,
            category: category,
            level: .emergency,
            loggerServiceName: loggerServiceName,
            fileName: fileName,
            functionName: functionName,
            lineNumber: lineNumber)
    }

    public static func log(_ closure: @autoclosure @escaping () -> Any?,
                           category: Category? = nil,
                           level: Level,
                           loggerServiceName: LoggerServiceName = .default,
                           fileName: String = #file,
                           functionName: String = #function,
                           lineNumber: Int = #line) {
        guard let loggerService = loggerRegistration(by: loggerServiceName) else {
            assertionFailure("Not registered Logger Service with name: \(loggerServiceName)")
            return
        }

        loggerService.log(closure, category: category, level: level, fileName: fileName, functionName: functionName, lineNumber: lineNumber)
    }
}

// MARK: - Helpers

extension Log {
    private static func loggerRegistration(by name: LoggerServiceName) -> LoggerService? {
        return loggers.first(where: { $0.name == name })
    }
}

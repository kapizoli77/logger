//
//  Output.swift
//  Logger
//

public protocol Output: AnyObject {
    var name: String { get }
    var formatters: [Formatter] { get set }
    var filters: [Filter] { get set }

    func shouldLog(by level: Level) -> Bool
    func log(details: LogDetails)
    func write(details: LogDetails, finalMessage: String)
    func addFormatter(_ formatter: Formatter)
}

extension Output {
    public var name: String {
        String(describing: Self.self)
    }

    public func log(details: LogDetails) {
        // Apply Filters
        guard filters.allSatisfy( { $0.shouldLog(details: details) }) else { return }

        // Check log level criteria
        guard shouldLog(by: details.level) else { return }

        var logDetails = details
        // Apply Formatters
        formatters.forEach { $0.format(details: &logDetails) }

        // Send log String to the specific output
        write(details: logDetails, finalMessage: logDetails.message)
    }

    public func addFormatter(_ formatter: Formatter) {
        guard !formatters.contains(where: { $0.name == formatter.name }) else { return }

        formatters.append(formatter)
    }

    public func removeFormatter(_ formatter: Formatter) {
        filters.removeAll { $0.name == formatter.name }
    }

    public func addFilter(_ filter: Filter) {
        guard !filters.contains(where: { $0.name == filter.name }) else { return }

        filters.append(filter)
    }

    public func removeFilter(_ filter: Filter) {
        filters.removeAll { $0.name == filter.name }
    }
}

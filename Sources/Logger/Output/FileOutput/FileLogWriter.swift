//
//  FileLogWriter.swift
//  Logger
//

import Foundation

// NOTE: FileOutput can't be an actor because Output protocol has stored properties which can't be marked as nonisolated

extension Category {
    static let logToFile = Category(stringLiteral: "logToFile")
}

public actor FileLogWriter {
    // MARK: Settings

    public struct Settings {
        let folderName: String
        let fileNameDateFormat: String
        let fileExtension: String
        let dateFormat: String
        let entrySeparator: String
        let sessionSeparator: String
        let maxFileSize: UInt
        let fileSizeToOpen: UInt
        let maxFileCount: Int

        public static var `default` = Settings(folderName: "Log",
                                               fileNameDateFormat: "yyyy_MM_dd_HH_mm_ss",
                                               fileExtension: "log",
                                               dateFormat: "yyyy.MM.dd HH:mm:ss ZZZ",
                                               entrySeparator: "\n\n",
                                               sessionSeparator: "\nSession started -",
                                               maxFileSize: 1_048_576,
                                               fileSizeToOpen: 948_576,
                                               maxFileCount: 5)
    }

    // MARK: Private properties

    private let settings: Settings
    private let queue = FIFOQueue(priority: .background)
    private let fileManager = FileManager.default
    private var logFileHandle: FileHandle?
    private var currentFile: String?

    private var logDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(settings.folderName)
    }

    private var sortedLogFiles: [String] {
        guard var logFiles = try? fileManager.contentsOfDirectory(atPath: logDirectory.path) else {
            return []
        }

        logFiles = logFiles
            .filter { $0.hasSuffix(settings.fileExtension) }
            .map { "\(logDirectory.path)/\($0)" }

        return logFiles.sorted { file1, file2 in
            guard let date1 = try? fileManager.attributesOfItem(atPath: file1)[.creationDate] as? Date,
                  let date2 = try? fileManager.attributesOfItem(atPath: file2)[.creationDate] as? Date else {
                return false
            }
            return date1 < date2
        }
    }

    private var shouldCreateNewFile: Bool {
        guard let currentFile,
              let size = try? fileManager.attributesOfItem(atPath: currentFile)[.size] as? UInt,
              size < settings.maxFileSize else {
            return true
        }
        return false
    }

    // MARK: Init

    init(settings: Settings) {
        self.settings = settings

        queue.enqueue {
            do {
                try await self.createFolderIfNeeded()
                try await self.setupCurrentLogFile()
                await self.cleanupIfNeeded()
            } catch {
                Log.error(error.localizedDescription, category: .logToFile)
            }
        }
    }

    deinit {
        try? logFileHandle?.synchronize()
        try? logFileHandle?.close()
    }
}

// MARK: - Actions

extension FileLogWriter {
    nonisolated func appendToFile(_ message: String) {
        queue.enqueue {
            await self.appendLog(message, skipCheck: false)
        }
    }

    public nonisolated func getLogFiles() -> [String] {
        let fileManager = FileManager.default
        let logDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent(settings.folderName)
        guard var logFiles = try? fileManager.contentsOfDirectory(atPath: logDirectory.path) else {
            return []
        }

        logFiles = logFiles
            .filter { $0.hasSuffix(settings.fileExtension) }
            .map { "\(logDirectory.path)/\($0)" }

        return logFiles.sorted { file1, file2 in
            guard let date1 = try? fileManager.attributesOfItem(atPath: file1)[.creationDate] as? Date,
                  let date2 = try? fileManager.attributesOfItem(atPath: file2)[.creationDate] as? Date else {
                return false
            }
            return date1 < date2
        }
    }
}

// MARK: - Setups

extension FileLogWriter {
    private func createFolderIfNeeded() throws {
        if !fileManager.fileExists(atPath: logDirectory.path) {
            try FileManager.default.createDirectory(at: logDirectory,
                                                    withIntermediateDirectories: false,
                                                    attributes: nil)
        }
    }

    private func setupCurrentLogFile() throws {
        currentFile = try openFile(skipSearch: false)
    }

    private func openFile(skipSearch: Bool) throws -> String {
        if logFileHandle != nil { closeFile() }

        var fileUrl = skipSearch ? nil : selectLatestFile()
        if fileUrl == nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = settings.fileNameDateFormat
            let url = logDirectory.appendingPathComponent(dateFormatter.string(from: Date()))
                .appendingPathExtension(settings.fileExtension)

            fileManager.createFile(atPath: url.path, contents: nil)
            fileUrl = url
        }

        guard let fileUrl else { throw FileLogWriterError.fileCreation() }

        do {
            try logFileHandle = FileHandle(forWritingTo: fileUrl)
            if #available(iOS 13.4, *) {
                try logFileHandle?.seekToEnd()
            } else {
                logFileHandle?.seekToEndOfFile()
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = settings.dateFormat
            appendLog("\(settings.sessionSeparator) \(dateFormatter.string(from: Date()))\n", skipCheck: true)
        } catch let error as NSError {
            logFileHandle = nil
            throw FileLogWriterError.write(error)
        }
        return fileUrl.path
    }

    private func selectLatestFile() -> URL? {
        guard let latestFile = sortedLogFiles.last,
              let size = try? fileManager.attributesOfItem(atPath: latestFile)[.size] as? UInt,
              size < settings.fileSizeToOpen else {
            return nil
        }

        return URL(fileURLWithPath: latestFile)
    }

    private func cleanupIfNeeded() {
        let extraCount = sortedLogFiles.count - settings.maxFileCount - 1
        guard !sortedLogFiles.isEmpty, extraCount >= 0 else { return }
        for filePath in sortedLogFiles[0...extraCount] {
            do {
                try fileManager.removeItem(atPath: filePath)
            } catch {
                Log.error("Can't delete file at: \(filePath)", category: .logToFile)
            }
        }
    }

    private func closeFile() {
        guard let logFileHandle else { return }
        defer { self.logFileHandle = nil }

        do {
            try logFileHandle.synchronize()
            try logFileHandle.close()
        } catch {
            Log.error("Error while closing file: \(error)", category: .logToFile)
        }
    }

    private func appendLog(_ message: String, skipCheck: Bool) {
        if !skipCheck && shouldCreateNewFile {
            do {
                currentFile = try openFile(skipSearch: true)
                cleanupIfNeeded()
            } catch {
                return Log.error(error.localizedDescription, category: .logToFile)
            }
        }

        if let encodedData = "\(message)\(settings.entrySeparator)".data(using: String.Encoding.utf8) {
            if #available(iOS 13.4, *) {
                do {
                    try logFileHandle?.write(contentsOf: encodedData)
                } catch {
                    return Log.error("Can't append to file, error: \(error.localizedDescription)", category: .logToFile)
                }
            } else {
                logFileHandle?.write(encodedData)
            }
        }
    }
}

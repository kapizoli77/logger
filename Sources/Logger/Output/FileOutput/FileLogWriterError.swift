//
//  FileLogWriterError.swift
//  Logger
//

import Foundation

enum FileLogWriterError: Error {
    case folderCreation(Error)
    case fileCreation(Error? = nil)
    case write(Error)
}

extension FileLogWriterError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .folderCreation(let error):
            return "Can't create folder. Error: \(error)."
        case .fileCreation(let error):
            return "Can't create file. Error: \(String(describing: error))"
        case .write(let error):
            return "Can't write to file. Error: \(error)."
        }
    }
}

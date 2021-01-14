//
//  Logger.swift
//  LoggerApp
//
//  Created by Ahmed Nasser on 12/19/20.
//  Copyright © 2020 Instabug. All rights reserved.
//

import Foundation
import CoreData

enum LogLevel :String{
    case error = "Error"
    case verbose = "Verbose"
}

protocol LoggerProtocol {
    func didFetchLogs(logs:[String])
}

class Logger {
    static let shared = Logger()
    let operationQueue = OperationQueue()
    var delegate :LoggerProtocol?
    
    private init() {
        operationQueue.maxConcurrentOperationCount = 5
    }
    
    func log(message:String, errorLevel:LogLevel) {
        guard  !message.isEmpty else { return }
        let logMessage =  adjustLogMessage(message:message)
        performLog(message: logMessage, errorLevel: errorLevel)
    }
    
    private func performLog(message:String, errorLevel:LogLevel) {
        let cacheOperation = BlockOperation()
        cacheOperation.addExecutionBlock {
            LogsProvider.shared.saveLog(message: message, errorLevel:errorLevel.rawValue)
        }
        operationQueue.addOperation(cacheOperation)
    }
    
    func getLogs() {
        LogsProvider.shared.fetchLogs {[weak self] (logs) in
            guard let weakSelf = self else{return}
            weakSelf.delegate?.didFetchLogs(logs: logs.map{weakSelf.formatLogMessages(log: $0)})
        }
    }
    
    func reset() {
        LogsProvider.shared.resetLogs()
    }
    
    private func adjustLogMessage(message:String) -> String {
        if message.count < 1000 {
            return message
        }
        let message  = message.components(separatedBy: " ")
        return message[0..<1000].joined(separator: " ") + "..."
    }
    
    private func formatLogMessages(log:LogEntity) -> String {
        let level = getLogLevel(level: log.level)
        return "[\(log.date) - \(level) - \(log.message)]"
    }
    
    private func getLogLevel(level:String) -> String {
        let logLevel = LogLevel(rawValue: level)
        return logLevel?.rawValue ?? ""
    }
}

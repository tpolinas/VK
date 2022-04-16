//
//  AsyncOperation.swift
//  VK_GB_ClientServer
//
//  Created by Polina Tikhomirova on 14.04.2022.
//

import Foundation

class AsyncOperation: Operation {
    enum state: String {
        case ready, executing, finished
        var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
    var state = state.ready {
        willSet {
            willChangeValue(forKey: self.state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: self.state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }
    
    override var isAsynchronous: Bool {
        true
    }
    
    override var isReady: Bool {
        super.isReady &&
        self.state == .ready
    }
    
    override var isExecuting: Bool {
        self.state == .executing
    }
           
    override var isFinished: Bool {
        self.state == .finished
    }
    
    override func start() {
        if isCancelled {
            self.state = .finished
        } else {
            main()
            self.state = .executing
        }
    }
    
    override func cancel() {
        super.cancel()
        self.state = .finished
    }
}

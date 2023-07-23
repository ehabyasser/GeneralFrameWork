//
//  File.swift
//  
//
//  Created by Ihab yasser on 23/07/2023.
//

import Foundation

class AsyncOpration: Operation {
    // MARK: Properties

    // Set up some private variables to manage the asynchronous behavior
    private var _executing: Bool = false
    private var _finished: Bool = false

    // MARK: Overrides

    // As this is an asynchronous operation, we need to override isAsynchronous to return true
    override var isAsynchronous: Bool {
        return true
    }

    override var isExecuting: Bool {
        return _executing
    }

    override var isFinished: Bool {
        return _finished
    }

    // Override the start() method to initiate the asynchronous work
    override func start() {
        // Make sure the operation is not cancelled before starting
        guard !isCancelled else {
            finish()
            return
        }

        // Mark the operation as executing
        willChangeValue(forKey: "isExecuting")
        _executing = true
        didChangeValue(forKey: "isExecuting")

        // Start the asynchronous task
        performAsyncTask()
    }

    // Override the cancel() method to handle cancellation
    override func cancel() {
        super.cancel()

        // Call finish to ensure proper state management
        finish()
    }

    // MARK: Custom Asynchronous Task

    private func performAsyncTask() {
        // Perform your asynchronous task here, such as making an API call or fetching data
        // For the sake of example, we'll simulate a delay using DispatchQueue

        DispatchQueue.global().asyncAfter(deadline: .now()) { [weak self] in
            guard let self = self else { return }

            // Check if the operation is cancelled before proceeding with the result
            guard !self.isCancelled else {
                self.finish()
                return
            }

            // Simulate a successful result
            let result = "Async operation completed successfully."

            // Call the completion block on the main queue
            DispatchQueue.main.async {
                // Handle the result, update UI, or perform any necessary post-processing
                print(result)

                // Mark the operation as finished
                self.finish()
            }
        }
    }

    // Helper method to mark the operation as finished and executing as false
    private func finish() {
        // Mark the operation as finished
        willChangeValue(forKey: "isFinished")
        willChangeValue(forKey: "isExecuting")

        _executing = false
        _finished = true

        didChangeValue(forKey: "isExecuting")
        didChangeValue(forKey: "isFinished")
    }
}

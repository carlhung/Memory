//
//  ErrorLogInformation.swift
//  Memory
//
//  Created by Carl Hung on 29/08/2023.
//

struct ErrorLogInformation {
    var message: String?
    let function: StaticString
    let file: StaticString
    let fileID: StaticString
    let filePath: StaticString
    let line: Int
    init(
        message: String? = nil,
        function: StaticString = #function,
        file: StaticString = #file,
        fileID: StaticString = #fileID,
        filePath: StaticString = #filePath,
        line: Int = #line
    ) {
        self.message = message
        self.function = function
        self.file = file
        self.fileID = fileID
        self.filePath = filePath
        self.line = line
    }
}

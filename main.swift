//
//  main.swift
//  MyCompiler
//
//  Created by Cameron Monks on 5/9/19.
//  Copyright © 2019 Cameron Monks. All rights reserved.
//

import Foundation

var fileName : String?
var arguments: [String : String] = [:]

var i = 1
while i < CommandLine.arguments.count {
    
    let arg = CommandLine.arguments[i]
    
    if arg.hasPrefix("-") && i + 1 < CommandLine.arguments.count {
        
        arguments[arg] = CommandLine.arguments[i+1]
        
        i += 1
    } else {
        if fileName != nil {
            print("ERROR: TWO FILENAMES")
        }
        fileName = arg
    }

    i += 1
}

func compile(fileName: String, arguments: [String: String]) {
    
    let c = Compiler(fileName: fileName, arguments: arguments)
    c.debug()
    
    let outputFile = URL(fileURLWithPath: arguments["-out"] ?? "a.nasm")
    
    var outputCode = ""
    for l in c.compile() {
        outputCode += l + "\n"
    }
    
    do {
        try outputCode.write(to: outputFile, atomically: true, encoding: .ascii)
    } catch let e {
        print(e)
        print("ERROR WRITING TO FILE \(arguments["-out"] ?? "a.nasm")")
    }
    
}

if let f = fileName {
    
    //print("File Name: \(f)")
    //print("Arguments: \(arguments)")
    
    compile(fileName: f, arguments: arguments)
} else {
    
    print("file name not specified")
    print("Arguments: \(arguments)")
}


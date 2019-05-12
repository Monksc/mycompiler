//
//  Compiler.swift
//  MyCompiler
//
//  Created by Cameron Monks on 5/10/19.
//  Copyright © 2019 Cameron Monks. All rights reserved.
//

import Foundation

class Compiler {
    
    let fileName: String
    let arguments: [String: String]
    let code: String
    
    var fileCode: FileOfCode
    
    init(fileName: String, arguments: [String : String]) {
        self.fileName = fileName
        self.arguments = arguments
        
        do {
            let c = try String.init(contentsOfFile: fileName)
            code = c + "\n"
        } catch {
            code = ""
        }
        
        fileCode = FileOfCode(code: code)
    }
    
    
    func compile() -> [String] {
        
        var rArr : [String] = []
        
        rArr.append("global    _main")
        rArr.append("section   .text")
        
        for c in fileCode.classes {
            rArr.append(contentsOf: c.compile())
        }
        
        for f in fileCode.functions {
            rArr.append(contentsOf: f.compile(className: ""))
        }
        
        rArr.append("_main:");
        rArr.append("\tcall main")
        rArr.append("\tmov       rax, 0x02000001         ; system call for exit")
        rArr.append("\txor       rdi, rdi                ; exit code 0")
        rArr.append("\tsyscall")
        
        rArr.append("section   .data")
        
        return rArr
    }
    
    func debug() {
        print("FILENAME: \(fileName)")
        print("ARGUMENTS: \(arguments)")
        
        print("CODE DETAILS: \(fileCode.debug())")
        
        print("CODE: \(code)")
    }
}

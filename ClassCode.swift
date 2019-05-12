//
//  ClassCode.swift
//  MyCompiler
//
//  Created by Cameron Monks on 5/10/19.
//  Copyright © 2019 Cameron Monks. All rights reserved.
//

import Foundation

class ClassCode {
    
    private var name: String
    private var variables: [VariableCode] = []
    private var functions: [FunctionCode] = []
    
    init(code: String) {
        
        var index = 5
        while code[index] == " " {
            index += 1
        }
        
        let startIndex = index
        index += 1
        while code[index].isLetter {
            index += 1
        }
        
        name = String(code[startIndex..<index])
        
        while code[index] != "{" {
            index += 1
        }
        index += 1
        
        let innerCode = FileOfCode(code: String(code[index..<code.count-1]))
        variables.append(contentsOf: innerCode.variables)
        functions.append(contentsOf: innerCode.functions)
    }

    func compile() -> [String] {
        
        var rArr : [String] = []
        
        for f in functions {
            rArr.append(contentsOf: f.compile(className: name))
        }
        
        return rArr
    }
    
    func debug() {
        
        print("NAME: |\(name)|")
        print("VARIABLES:")
        for v in variables {
            v.debug()
        }
        print("FUNCTIONS:")
        for f in functions {
            f.debug()
        }
    }
}

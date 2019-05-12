//
//  MainBodyCode.swift
//  MyCompiler
//
//  Created by Cameron Monks on 5/10/19.
//  Copyright © 2019 Cameron Monks. All rights reserved.
//

import Foundation

enum CompilerState {
    case NEW_LINE, CLASS, FUNCTION
}

class FileOfCode {
    
    var variables: [VariableCode] = []
    var classes: [ClassCode] = []
    var functions: [FunctionCode] = []
    
    init(code: String) {

        let state = CompilerState.NEW_LINE
        
        var index = 0
        while true {
            
            // read to next non whitespace
            while index < code.count && code[index].isSpace() {
                index += 1
            }
            if index >= code.count {
                return
            }
            
            if code[index].isAlphaNumerical() {
                
                let startIndex = index
                while code[index].isAlphaNumerical() {
                    index += 1
                }
                
                let word = code[startIndex..<index]
                
                // is class or a function
                if word == "class" {
                    if state != .NEW_LINE {
                        print("ERROR: trying to read a class in \(state)")
                        return
                    }
                    
                    index = BodyOfCode.findCodeBracket(code: code, startIndex: index)
                    
                    let classCode = code[startIndex..<index]
                    let newClass = ClassCode.init(code: String(classCode))
                    classes.append(newClass)
                }
                else {
                    
                    if state != .NEW_LINE {
                        print("ERROR: trying to read a function in \(state)")
                        return
                    }
                    
                    index = BodyOfCode.findCodeBracket(code: code, startIndex: index)
                    
                    let functionCode = code[startIndex..<index]
                    let newFunction = FunctionCode.init(code: String(functionCode))
                    functions.append(newFunction)
                }
            } else {
                
                print("ERROR: WHAT IS \(code[index])")
                return
            }
            
        }
    }
    
    
    func debug() {
        
        for c in classes {
            c.debug()
        }
        
        for f in functions {
            f.debug()
        }
    }
    

}

//
//  FunctionCode.swift
//  MyCompiler
//
//  Created by Cameron Monks on 5/10/19.
//  Copyright © 2019 Cameron Monks. All rights reserved.
//

import Foundation

class FunctionCode {
    
    var name: String
    var params: [VariableCode] = []
    var variables: [VariableCode] = []
    
    var assemblyCode: [String] = []
    
    init(code: String) {
        
        var startIndex = 0
        while !code[startIndex].isAlphaNumerical() {
            startIndex += 1
        }
        
        var index = startIndex + 1
        while code[index].isAlphaNumerical() {
            index += 1
        }
        
        name = String(code[startIndex..<index])
        
        startIndex = index
        while code[startIndex] != "(" {
            startIndex += 1
        }
        
        index = startIndex + 1
        while code[index] != ")" {
            index += 1
        }
        
        let paramtersLine = code[startIndex+1..<index]
        print("PARAMETERS: for ", name, ":", paramtersLine)
        for param in paramtersLine.split(separator: ",") {
            let newVarCode = VariableCode(code: String(param))
            variables.append(newVarCode)
        }
        
        // Now develope assembly code
        startIndex = index + 1
        while code[startIndex] != "{" {
            startIndex += 1
        }
        startIndex += 1
        
        let bodyCode = code[startIndex..<code.count-1]
        print("BODY CHOCOLATE: \(bodyCode)")
        
        for line in bodyCode.split(separator: "\n") {
            startIndex = 0
            while startIndex < line.count && line[startIndex].isSpace() {
                startIndex += 1
            }
            if startIndex == line.count {
                continue
            }
            
            if line[startIndex] == "#" {
                if line[startIndex+1] == "." {
                    assemblyCode.append(String(line[startIndex+1..<line.count]))
                } else {
                    assemblyCode.append("\t" + String(line[startIndex+1..<line.count]))
                }
            } else if line[startIndex].isLetter {
                
                var index = startIndex+1
                while line[index].isAlphaNumerical() {
                    index += 1
                }
                
                let firstWord = String(line[startIndex..<index])
                
                startIndex = index
                while line[startIndex].isSpace() {
                    startIndex += 1
                }
                
                if line[startIndex] == "(" {
                    
                    index = startIndex + 1
                    while line[index] != ")" {
                        index += 1
                    }
                    
                    assemblyCode.append(contentsOf: BodyOfCode.callCode(functionName: firstWord, selfVar: nil, spaceBetweenParenthesis: String(line[startIndex+1..<index]), variables: variables, arguments: params))
                }
                else if line[startIndex].isAlphaNumerical() {
                    
                    let vc = VariableCode(code: String(line))
                    variables.append(vc)
                    
                    while line[startIndex] != "(" {
                        startIndex += 1
                    }
                    
                    index = startIndex + 1
                    while line[index] != ")" {
                        index += 1
                    }
                    
                    print(firstWord, "|\(line)|", startIndex, index, vc)
                    
                    assemblyCode.append(contentsOf: BodyOfCode.callCode(functionName: vc.getType() + vc.getType(), selfVar: vc.getName(), spaceBetweenParenthesis: String(line[startIndex+1..<index]), variables: variables, arguments: params))
                    
                }
                
            } else {
                print("ERROR: WHAT IS |\(line)| AT \(startIndex) |\(line[startIndex])|")
                return
            }
        }
        
    }
    
    func compile(className: String) -> [String] {
        
        var rArr : [String] = []
        
        rArr.append("\(className)\(name):")
        
        for v in variables {
            rArr.append("\tpush\t\t 0")
        }
        
        rArr.append(contentsOf: assemblyCode)
        
        for v in variables {
            rArr.append("\tpop\t\t  rax")
        }
        
        rArr.append("\tret")
        
        return rArr
    }
    
    func debug() {
        
        print("FUNCTION NAME: |\(name)|")
        print("PARAMS: \(params)")
        print("VARS: \(variables)")
        print("ASSEMBLY CODE: \(assemblyCode)")
    }
}

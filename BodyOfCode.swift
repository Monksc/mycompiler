//
//  BodyOfCode.swift
//  MyCompiler
//
//  Created by Cameron Monks on 5/10/19.
//  Copyright © 2019 Cameron Monks. All rights reserved.
//

import Foundation

class BodyOfCode {
    
    static func findCodeBracket(code: String, startIndex: Int) -> Int {
        
        var index = startIndex
        
        while code[index] != "{" {
            index += 1
        }
        index += 1
        
        var openBrackets = 1
        while openBrackets > 0 {
            if code[index] == "{" {
                openBrackets += 1
            }
            if code[index] == "}" {
                openBrackets -= 1
            }
            index += 1
        }
        
        return index
    }
 
    static func callCode(functionName: String, selfVar: String?, spaceBetweenParenthesis: String, variables: [VariableCode], arguments: [VariableCode]) -> [String] {
        
        func getRSPIndexOfVarIndex(index: Int, isArg: Bool) -> Int {
            if isArg {
                return 8 * (variables.count + 1 + index)
            }
            
            return index * 8
        }
        
        var assemblyCode: [String] = []
        
        var paramArray = spaceBetweenParenthesis.split(separator: ",")
        if let sVar = selfVar {
            if let v = variables.indexOf(whereValue: { (vc) -> Bool in
                vc.getName() == sVar
            }) {
                assemblyCode.append("\tmov\t\t  rax, rsp")
                assemblyCode.append("\tadd\t\t  rax, \(getRSPIndexOfVarIndex(index: v.index, isArg: false))")
                assemblyCode.append("\tpush\t\t rax")
            }
            else if let v = arguments.indexOf(whereValue: { (vc) -> Bool in
                vc.getName() == sVar
            }) {
                
                assemblyCode.append("\tmov\t\t  rax, rsp")
                assemblyCode.append("\tadd\t\t  rax, \(getRSPIndexOfVarIndex(index: v.index, isArg: true))")
                assemblyCode.append("\tpush\t\t rax")
            }
        }
        
        
        for param in paramArray {
            let p = param.trimmingCharacters(in: .whitespacesAndNewlines)
            if p.count > 0 {
                if let v = variables.indexOf(whereValue: { (vc) -> Bool in
                    vc.getName() == p
                }) {
                    assemblyCode.append("\tmov\t\t  rax,[rsp + \(getRSPIndexOfVarIndex(index: v.index, isArg: false))]")
                    assemblyCode.append("\tpush\t\t rax")
                }
                else if let v = arguments.indexOf(whereValue: { (vc) -> Bool in
                    vc.getName() == p
                }) {
                    
                    assemblyCode.append("\tmov\t\t  rax,[rsp + \(getRSPIndexOfVarIndex(index: v.index, isArg: true))]")
                    assemblyCode.append("\tpush\t\t rax")
                } else if let v = Int(p) {
                    
                    assemblyCode.append("\tpush\t\t \(v)")
                } else {
                    print("ERROR passing unknown param \(p)")
                    assemblyCode.append("\tpush\t\t \(p)")
                }
            }
        }
        assemblyCode.append("\tcall\t\t  \(functionName)")
        for param in paramArray.reversed() {
            let p = param.trimmingCharacters(in: .whitespacesAndNewlines)
            if p.count > 0 {
                if let v = variables.indexOf(whereValue: { (vc) -> Bool in
                    vc.getName() == p
                }) {
                    assemblyCode.append("\tpop\t\t  rax")
                }
                else if let v = arguments.indexOf(whereValue: { (vc) -> Bool in
                    vc.getName() == p
                }) {
                    assemblyCode.append("\tpop\t\t  rax")
                } else {
                    assemblyCode.append("\tpop\t\t  rax")
                }
                //assemblyCode.append("\tpush\t\t  \()")
            }
        }
        
        if selfVar != nil {
            assemblyCode.append("\tpop\t\t  rax")
        }
        
        
        return assemblyCode
    }
}

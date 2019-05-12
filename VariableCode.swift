//
//  VariableCode.swift
//  MyCompiler
//
//  Created by Cameron Monks on 5/10/19.
//  Copyright © 2019 Cameron Monks. All rights reserved.
//

import Foundation

class VariableCode: NSObject {
    
    private var name: String
    private var type: String

    init(code: String) {
        
        var startIndex = 0
        while !code[startIndex].isAlphaNumerical() {
            startIndex += 1
        }
        
        var index = startIndex + 1
        while code[index].isAlphaNumerical() {
            index += 1
        }
        
        type = String(code[startIndex..<index])
        
        startIndex = index + 1
        while !code[startIndex].isAlphaNumerical() {
            startIndex += 1
        }
        
        index = startIndex + 1
        while index < code.count && code[index].isAlphaNumerical() {
            index += 1
        }
        
        name = String(code[startIndex..<index])
    }
    
    func getName() -> String {
        return name
    }
    
    func getType() -> String {
        return type
    }
    
    public override var description: String { return "TYPE: |\(type)| NAME: |\(name)|" }
    
    func debug() {
        print(description)
    }
}

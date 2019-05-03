//
//  JavaExpVariables.swift
//  textToCode
//
//  Created by Michael Smith on 4/30/19.
//  Copyright © 2019 Michael Smith. All rights reserved.
//

import Foundation

//Variables in methods
class JavaExpVariables: JavaExpression{
    private var INDENT = "\t";
    private var name: String;
    private final var type: String;
    private var value: String?;
    
    init(name: String, type: String, value: String?) {
        self.name = name;
        self.type = type;
        self.value = value;
    }
    
    func getType() -> String{
        return self.type;
    }
    
    override func toString() -> String{
        if value == nil{
            return "\(INDENT)\(type) \(name);"
        }else{
            return "\(INDENT)\(type) \(name) = \(value ?? "you should never see this");"
        }
    }
}

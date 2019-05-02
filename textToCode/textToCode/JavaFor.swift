//
//  JavaFor.swift
//  textToCode
//
//  Created by Michael Smith on 4/30/19.
//  Copyright © 2019 Michael Smith. All rights reserved.
//

import Foundation

class JavaFor: JavaExpression{
    private var INDENT = "    ";
    private var startCondition: String;
    private var endCondition: String;
    private var iterator: String;
    var expressions: [JavaExpression] = [];
    
    init(sCondition: String, eCondition: String, iterator: String){
        self.startCondition = sCondition;
        self.endCondition = eCondition;
        self.iterator = iterator;
    }
    
    override func addExpression(exp: JavaExpression){
        expressions.append(exp);
    }
    
    override func toString() -> String{
        var outputString = "";
        outputString += "for(\(self.startCondition); \(self.endCondition); \(self.iterator)){ \n"
        for expression in expressions{
            outputString += INDENT;
            outputString += expression.toString();
            outputString += "\n"
        }
        outputString += "} \n"
        return outputString;
    }
}

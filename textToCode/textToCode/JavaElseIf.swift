//
//  JavaElseIf.swift
//  textToCode
//
//  Created by Michael Smith on 5/2/19.
//  Copyright © 2019 Michael Smith. All rights reserved.
//

import Foundation

class JavaElseIf: JavaExpression{
    private var INDENT = "    ";
    private var condition: String;
    private var expressions: [JavaExpression] = [];

    
    init(condition: String) {
        self.condition = condition;
    }
    
    override func addExpression(exp: JavaExpression){
        expressions.append(exp);
    }
    
    override func toString() -> String{
        var outputString = "";
        outputString += "else if(\(self.condition)){ \n"
        for expression in expressions{
            outputString += INDENT;
            outputString += expression.toString();
        }
        outputString += "} \n"
        return outputString;
    }
    
}

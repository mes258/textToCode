//
//  JavaElse.swift
//  textToCode
//
//  Created by Michael Smith on 5/2/19.
//  Copyright © 2019 Michael Smith. All rights reserved.
//

import Foundation

class JavaElse: JavaExpression{
    private var INDENT = "    ";
    private var expressions: [JavaExpression] = [];
    
    
    override init() {
    }
    
    override func addExpression(exp: JavaExpression){
        expressions.append(exp);
    }
    
    override func toString() -> String{
        var outputString = "";
        outputString += "else { \n"
        for expression in expressions{
            outputString += INDENT;
            outputString += expression.toString();
        }
        outputString += "} \n"
        return outputString;
    }
}

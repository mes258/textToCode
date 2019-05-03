//
//  JavaElseIf.swift
//  textToCode
//
//  Created by Michael Smith on 5/2/19.
//  Copyright © 2019 Michael Smith. All rights reserved.
//

import Foundation

class JavaElseIf: JavaExpression{
    private var INDENT = "\t";
    private var condition: String;
    private var expressions: [JavaExpression] = [];

    
    init(condition: String) {
        self.condition = condition;
    }
    
    func getExpressions()-> [JavaExpression]{
        return self.expressions;
    }
    

    override func addExpression(exp: JavaExpression){
        expressions.append(exp);
    }
    
    override func toString() -> String{
        var outputString = "";
        outputString += "\(INDENT)else if(\(self.condition)){ \n"
        for expression in expressions{
            outputString += INDENT + INDENT;
            outputString += expression.toString();
            outputString += "\n";
        }
        outputString += INDENT;
        outputString += "} \n"
        return outputString;
    }
    
    override func copy() -> JavaElseIf {
        let ifElseCopy = JavaElseIf.init(condition: self.condition)
        for expression in self.getExpressions(){
            ifElseCopy.addExpression(exp: expression.copy());
        }
        return ifElseCopy;
    }
    
}

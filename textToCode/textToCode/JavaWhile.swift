//
//  JavaWhile.swift
//  textToCode
//
//  Created by Michael Smith on 4/30/19.
//  Copyright © 2019 Michael Smith. All rights reserved.
//

import Foundation

class JavaWhile: JavaExpression{
    private var INDENT = "\t";
    private var condition: String;
    var expressions: [JavaExpression] = [];
    
    init(condition: String){
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
        outputString += "\(INDENT)while(\(self.condition)){ \n"
        for expression in expressions{
            outputString += INDENT + INDENT;
            outputString += expression.toString();
            outputString += "\n"
        }
        outputString += INDENT + INDENT;
        outputString += "} \n"
        return outputString;
    }
    
    override func copy() -> JavaWhile {
        let whileCopy = JavaWhile.init(condition: self.condition);
        for expression in self.getExpressions(){
            whileCopy.addExpression(exp: expression.copy());
        }
        return whileCopy;
    }
}

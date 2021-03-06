//
//  JavaElse.swift
//  textToCode
//
//  Created by Michael Smith on 5/2/19.
//  Copyright © 2019 Michael Smith. All rights reserved.
//

import Foundation

class JavaElse: JavaExpression{
    private var INDENT = "\t";
    private var expressions: [JavaExpression] = [];
    
    
    override init() {
    }
    
    func getExpressions()-> [JavaExpression]{
        return self.expressions;
    }
    
    override func addExpression(exp: JavaExpression){
        expressions.append(exp);
    }
    
    override func toString() -> String{
        var outputString = "";
        outputString += "\(INDENT)else { \n"
        for expression in expressions{
            outputString += INDENT + INDENT;
            outputString += expression.toString();
            outputString += "\n"
        }
        outputString += INDENT;
        outputString += "} \n"
        return outputString;
    }
    
    override func copy() -> JavaElse {
        let elseCopy = JavaElse.init();
        for expression in self.getExpressions(){
            elseCopy.addExpression(exp: expression.copy());
        }
        return elseCopy;
    }
}

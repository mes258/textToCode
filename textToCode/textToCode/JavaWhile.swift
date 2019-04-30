//
//  JavaWhile.swift
//  textToCode
//
//  Created by Michael Smith on 4/30/19.
//  Copyright © 2019 Michael Smith. All rights reserved.
//

import Foundation

class JavaWhile: JavaExpressions{
    private var INDENT = "    ";
    private var condition: String;
    var expressions: [JavaExpressions] = [];
    
    init(condition: String){
        self.condition = condition;
    }
    
    func toString() -> String{
        var outputString = "";
        outputString += "while(\(self.condition)){ \n"
        for expression in expressions{
            outputString += INDENT;
            outputString += expression.toString();
        }
        return outputString;
    }
}

//
//  JavaReturn.swift
//  textToCode
//
//  Created by Michael Smith on 4/30/19.
//  Copyright © 2019 Michael Smith. All rights reserved.
//

import Foundation

class JavaReturn: JavaExpression{
    private var INDENT = "    ";
    var returnValue: String
    
    init(returnString: String){
        self.returnValue = returnString;
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

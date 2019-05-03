//
//  JavaPrint.swift
//  textToCode
//
//  Created by Michael Smith on 5/2/19.
//  Copyright © 2019 Michael Smith. All rights reserved.
//

import Foundation

class JavaPrint: JavaExpression{
    private var INDENT = "\t";
    var printStatement: String
    
    init(printStmt: String){
        self.printStatement = printStmt;
    }
    
    override func toString() -> String{
        return "\(INDENT)System.out.println(\(self.printStatement));\n"
    }
}

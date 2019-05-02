//
//  JavaPrint.swift
//  textToCode
//
//  Created by Michael Smith on 5/2/19.
//  Copyright © 2019 Michael Smith. All rights reserved.
//

import Foundation

class JavaPrint: JavaExpression{
    private var INDENT = "    ";
    var printStatement: String
    
    init(printStmt: String){
        self.printStatement = printStmt;
    }
    
    override func toString() -> String{
        return "    System.out.println(\(self.printStatement));\n"
    }
}

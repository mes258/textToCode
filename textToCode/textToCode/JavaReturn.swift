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
    
    override func toString() -> String{
        return "return \(self.returnValue)\n"
    }
}

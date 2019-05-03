//
//  JavaReturn.swift
//  textToCode
//
//  Created by Michael Smith on 4/30/19.
//  Copyright © 2019 Michael Smith. All rights reserved.
//

import Foundation

class JavaReturn: JavaExpression{
    private var INDENT = "\t";
    var returnValue: String
    
    init(returnString: String){
        self.returnValue = returnString;
    }
    
    func getReturnValue()-> String{
        return self.returnValue;
    }
    
    override func toString() -> String{
        return "\(INDENT)return \(self.returnValue);\n"
    }
    
    override func copy() -> JavaReturn {
        let returnCopy = JavaReturn.init(returnString: self.getReturnValue());
        return returnCopy;
    }
}

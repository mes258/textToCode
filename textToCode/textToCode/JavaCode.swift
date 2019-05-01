//
//  JavaCode.swift
//  textToCode
//
//  Created by Michael Smith on 5/1/19.
//  Copyright © 2019 Michael Smith. All rights reserved.
//

import Foundation

class JavaCode: JavaExpression{
    private var exp: String;
    
    init(exp: String) {
        self.exp = exp;
    }
    
    override func toString() -> String{
        return "    \(self.exp)";
    }
    
    
}

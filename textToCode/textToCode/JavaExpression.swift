//
//  JavaExpression.swift
//  textToCode
//
//  Created by Michael Smith on 4/26/19.
//  Copyright © 2019 Michael Smith. All rights reserved.
//
//  Abstract parent class for control flow, variables, loops, everything else really
//

import Foundation

class JavaExpression{
    
    init() {
        
    }
    
    func addExpression(exp: JavaExpression){
        
    }
    
    func toString() -> String{
        return "";
    }
    
    func copy() -> JavaExpression{
        return JavaExpression.init();
    }
}

//
//  JavaExpressions.swift
//  textToCode
//
//  Created by Michael Smith on 4/26/19.
//  Copyright © 2019 Michael Smith. All rights reserved.
//

import Foundation

class JavaExpressions{
    //Control flow, variables, loops, everything else really
    //use a set to keep track of key words (declared names in scope)
    
    var expressions: [JavaExpressions] = [];
    
    init() {
        
    }
    
    func addVariable(varName: String, vis: String, type: String){
        expressions.append(JavaExpVariables.init(name: varName, vis: vis, type: type));
    }
    
}

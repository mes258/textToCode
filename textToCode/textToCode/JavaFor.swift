//
//  JavaFor.swift
//  textToCode
//
//  Created by Michael Smith on 4/30/19.
//  Copyright © 2019 Michael Smith. All rights reserved.
//

import Foundation

class JavaFor: JavaExpressions{
    private var startCondition: String;
    private var endCondition: String;
    private var iterator: String;
    var expressionList: [JavaExpressions] = [];
    
    init(sCondition: String, eCondition: String, iterator: String){
        self.startCondition = sCondition;
        self.endCondition = eCondition;
        self.iterator = iterator;
    }
    
    func toString() -> String{
        var currentString = "for(";
        currentString.append(self.startCondition);
        return currentString;
    }
    
}

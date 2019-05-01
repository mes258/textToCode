//
//  JavaMethod.swift
//  textToCode
//
//  Created by Michael Smith on 4/21/19.
//  Copyright © 2019 Michael Smith. All rights reserved.
//

import Foundation

class JavaMethod{
    private var INDENT = "    ";
    private var name: String;
    private var visability: ItemVisability;
    private var returnType: String;
    private var expressions: [JavaExpression] = [];
    private var inStructure = false;
    
    //Need to account for parameters
    init(name: String, vis: String, returnType: String) {
        self.name = name;
        self.visability = ItemVisability(rawValue: vis) ?? ItemVisability.defaultItem;
        self.returnType = returnType;
    }
    
    func exitExpression(){
        inStructure = false;
    }
    
    func getVariables()->[JavaExpVariables]{
        var currentVars: [JavaExpVariables] = [];
        for exp in expressions{
            if let isVar = exp as? JavaExpVariables{
                currentVars.append(exp as! JavaExpVariables);
            }
        }
        return currentVars;
    }
    
    func addExpression(exp: JavaExpression){
        if(inStructure){
            expressions[expressions.count - 1].addExpression(exp: exp);
        }else{
            expressions.append(exp);
            inStructure = true;
        }
    }
    
    func toString() -> String{
        var outputStr: String = "";
        outputStr += "\(visability.rawValue) \(returnType) \(name)(){ \n"
        for expression in expressions{
            outputStr += INDENT;
            outputStr += "\(expression.toString()) \n";
        }
        outputStr += "}";
        
        print(outputStr);
        return outputStr;
    }
    
    func getName() -> String{
        return name
    }
    
    func getExpression()-> [JavaExpression]{
        return expressions;
    }
}

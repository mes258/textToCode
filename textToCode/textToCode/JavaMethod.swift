//
//  JavaMethod.swift
//  textToCode
//
//  Created by Michael Smith on 4/21/19.
//  Copyright © 2019 Michael Smith. All rights reserved.
//

import Foundation
import UIKit

class JavaMethod{
    private var INDENT = "    ";
    private var name: String;
    private var visability: ItemVisability;
    private var returnType: String;
    var expressions: [JavaExpression] = [];
    private var inStructure = false;
    
    init(name: String, vis: String, returnType: String) {
        self.name = name;
        self.visability = ItemVisability(rawValue: vis) ?? ItemVisability.defaultItem;
        self.returnType = returnType.uppercasingFirst;
    }
    
    func exitExpression(){
        inStructure = false;
    }
    
    func getVariables()->[JavaExpVariables]{
        var currentVars: [JavaExpVariables] = [];
        for exp in expressions{
            if exp is JavaExpVariables{
                currentVars.append(exp as! JavaExpVariables);
            }
        }
        return currentVars;
    }
    
    func addExpression(exp: JavaExpression){
        if(inStructure){
            expressions[expressions.count - 1].addExpression(exp: exp);
        }else{
            if(exp is JavaExpVariables || exp is JavaPrint || exp is JavaCode || exp is JavaComment){
                expressions.append(exp);
            }else{
                expressions.append(exp);
                inStructure = true;
            }
        }
    }
    
    func toFormattedString() -> NSMutableAttributedString{
        var output = NSMutableAttributedString()
        output = NSMutableAttributedString(string: self.toString());
        
        if let xmethod = SpeechProcessor.state.currentMethod{
            if xmethod.name == self.name{
            
                output.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.7, green: 0.0, blue: 1.0, alpha: 1.0)] as [NSAttributedString.Key: Any], range: NSRange(location: 0, length: self.toString().count));
            }
        }
        return output
        
    }
    
    func copy() -> JavaMethod{
        let copy = JavaMethod(name: name, vis: visability.rawValue, returnType: returnType)
        for expression in expressions{
            copy.expressions.append(expression.copy())
        }
        copy.inStructure = inStructure
        return copy
    }
    
    func toString() -> String{
        var outputStr: String = "";
        outputStr += "    \(visability.rawValue) \(returnType) \(name)(){ \n"
        for expression in expressions{
            outputStr += INDENT;
            outputStr += "\(expression.toString()) \n";
        }
        outputStr += "    } \n";
    
        return outputStr;
    }
    
    func getName() -> String{
        return name
    }
    
    func getExpression()-> [JavaExpression]{
        return expressions;
    }
}

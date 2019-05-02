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
            if(exp is JavaExpVariables || exp is JavaPrint || exp is JavaCode){
                expressions.append(exp);
            }else{
                expressions.append(exp);
                inStructure = true;
            }
        }
    }
    
    func toFormattedString() -> NSMutableAttributedString{
       // var outputString = NSMutableAttributedString(string: "\(visability.rawValue) \(returnType) \(name)(){ \n", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)] as [NSAttributedString.Key: Any]);
        var outputStr: String = "";
        outputStr += "\(visability.rawValue) \(returnType) \(name)(){ \n"
        for expression in expressions{
            outputStr += INDENT;
            outputStr += "\(expression.toString()) \n";
        }
        outputStr += "}";
        
        let outputString = NSMutableAttributedString(string: outputStr, attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)] as [NSAttributedString.Key: Any]);
        return outputString;
    }
    
    func toString() -> NSMutableAttributedString{
        if(SpeechProcessor.state.currentMethod?.getName() == self.getName()){
            return toFormattedString();
        }
        var outputStr: String = "";
        outputStr += "\(visability.rawValue) \(returnType) \(name)(){ \n"
        for expression in expressions{
            outputStr += INDENT;
            outputStr += "\(expression.toString()) \n";
        }
        outputStr += "}";
        
        let formattedOutput = NSMutableAttributedString(string: outputStr);
        return formattedOutput;
    }
    
    func getName() -> String{
        return name
    }
    
    func getExpression()-> [JavaExpression]{
        return expressions;
    }
}

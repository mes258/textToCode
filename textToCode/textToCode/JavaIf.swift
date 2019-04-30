//
//  JavaIf.swift
//  textToCode
//
//  Created by Michael Smith on 4/30/19.
//  Copyright © 2019 Michael Smith. All rights reserved.
//

import Foundation

class JavaIf: JavaExpression{
    private var INDENT = "    ";
    private var ifCondition: String;
    private var elseIfConditions: [String] = [];
    private var ifExpressions: [JavaExpression] = [];
    private var elseIfExpressions: [[JavaExpression]] = [[]];
    private var elseExpressions: [JavaExpression] = [];
    private var currentScope = "if";
    private var currentElseIf = -1;

    init(condition: String){
        self.ifCondition = condition;
    }
    
    func addElseIf(condition: String){
        elseIfConditions.append(condition);
        currentScope = "elseif";
        currentElseIf += 1;
    }
    
    func addElse(){
        currentScope = "else"
    }
    
    override func addExpression(exp: JavaExpression){
        switch currentScope {
        case "if":
            ifExpressions.append(exp);
        case "elseif":
            elseIfExpressions[currentElseIf].append(exp);
        case "else":
            elseExpressions.append(exp);
        default:
            ifExpressions.append(exp);
        }
    }

    override func toString() -> String{
        var outputString = "";
        outputString += "if(\(self.ifCondition)){ \n"
        for expression in ifExpressions{
            outputString += INDENT;
            outputString += expression.toString();
        }
        outputString += "} \n"
        
        for condit in elseIfConditions{
            outputString += "else if(\(condit)){ \n"
            for expression in elseIfExpressions[elseIfConditions.firstIndex(of: condit)!]{
                outputString += INDENT;
                outputString += expression.toString();
            }
            outputString += "} \n"
        }
        outputString += "else{ \n"
        
        for expression in elseExpressions{
            outputString += INDENT;
            outputString += expression.toString();
        }
        outputString += "} \n"
        
        return outputString;
    }
}

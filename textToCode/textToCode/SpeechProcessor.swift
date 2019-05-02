//
//  SpeechProcesser.swift
//  textToCode
//
//  Created by Michael Smith on 4/30/19.
//  Copyright © 2019 Michael Smith. All rights reserved.
//

import Foundation

class SpeechProcessor {
    
    static var state: JavaState = JavaState.init();
    static func processInput(result: String) -> String{
    
        
        let lowerCaseResult: String = result.lowercased();
        var resultArr1 = lowerCaseResult.components(separatedBy: " ");
        print(resultArr1);

        var resultArr = resultArr1.prefix(resultArr1.count - 1);
        
        print(resultArr);
        
        /* SCRIPT::
         big test phrase:
         
         
         new private class dog stop
             new private method hello returns string stop
                return hello how are you stop
             new public method count legs returns integer stop
                new private variable integer i equals seven stop
                while i is less than 4 stop
                    i plus plus stop
                    print i stop
                if i equals 4 stop
                    i equals two stop
                    print i stop
                else if i equals 5 stop
                    i minus minus stop
                    print i stop
                else
                    print i stop
                    return i plus 5 stop
         
         
         
         
         //Other test phrases:
         
         new public variable boolean bye stop
         new private method good bye returns integer stop
         while bye equals true stop
            return bye stop
         new public variable string hi there equals seven stop
         
         if bye equals true stop
            bye equals false stop
         else stop
            bye equals true stop
 
         */
        for wordIndex in 0..<resultArr.count{
            
            //NEW CLASS: eg: "new private class dog stop "
            if(resultArr[wordIndex] ~= "new" && resultArr[wordIndex + 2].first ~= "c"){
                print("In new class");
                state.addClass(newClass: JavaClass.init(className: wordListToCamelCase(Array(resultArr[wordIndex + 3..<resultArr.count])).uppercasingFirst, vis: resultArr[wordIndex + 1]));
                
                var tempArray = ["newVar", "equals", "true"];
                scanPhrase(inputPhrase: tempArray, isCondition: false);
                scanPhrase(inputPhrase: tempArray, isCondition: true);
                tempArray = ["secondVar", "plus", "plus"];
                scanPhrase(inputPhrase: tempArray, isCondition: false);
                scanPhrase(inputPhrase: tempArray, isCondition: true);
                tempArray = ["secondVar", "equals", "seven", "and", "thridVar", "divide", "three", "equals", "four"];
                scanPhrase(inputPhrase: tempArray, isCondition: false);
                scanPhrase(inputPhrase: tempArray, isCondition: true);
            }
            
            //NEW METHOD: eg: "new public method kick returns boolean stop"
            if(resultArr[wordIndex] ~= "new" && resultArr[wordIndex + 2].first ~= "m"){
                print("In new method");
                state.currentClass?.addMethod(methodName: wordListToCamelCase(Array(resultArr[wordIndex + 3..<resultArr.count - 2])).uppercasingFirst, vis: resultArr[wordIndex + 1], returnType: resultArr[resultArr.count - 1]);
                state.currentMethod = state.currentClass?.methods[(state.currentClass?.methods.count)! - 1];
                break;
            }
            
           //NEW VAR: eg: "new private variable String leg stop"
            if(resultArr[wordIndex] ~= "new" && resultArr[wordIndex + 2].first ~= "v"){
                if state.currentMethod == nil{
                    //NEW CLASS VAR: eg: "new private variable String leg"
                    print("In new class var");
                    state.currentClass?.addVar(varName: wordListToCamelCase(Array(resultArr[wordIndex + 4..<resultArr.count])), vis: resultArr[wordIndex + 1], type: resultArr[wordIndex + 3]);
                }else{
                    if(resultArr.contains("equals")){
                        //NEW METHOD VAR: eg: "new private variable int size equals seven"
                        print("in new method var");
                        let newVar: JavaExpVariables = JavaExpVariables.init(name: wordListToCamelCase(Array(resultArr[wordIndex + 4..<resultArr.count - 2])), vis: resultArr[wordIndex + 1], type: resultArr[wordIndex + 3], value: resultArr[resultArr.count - 1]);
                        state.currentMethod?.addExpression(exp: newVar);
                    }else{
                        //NEW CLASS VAR: eg: "new private variable String leg"
                        print("In new class var");
                        let newVar: JavaExpVariables = JavaExpVariables.init(name: wordListToCamelCase(Array(resultArr[wordIndex + 4..<resultArr.count])), vis: resultArr[wordIndex + 1], type: resultArr[wordIndex + 3], value: nil);
                        state.currentMethod?.addExpression(exp: newVar);
                    }
                }
                break;
            }
            
            //while bye equals true stop
            //WHILE: eg: while bye equals true stop
            if(resultArr[wordIndex] ~= "while"){
                print("In new while");
                let condition: String = scanPhrase(inputPhrase: Array(resultArr[wordIndex + 1..<resultArr.count]), isCondition: true).joined(separator: " ");
                let newWhile: JavaWhile = JavaWhile.init(condition: condition)
                
                state.currentMethod?.addExpression(exp: newWhile)
                break;
            }
            
            //return bye stop
            //RETURN: eg: return bye stop
            if(resultArr[wordIndex] ~= "return"){
                let returnVal: String = scanPhrase(inputPhrase: Array(resultArr[wordIndex + 1..<resultArr.count]), isCondition: true).joined(separator: " ");
                let newReturn: JavaReturn = JavaReturn.init(returnString: returnVal);
                state.currentMethod?.addExpression(exp: newReturn);
                break;
            }
            
//            if bye equals true stop
//            bye equals false stop
//            else stop
//            bye equals true stop
            
            //IF: eg: see above^
            
            if(resultArr[wordIndex] ~= "if"){
                let condition: String = scanPhrase(inputPhrase: Array(resultArr[wordIndex + 1..<resultArr.count]), isCondition: true).joined(separator: " ");
                let newIf: JavaIf = JavaIf.init(condition: condition);
                state.currentMethod?.addExpression(exp: newIf);
                break;
            }
            
            //else
            if(resultArr[wordIndex] ~= "else" && resultArr.count == 1){
//                let condition: String = Array(resultArr[wordIndex + 1..<resultArr.count]).joined(separator: " ");
                let newElse: JavaElse = JavaElse.init();
                state.currentMethod?.addExpression(exp: newElse);
                break;
            }
            
            //ELSE IF:
            if(resultArr[wordIndex] ~= "else" && resultArr[wordIndex + 1] ~= "if"){
                let condition: String = scanPhrase(inputPhrase: Array(resultArr[wordIndex + 1..<resultArr.count]), isCondition: true).joined(separator: " ");
                let newElseIf: JavaElseIf = JavaElseIf.init(condition: condition);
                state.currentMethod?.addExpression(exp: newElseIf);
                break;
            }
            
            else{
                let line: String = scanPhrase(inputPhrase: Array(resultArr[wordIndex + 1..<resultArr.count]), isCondition: false).joined(separator: " ");
                let lineOfCode: JavaCode = JavaCode.init(exp: line)
                state.currentMethod?.addExpression(exp: lineOfCode);
            }
            
        }
        
        return state.toString();
        
    }
    
    static func wordListToCamelCase(_ words: [String]) -> String{
        return words.joined(separator: " ").camelized
    }
    
    
    static let specialWords = ["equals": "=",
                               "booleanEquals": "=",
                               "plus": "+",
                               "minus": "-",
                               "divide": "/",
                               "open parenthesis": "(",
                               "close parenthiesis": ")",
                               "and": "&&",
                               "or": "||",
                               "one": "1",
                               "two": "2",
                               "three": "3",
                               "four": "4",
                               "five": "5",
                               "six": "6",
                               "seven": "7",
                               "eight": "8",
                               "nine": "9",
                               "ten": "10",
                               
                               ]

    static func scanPhrase(inputPhrase: [String], isCondition: Bool) -> [String]{
        print("IN SCAN");
        print(inputPhrase);
        var phrase = inputPhrase;
        for var i in 0..<phrase.count{
            if(phrase[i] == "equals" && isCondition){
                phrase[i] = "==";
            }else{
                let hasVal = specialWords[phrase[i]] != nil
                if(hasVal){
                    phrase[i] = specialWords[phrase[i]]!;
                }
            }

        }
        print(phrase);
        return phrase;
    }
    
    //input like: new class fish; new private class head shoulders knees toes
    //TODO: make this? or don't? idk
    static func stringsToClass(_ : [String]) -> JavaClass {
        return JavaClass(className: "", vis: "public")
    }
}

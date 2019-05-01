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
         new private class dog stop
         new private method hello returns string stop
         return bye stop
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
                break;
            }
            
            //NEW METHOD: eg: "new public method kick returns boolean stop"
            if(resultArr[wordIndex] ~= "new" && resultArr[wordIndex + 2].first ~= "m"){
                print("In new method");
                state.currentClass?.addMethod(methodName: wordListToCamelCase(Array(resultArr[wordIndex + 3..<resultArr.count - 2])).uppercasingFirst, vis: resultArr[wordIndex + 1], returnType: resultArr[wordIndex + 5]);
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
                let condition: String = Array(resultArr[wordIndex + 1..<resultArr.count]).joined(separator: " ");
                let newWhile: JavaWhile = JavaWhile.init(condition: condition)
                
                state.currentMethod?.addExpression(exp: newWhile)
                break;
            }
            
            //return bye stop
            //RETURN: eg: return bye stop
            if(resultArr[wordIndex] ~= "return"){
                let returnVal: String = Array(resultArr[wordIndex + 1..<resultArr.count]).joined(separator: " ");
                let newReturn: JavaReturn = JavaReturn.init(returnString: returnVal);
                state.currentMethod?.addExpression(exp: newReturn);
                break;
            }
            
//            if bye equals true stop
//            bye equals false stop
//            else stop
//            bye equals true stop
            
            //IF: eg: see above^
            var newIf: JavaIf = JavaIf.init(condition: "");
            if(resultArr[wordIndex] ~= "if"){
                let condition: String = Array(resultArr[wordIndex + 1..<resultArr.count]).joined(separator: " ");
                newIf = JavaIf.init(condition: condition);
                state.currentMethod?.addExpression(exp: newIf);
                break;
            }
            
            if(resultArr[wordIndex] ~= "else" && resultArr.count == 1){
//                let condition: String = Array(resultArr[wordIndex + 1..<resultArr.count]).joined(separator: " ");
                newIf.addElse();
                //state.currentMethod?.addExpression(exp: newIf);
                break;
            }
            
            //ELSE IF:
            if(resultArr[wordIndex] ~= "else" && resultArr[wordIndex + 1] ~= "if"){
                let condition: String = Array(resultArr[wordIndex + 1..<resultArr.count]).joined(separator: " ");
                newIf.addElseIf(condition: condition);
                //state.currentMethod?.addExpression(exp: newIf);
                break;
            }
            
            else{
                let line: String = Array(resultArr[wordIndex..<resultArr.count]).joined(separator: " ");
                let lineOfCode: JavaCode = JavaCode.init(exp: line)
                state.currentMethod?.addExpression(exp: lineOfCode);
            }
            
            //ELSE:
            
            
            
        }
        
        return state.toString();
        
    }
    
    static func wordListToCamelCase(_ words: [String]) -> String{
        return words.joined(separator: " ").camelized
    }
    
    //input like: new class fish; new private class head shoulders knees toes
    //TODO: make this? or don't? idk
    static func stringsToClass(_ : [String]) -> JavaClass {
        return JavaClass(className: "", vis: "public")
    }
}

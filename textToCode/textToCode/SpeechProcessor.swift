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
        let resultArr = lowerCaseResult.components(separatedBy: " ");
        
        for wordIndex in 0..<resultArr.count{
            
            //NEW CLASS: eg: "new private class dog"
            if(resultArr[wordIndex] ~= "new" && resultArr[wordIndex + 2] ~= "class"){
                print("In new class");
                state.addClass(newClass: JavaClass.init(className: wordListToCamelCase(Array(resultArr[wordIndex + 3..<resultArr.count])).uppercasingFirst, vis: resultArr[wordIndex + 1]));
            }
            
            //NEW METHOD: eg: "new public method kick returns boolean"
            if(resultArr[wordIndex] ~= "new" && resultArr[wordIndex + 2] ~= "method"){
                print("In new method");
                state.currentClass?.addMethod(methodName: wordListToCamelCase(Array(resultArr[wordIndex + 3..<resultArr.count])).uppercasingFirst, vis: resultArr[wordIndex + 1], returnType: resultArr[wordIndex + 5]);
                state.currentMethod = state.currentClass?.methods[(state.currentClass?.methods.count)! - 1];
            }
            
           //NEW VAR: eg: "new private variable String leg"
            if(resultArr[wordIndex] ~= "new" && resultArr[wordIndex + 2] ~= "variable"){
                if state.currentMethod == nil{
                    //NEW CLASS VAR: eg: "new private variable String leg"
                    print("In new class var");
                    state.currentClass?.addVar(varName: wordListToCamelCase(Array(resultArr[wordIndex + 4..<resultArr.count])), vis: resultArr[wordIndex + 1], type: resultArr[wordIndex + 3]);
                }else{
                    //NEW METHOD VAR: eg: "new private variable int size equals seven"
                    print("in new method var");
                    let newVar: JavaExpVariables = JavaExpVariables.init(name: wordListToCamelCase(Array(resultArr[wordIndex + 4..<resultArr.count - 1])), vis: resultArr[wordIndex + 1], type: resultArr[wordIndex + 3], value: resultArr[resultArr.count - 1]);
                    state.currentMethod?.addExpression(exp: newVar);
                }
            }
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

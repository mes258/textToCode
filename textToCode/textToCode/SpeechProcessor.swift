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
         new public variable string hi there equals seven stop
         new private method good bye returns integer stop
         new public variable boolean bye stop
 
         */
        for wordIndex in 0..<resultArr.count{
            
            //NEW CLASS: eg: "new private class dog stop "
            if(resultArr[wordIndex] ~= "new" && resultArr[wordIndex + 2] ~= "c"){
                print("In new class");
                state.addClass(newClass: JavaClass.init(className: wordListToCamelCase(Array(resultArr[wordIndex + 3..<resultArr.count])).uppercasingFirst, vis: resultArr[wordIndex + 1]));
            }
            
            //NEW METHOD: eg: "new public method kick returns boolean stop"
            if(resultArr[wordIndex] ~= "new" && resultArr[wordIndex + 2] ~= "m"){
                print("In new method");
                state.currentClass?.addMethod(methodName: wordListToCamelCase(Array(resultArr[wordIndex + 3..<resultArr.count - 2])).uppercasingFirst, vis: resultArr[wordIndex + 1], returnType: resultArr[wordIndex + 5]);
                state.currentMethod = state.currentClass?.methods[(state.currentClass?.methods.count)! - 1];
            }
            
           //NEW VAR: eg: "new private variable String leg stop"
            if(resultArr[wordIndex] ~= "new" && resultArr[wordIndex + 2] ~= "v"){
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

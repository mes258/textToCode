//
//  SpeechProcesser.swift
//  textToCode
//
//  Created by Michael Smith on 4/30/19.
//  Copyright © 2019 Michael Smith. All rights reserved.
//

import Foundation

class SpeechProcessor {
    
    static func processInput(result: String) -> String{
        var currentClass = -1;
        var currentMethod = -1;
        var classes: [JavaClass]  = [];
        
        let lowerCaseResult: String = result.lowercased();
        let resultArr = lowerCaseResult.components(separatedBy: " ");
        var atWord = 0;
        for wordIndex in 0..<resultArr.count{
            while(resultArr[wordIndex] ~= "new" && resultArr[wordIndex + 1] ~= "line"){
                atWord += 1;
                if(atWord > resultArr.count - 2){
                    break;
                }
            }
            
            //NEW CLASS: eg: "new private class dog"
            if(resultArr[wordIndex] ~= "new" && resultArr[wordIndex + 2] ~= "class"){
                print("In new class");
                classes.append(JavaClass.init(
                    className: wordListToCamelCase(Array(resultArr[wordIndex + 3..<resultArr.count])).uppercasingFirst,
                    vis: resultArr[wordIndex + 1]
                ));
                currentClass += 1;
            }
            //new private variable String head
            
            //NEW METHOD: eg: "new public method kick returns boolean"
            if(resultArr[wordIndex] ~= "new" && resultArr[wordIndex + 2] ~= "method"){
                print("In new method");
                classes[currentClass].addMethod(methodName: resultArr[wordIndex + 3], vis: resultArr[wordIndex + 1], returnType: resultArr[wordIndex + 5]);
                currentMethod += 1;
            }
            
            //NEW VAR: eg: "new private variable String leg"
            if(resultArr[wordIndex] ~= "new" && resultArr[wordIndex + 2] ~= "variable"){
                print("In new var");
                if(currentMethod == -1){
                    classes[currentClass].addVar(varName: wordListToCamelCase(Array(resultArr[wordIndex + 4..<resultArr.count])), vis: resultArr[wordIndex + 1], type: resultArr[wordIndex + 3]);
                }else{
                    classes[currentClass].addMethodVar(method: currentMethod, varName: wordListToCamelCase(Array(resultArr[wordIndex + 4..<resultArr.count])), vis: resultArr[wordIndex + 1], type: resultArr[wordIndex + 3]);
                }
            }
        }
        return outputString(classes: classes)
        
    }
    
    static func wordListToCamelCase(_ words: [String]) -> String{
        return words.joined(separator: " ").camelized
    }
    
    //input like: new class fish; new private class head shoulders knees toes
    //TODO: make this? or don't? idk
    static func stringsToClass(_ : [String]) -> JavaClass {
        return JavaClass(className: "", vis: "public")
    }
    
    static func outputString(classes: [JavaClass]) -> String{
        var outputStr: String = "";
        for javaClass in classes{
            outputStr += javaClass.toString();
        }
        return outputStr;
    }
}

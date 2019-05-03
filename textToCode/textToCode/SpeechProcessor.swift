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
    static let specialWords = ["equals": "=",
                               "plus": "+",
                               "minus": "-",
                               "divide": "/",
                               "divided": "/",
                               "open parenthesis": "(",
                               "close parenthiesis": ")",
                               "and": "&&",
                               "or": "||",
                               "less": "<",
                               "greater": ">",
                               "zero": "0",
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
                               "times": "*",
                               ]
    
    static func wordListToCamelCase(_ words: [String]) -> String{
        return words.joined(separator: " ").camelized
    }
    
    static func findIndexOf(targetWord: String, phrase: [String]) -> Int{
        if let index = phrase.firstIndex(of: targetWord){
            return index
        }else{
            return -1;
        }
    }
    
    static func scanPhrase(inputPhrase: [String], isCondition: Bool) -> [String]{
        var phrase = inputPhrase;
        var removeWords: [Int] = [];
        var inQuote = false;
        for i in 0..<phrase.count{
            if(phrase[i].contains("\"")){
                inQuote = !inQuote;
            }else{
                if(!inQuote){
                    if(phrase[i] == "equals" && isCondition){
                        phrase[i] = "==";
                    }else{
                        if((phrase[i] == "greater" || phrase[i] == "less") && phrase[i + 1] == "than"){
                            phrase[i] = specialWords[phrase[i]]!;
                            removeWords.append(i + 1);
                        }else{
                            let hasVal = specialWords[phrase[i]] != nil
                            if(hasVal){
                                phrase[i] = specialWords[phrase[i]]!;
                            }
                        }
                    }
                }
            }
        }
        
        removeWords = removeWords.reversed();
        for num in removeWords{
            phrase.remove(at: num);
        }
        return phrase;
    }
    
    static func otherInput(resultArr: ArraySlice<String>){
        let line: String = scanPhrase(inputPhrase: Array(resultArr[0..<resultArr.count]), isCondition: false).joined(separator: " ");
        let lineOfCode: JavaCode = JavaCode.init(exp: line)
        state.currentMethod?.addExpression(exp: lineOfCode);
    }
    
    static func processInput(result: String) -> NSMutableAttributedString{
        //Convert input into [String]
        let lowerCaseResult: String = result.lowercased();
        let fullResultArr = lowerCaseResult.components(separatedBy: " ");
        //Remove stop from the end of the input
        var resultArr = fullResultArr.prefix(fullResultArr.count - 1);
        let firstWordIndex = 0;
        var foundInputMatch = false;
        
        //UNDO:
        if(resultArr[firstWordIndex] ~= "undo" && state.previousState != nil){
            state = state.previousState!;
            foundInputMatch = true;
        }
        state.updatePrevious()
        
        if(resultArr.count > 5 && !foundInputMatch){
            //NEW METHOD
            if(resultArr[firstWordIndex] ~= "new" && resultArr[firstWordIndex + 2].first ~= "m"){
                state.currentClass?.addMethod(methodName: wordListToCamelCase(Array(resultArr[firstWordIndex + 3..<resultArr.count - 2])), vis: resultArr[firstWordIndex + 1], returnType: resultArr[resultArr.count - 1]);
                state.currentMethod = state.currentClass?.methods[(state.currentClass?.methods.count)! - 1];
                foundInputMatch = true;
            }
        }
        if(resultArr.count > 4 && !foundInputMatch){
            //NEW METHOD VARIABLE WITH A VALUE
            if(resultArr[firstWordIndex] ~= "new" && resultArr[firstWordIndex + 1].first ~= "v" && resultArr.contains("equals")){
                let equalsInt = findIndexOf(targetWord: "equals", phrase: Array(resultArr[firstWordIndex..<resultArr.count]))
                
                let newVar: JavaExpVariables = JavaExpVariables.init(name: wordListToCamelCase(Array(resultArr[firstWordIndex + 3..<equalsInt])), type: resultArr[firstWordIndex + 2], value: scanPhrase(inputPhrase: Array(resultArr[equalsInt + 1..<resultArr.count]), isCondition: true).joined(separator: " "));
                state.currentMethod?.addExpression(exp: newVar);
                foundInputMatch = true;
            }
        }
        if(resultArr.count > 3 && !foundInputMatch){
            //NEW CLASS
            if(resultArr[firstWordIndex] ~= "new" && resultArr[firstWordIndex + 2].first ~= "c"){
                state.addClass(newClass: JavaClass.init(className: wordListToCamelCase(Array(resultArr[firstWordIndex + 3..<resultArr.count])).uppercasingFirst, vis: resultArr[firstWordIndex + 1]))
                foundInputMatch = true;
            }
            //NEW CLASS VARIABLE
            else if(resultArr[firstWordIndex] ~= "new" && resultArr[firstWordIndex + 2].first ~= "v" && state.currentMethod == nil){
                state.currentClass?.addVar(varName: wordListToCamelCase(Array(resultArr[firstWordIndex + 4..<resultArr.count])), vis: resultArr[firstWordIndex + 1], type: resultArr[firstWordIndex + 3]);
                foundInputMatch = true;
            }
            //NEW METHOD VARIABLE WITHOUT INITIAL VARIABLE
            else if(resultArr[firstWordIndex] ~= "new" && resultArr[firstWordIndex + 1].first ~= "v"){
                let newVar: JavaExpVariables = JavaExpVariables.init(name: wordListToCamelCase(Array(resultArr[firstWordIndex + 3..<resultArr.count])), type: resultArr[firstWordIndex + 2], value: nil);
                state.currentMethod?.addExpression(exp: newVar);
                foundInputMatch = true;
            }
        }
        if(resultArr.count > 2 && !foundInputMatch){
            //GOTO
            if(resultArr[firstWordIndex] ~= "go" && resultArr[firstWordIndex + 1] ~= "to" ){
                let name: String = wordListToCamelCase(scanPhrase(inputPhrase: Array(resultArr[firstWordIndex + 2..<resultArr.count]), isCondition: true));
                state.goto(name);
                foundInputMatch = true;
            }
        }
        if(resultArr.count > 1 && !foundInputMatch){
            //WHILE
            if(resultArr[firstWordIndex].first ~= "w"){
                let condition: String = scanPhrase(inputPhrase: Array(resultArr[firstWordIndex + 1..<resultArr.count]), isCondition: true).joined(separator: " ");
                let newWhile: JavaWhile = JavaWhile.init(condition: condition)
                
                state.currentMethod?.addExpression(exp: newWhile)
                foundInputMatch = true;
            }
            //RETURN
            else if(resultArr[firstWordIndex].first ~= "r"){
                let returnVal: String = scanPhrase(inputPhrase: Array(resultArr[firstWordIndex + 1..<resultArr.count]), isCondition: true).joined(separator: " ");
                let newReturn: JavaReturn = JavaReturn.init(returnString: returnVal);
                state.currentMethod?.addExpression(exp: newReturn);
                foundInputMatch = true;
            }
            //IF
            else if(resultArr[firstWordIndex].first ~= "i"){
                let condition: String = scanPhrase(inputPhrase: Array(resultArr[firstWordIndex + 1..<resultArr.count]), isCondition: true).joined(separator: " ");
                let newIf: JavaIf = JavaIf.init(condition: condition);
                state.currentMethod?.addExpression(exp: newIf);
                foundInputMatch = true;
            }
            //ELSE IF
            else if(resultArr[firstWordIndex] ~= "else" && resultArr[firstWordIndex + 1] ~= "if"){
                let condition: String = scanPhrase(inputPhrase: Array(resultArr[firstWordIndex + 1..<resultArr.count]), isCondition: true).joined(separator: " ");
                let newElseIf: JavaElseIf = JavaElseIf.init(condition: condition);
                state.currentMethod?.addExpression(exp: newElseIf);
                foundInputMatch = true;
            }
            //PRINT
            else if(resultArr[firstWordIndex] ~= "print"){
                let printStatement: String = scanPhrase(inputPhrase: Array(resultArr[firstWordIndex + 1..<resultArr.count]), isCondition: true).joined(separator: " ");
                let newPrint: JavaPrint = JavaPrint.init(printStmt: printStatement);
                state.currentMethod?.addExpression(exp: newPrint);
                foundInputMatch = true;
            }
            //COMMENTS
            else if(resultArr[firstWordIndex] ~= "comment"){
                let commentStatement: String = scanPhrase(inputPhrase: Array(resultArr[firstWordIndex + 1..<resultArr.count]), isCondition: true).joined(separator: " ");
                let newComment: JavaComment = JavaComment.init(commentVal: commentStatement);
                state.currentMethod?.addExpression(exp: newComment);
                foundInputMatch = true;
            }
        }
        if(!foundInputMatch){
            //ELSE
            if(resultArr[firstWordIndex] ~= "else"){
                let newElse: JavaElse = JavaElse.init();
                state.currentMethod?.addExpression(exp: newElse);
                foundInputMatch = true;
            }
            //EXIT
            else if(resultArr[firstWordIndex] ~= "exit"){
                state.currentMethod?.exitExpression();
                foundInputMatch = true;
            }
            //CLEAR
            else if(resultArr[firstWordIndex] ~= "clear"){
                SpeechProcessor.state = JavaState()
                foundInputMatch = true;
            }
            //NON-STRUCTURED INPUT
            else{
                otherInput(resultArr: resultArr);
            }
        }
        
        return state.toFormattingString();
    }
}

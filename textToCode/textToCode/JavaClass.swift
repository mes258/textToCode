//
//  JavaClass.swift
//  textToCode
//
//  Created by Michael Smith on 4/21/19.
//  Copyright © 2019 Michael Smith. All rights reserved.
//

import Foundation
import UIKit

enum ItemVisability: String{
    case publicItem =  "public"
    case protectedItem = "protected"
    case defaultItem = ""
    case privateItem = "private"
}

class JavaClass{
    var name: String;
    var visability: ItemVisability;
    var classVariables: [JavaVariable] = [];
    var methods: [JavaMethod] = [];
    
    init(className: String, vis: String) {
        self.name = className;
        self.visability = ItemVisability(rawValue: vis) ?? ItemVisability.defaultItem;
    }
    
    func addMethod(methodName: String, vis: String, returnType: String){
        methods.append(JavaMethod.init(name: methodName, vis: vis, returnType: returnType));
    }
    
    func addVar(varName: String, vis: String, type: String){
        classVariables.append(JavaVariable.init(name: varName, vis: vis, type: type));
    }
    
    func findMethod(_ methodName: String) -> JavaMethod?{
        return methods.first(where: { (m:JavaMethod) -> Bool in
             return m.getName() == methodName
        })
    }
    
    func copy() -> JavaClass{
        let copy = JavaClass(className: name, vis: visability.rawValue)
        for xvar in classVariables{
            copy.classVariables.append(xvar.copy())
        }
        for xmethod in methods{
            copy.methods.append(xmethod.copy())
        }
        return copy
    }
    
    func toString() -> String{
        var outputStr: String = "";
        outputStr += "\(visability.rawValue) class \(name)(){"
        outputStr += "\n"
        for classVar in classVariables{
            outputStr += "    \(classVar.toString()) \n";
        }
        for method in methods{
            let methodLines = method.toString().components(separatedBy: "\n");
            for line in methodLines{
                outputStr += "    \(line) \n";
            }
            
        }
        outputStr += "}";
        return outputStr;
    }
    
    func toFormattedString() -> NSMutableAttributedString{
        var output = NSMutableAttributedString()
        let classHead = NSMutableAttributedString(string: "\(visability.rawValue) class \(name)(){ \n");
        output.append(classHead);
        for classVar in classVariables{
            let formattedVar = NSMutableAttributedString(string: "    \(classVar.toString()) \n");
            output.append(formattedVar)
        }
        for xmethod in methods{
            output.append(xmethod.toFormattedString())
        }
        
        let classEnd = NSMutableAttributedString(string: "} \n ");
        output.append(classEnd);
        
        if let xclass = SpeechProcessor.state.currentClass{
            if xclass.name == self.name && SpeechProcessor.state.currentMethod == nil{
                output = NSMutableAttributedString(string: self.toString());
                output.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.7, green: 0.0, blue: 1.0, alpha: 1.0)] as [NSAttributedString.Key: Any], range: NSRange(location: 0, length: self.toString().count));
            }
        }
        
        return output
    }
    
}


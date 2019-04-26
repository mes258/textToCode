//
//  JavaMethods.swift
//  textToCode
//
//  Created by Michael Smith on 4/21/19.
//  Copyright © 2019 Michael Smith. All rights reserved.
//

import Foundation

class JavaMethods{
    private var name: String;
    private var visability: ItemVisability;
    private var returnType: String;
    private var localVariable: [JavaVariables] = [];
    
    //Need to account for parameters
    init(name: String, vis: String, returnType: String) {
        self.name = name;
        self.visability = ItemVisability(rawValue: vis) ?? ItemVisability.defaultItem;
        self.returnType = returnType;
    }
    
    func addVar(varName: String, vis: String, type: String){
        localVariable.append(JavaVariables.init(name: varName, vis: vis, type: type));
    }
    
    func toString() -> String{
        var outputStr: String = "";
        outputStr += "\(visability.rawValue) \(returnType) \(name)(){ \n"
        for instanceVar in localVariable{
            outputStr += "    \(instanceVar.toString()) \n";
        }
        outputStr += "}";
        
        print(outputStr);
        return outputStr;
    }
}

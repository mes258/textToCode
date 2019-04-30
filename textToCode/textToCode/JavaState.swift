//
//  JavaState.swift
//  textToCode
//
//  Created by Michael Smith on 4/30/19.
//  Copyright © 2019 Michael Smith. All rights reserved.
//

import Foundation

class JavaState{
    //We should make this a singleton or cache it 
    var classes: [JavaClass] = [];
    var currentClass: JavaClass? = nil;
    var currentMethod: JavaMethod? = nil;
    var atline: Int = 0;
    
    init() {
        
    }
    
    private func varsInScope() -> [JavaVariable]{
        var vars: [JavaVariable] = []
        if let cclass = currentClass{
            vars.append(contentsOf: cclass.classVariables)
        }
        if let cmethod = currentMethod{
            vars.append(contentsOf: cmethod.getVariables())
        }
        return vars
    }
    
    private func methodsInScope() -> [JavaMethod]{
        var methods: [JavaMethod] = []
        if let cclass = currentClass{
            methods.append(contentsOf: cclass.methods)
        }
        return methods
    }
    
    func findClass(_ className: String) -> JavaClass?{
        return classes.first(where: { (j:JavaClass) -> Bool in
            return j.name == className
        })
    }
    
    func goto(_ className: String){
        if let xclass = findClass(className){
            currentClass = xclass;
        }
    }
    
    func goto(_ className: String, _ methodName: String){
        goto(className)
        currentMethod = currentClass?.findMethod(methodName)
    }
    
    func toString() -> String{
        var output = "";
        for xclass in classes{
            output.append(xclass.toString())
            output.append("\n")
        }
        return output
    }
}

//
//  JavaState.swift
//  textToCode
//
//  Created by Michael Smith on 4/30/19.
//  Copyright © 2019 Michael Smith. All rights reserved.
//

import Foundation

class JavaState{
    var classes: [JavaClass] = [];
    var currentClass: JavaClass? = nil;
    var currentMethod: JavaMethod? = nil;
    var previousState: JavaState? = nil;
    init() {
        
    }
    
    func addClass(newClass: JavaClass){
        classes.append(newClass);
        currentClass = classes[classes.count - 1];
    }
    
    private func varsInScope() -> ([JavaVariable], [JavaExpVariables]){
        var vars: (classVars: [JavaVariable], methodVars: [JavaExpVariables]) = ([],[]);
        
        if let cclass = currentClass{
            vars.classVars.append(contentsOf: cclass.classVariables);
        }
        if let cmethod = currentMethod{
            vars.methodVars.append(contentsOf: cmethod.getVariables());
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
    
    func goto(_ name: String){
        if currentClass?.findMethod(name) != nil {
            currentMethod = currentClass?.findMethod(name)
        }else if let xclass = findClass(name.uppercasingFirst){
            currentClass = xclass;
            currentMethod = Optional.none
        }
    }
    
    func goto(_ className: String, _ methodName: String){
        goto(className)
        currentMethod = currentClass?.findMethod(methodName)
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func fileNames() -> [URL]{
        var urls: [URL] = []
        for xclass in classes{
            urls.append(getDocumentsDirectory().appendingPathComponent(xclass.name));
        }
        return urls
    }
    
    func saveFilesAndGetNames() -> [URL]{
        var urls: [URL] = []
        for xclass in classes{
            let name = getDocumentsDirectory().appendingPathComponent(xclass.name+".java")
            do {
                try xclass.toString().write(to: name, atomically: true, encoding: String.Encoding.utf8)
                urls.append(name);
            } catch {/* error */}
        }
        return urls
    }
    
    func toString() -> String{
        var output = "";
        for xclass in classes{
            output.append(xclass.toString())
            output.append("\n")
        }
        return output
    }
    
    func updatePrevious(){
        previousState = copy()
    }
    
    func copy() -> JavaState{
        let copy = JavaState()
        for xclass in classes{
            copy.classes.append(xclass.copy())
        }
        copy.currentClass = currentClass
        copy.currentMethod = currentMethod
        copy.previousState = previousState
        
        return copy
    }
    
    func toFormattingString() -> NSMutableAttributedString{
        let output = NSMutableAttributedString()
        for xclass in classes{
            output.append(xclass.toFormattedString())
        }
        return output
    }
}

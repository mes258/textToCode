//
//  JavaVariable.swift
//  textToCode
//
//  Created by Michael Smith on 4/21/19.
//  Copyright © 2019 Michael Smith. All rights reserved.
//

import Foundation

class JavaVariable{
    private var name: String;
    private var visability: ItemVisability;
    private final var type: String;
    
    init(name: String, vis: String, type: String) {
        self.name = name;
        self.visability = ItemVisability(rawValue: vis) ?? ItemVisability.defaultItem;
        self.type = type;
    }
    
    func getName() -> String{
        return self.name;
    }
    
    func getVis() -> ItemVisability{
        return self.visability;
    }
    
    func getType() -> String{
        return self.type;
    }
    
    func toString() -> String{
        return "\(visability.rawValue) \(type) \(name);"
    }
    
    func copy() -> JavaVariable{
        let varCopy = JavaVariable.init(name: self.getName(), vis: self.getVis().rawValue, type: self.getType())
        return varCopy;
    }
    
}




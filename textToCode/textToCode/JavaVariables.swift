//
//  JavaVariables.swift
//  textToCode
//
//  Created by Michael Smith on 4/21/19.
//  Copyright © 2019 Michael Smith. All rights reserved.
//

import Foundation

class JavaVariables{
    private var name: String;
    private var visability: ItemVisability;
    private final var type: String;
    
    init(name: String, vis: String, type: String) {
        self.name = name;
        self.visability = ItemVisability(rawValue: vis) ?? ItemVisability.defaultItem;
        self.type = type;
    }
    
    func getType() -> String{
        return self.type;
    }
    
    func toString() -> String{
        return "\(visability.rawValue) \(type) \(name);"
    }
    
}




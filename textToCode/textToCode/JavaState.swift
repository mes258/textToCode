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
    var  currentClass: JavaClass? = nil;
    var  currentMethod: JavaMethods? = nil;
    
    init() {
        
    }
    
    
}

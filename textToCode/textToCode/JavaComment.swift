//
//  JavaComments.swift
//  textToCode
//
//  Created by Michael Smith on 5/3/19.
//  Copyright © 2019 Michael Smith. All rights reserved.
//

import Foundation

class JavaComment: JavaExpression{
    private var INDENT = "\t";
    var commentValue: String
    
    init(commentVal: String){
        self.commentValue = commentVal;
    }
    
    func getCommentVal()->String{
        return self.commentValue;
    }
    override func toString() -> String{
        return "\(INDENT)// \(self.commentValue)\n"
    }
    
    override func copy() -> JavaComment {
        let commentCopy = JavaComment.init(commentVal: self.getCommentVal())
        return commentCopy;
    }
}


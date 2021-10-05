//
//  Optional+Extensions.swift
//  WookieMovie
//
//  Created by Vincent Coetzee on 4/10/21.
//

import Foundation

extension Optional
    {
    public var isNil: Bool
        {
        switch(self)
            {
            case .none:
                return(true)
            default:
                return(false)
            }
        }
        
    public var isNotNil: Bool
        {
        switch(self)
            {
            case .some:
                return(true)
            default:
                return(false)
            }
        }
    }

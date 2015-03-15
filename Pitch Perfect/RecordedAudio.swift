//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Ben Scott on 15/03/2015.
//  Copyright (c) 2015 Schmurgon Pty Ltd. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init( filePathUrl: NSURL, title: String )
    {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}

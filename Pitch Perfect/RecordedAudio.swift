//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Samir Marin on 2015-11-18.
//  Copyright © 2015 Samir Marin. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    init(filePathUrl: NSURL!, title: String!){
        self.filePathUrl = filePathUrl
        self.title = title
    }
}

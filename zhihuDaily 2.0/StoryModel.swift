//
//  StoryModel.swift
//  zhihuDaily 2.0
//
//  Created by Nirvana on 10/2/15.
//  Copyright © 2015 NSNirvana. All rights reserved.
//

import Foundation

struct TopStoryModel {
    var image: String
    var id: String
    var title: String
    init (image: String, id: String, title: String) {
        self.image = image
        self.id = id
        self.title = title
    }
}

struct ContentStoryModel {
    var images: [String]
    var id: String
    var title: String
    init (images: [String], id: String, title: String) {
        self.images = images
        self.id = id
        self.title = title
    }
}
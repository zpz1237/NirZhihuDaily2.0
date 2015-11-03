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

protocol PastContentStoryItem {
    
}

struct ContentStoryModel: PastContentStoryItem {
    var images: [String]
    var id: String
    var title: String
    init (images: [String], id: String, title: String) {
        self.images = images
        self.id = id
        self.title = title
    }
}

struct DateHeaderModel:PastContentStoryItem {
    var date: String
    init (dateString: String) {
        self.date = dateString
    }
}

struct ThemeModel {
    var id: String
    var name: String
    init (id: String, name: String) {
        self.id = id
        self.name = name
    }
}

struct ThemeContentModel {
    var stories: [ContentStoryModel]
    var background: String
    var editorsAvatars: [String]
    init (stories: [ContentStoryModel], background: String, editorsAvatars: [String]) {
        self.stories = stories
        self.background = background
        self.editorsAvatars = editorsAvatars
    }
}

struct Keys {
    static let launchImgKey = "launchImgKey"
    static let launchTextKey = "launchTextKey"
    static let readNewsId = "readNewsId"
}

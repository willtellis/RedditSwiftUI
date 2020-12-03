//
//  PostsGenerator.swift
//  RedditSwiftUI
//
//  Created by Will Ellis on 11/17/20.
//

import Foundation

struct PostsGenerator {

    static func make(model: PostsAPIResponse) -> [Post] {
        return model.data?.children?.compactMap({ makePost(with: $0) }) ?? []
    }

    static func make(with error: Error) -> [Post] {
        return []
    }

    private static func makePost(with model: PostsAPIResponse.Data.Child) -> Post? {
        return Post(title: model.data?.title)
    }
}

struct Post: Identifiable, Hashable {
    var id: String? {
        return title
    }

    let title: String?

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}

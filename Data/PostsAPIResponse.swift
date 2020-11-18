//
//  PostsAPIResponse.swift
//  RedditSwiftUI
//
//  Created by Will Ellis on 11/12/20.
//

import Foundation

struct PostsAPIResponse: Decodable {
    let data: Data?

    struct Data: Decodable {
        let children: [Child]?
        let after: String?

        struct Child: Decodable {
            let data: Data?

            struct Data: Decodable {
                let title: String?
            }
        }
    }
}

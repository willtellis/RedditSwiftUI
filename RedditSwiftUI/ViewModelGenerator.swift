//
//  ViewModelGenerator.swift
//  RedditSwiftUI
//
//  Created by Will Ellis on 11/17/20.
//

import Foundation

struct ViewModel {
    let posts: [Post]

    struct Post: Identifiable {
        var id: String? {
            return title
        }

        let title: String?
    }
}

struct ViewModelGenerator {

    private var viewModel: ViewModel?

    mutating func make(appending model: PostsAPIResponse) -> (ViewModel, [IndexPath]) {
        let previousPosts = viewModel?.posts ?? []
        let posts = model.data?.children?.compactMap({ makePost(with: $0) }) ?? []
        let viewModel = ViewModel(posts: previousPosts + posts)
        self.viewModel = viewModel
        let indexPathsToReload = (previousPosts.count..<viewModel.posts.count).map({ IndexPath(row: $0, section: 0) })
        return (viewModel, indexPathsToReload)
    }

    func make(with error: Error) -> (ViewModel, [IndexPath]) {
        return (ViewModel(posts: []), [])
    }

    private func makePost(with model: PostsAPIResponse.Data.Child) -> ViewModel.Post? {
        return ViewModel.Post(title: model.data?.title)
    }
}

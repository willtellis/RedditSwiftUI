//
//  ContentViewModel.swift
//  RedditSwiftUI
//
//  Created by Will Ellis on 12/3/20.
//

import Foundation
import Combine

class ContentViewModel: ObservableObject {
    @Published private(set) var posts: [Post]
    private var after: String?

    private let postsSubject = PassthroughSubject<String?, Never>()
    private var cancellables = Set<AnyCancellable>()

    // Dependency injection for mocking here feels a little bad
    init(posts: [Post] = [], apiClient: RedditAPIClient? = RedditAPIClient()) {
        self.posts = posts
        if let apiClient = apiClient {
            postsSubject
                .removeDuplicates()
                .flatMap { after in apiClient.postsPublisher(after: after) }
                .receive(on: DispatchQueue.main)
                .map { (PostsGenerator.make(model: $0), $0.data?.after) }
                .catch { Just((PostsGenerator.make(with: $0), nil)) }
                .eraseToAnyPublisher()
                .sink { [weak self] (posts, after) in
                    self?.posts += posts
                    self?.after = after
                }
                .store(in: &cancellables)
        }
    }

    func fetchNextPage() {
        postsSubject.send(after)
    }
}

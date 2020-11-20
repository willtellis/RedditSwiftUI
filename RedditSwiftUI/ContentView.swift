//
//  ContentView.swift
//  RedditSwiftUI
//
//  Created by Will Ellis on 11/5/20.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State var posts: [Post] = []
    @State private var after: String?

    var apiClient = RedditAPIClient()

    private let postsSubject = PassthroughSubject<String?, Never>()
    private var postsPublisher: AnyPublisher<([Post], String?), Never> {
        return postsSubject
            .removeDuplicates()
            .flatMap { after in apiClient.postsPublisher(after: after) }
            .receive(on: DispatchQueue.main)
            .map { (PostsGenerator.make(model: $0), $0.data?.after) }
            .catch { Just((PostsGenerator.make(with: $0), nil)) }
            .eraseToAnyPublisher()
    }

    var body: some View {
        NavigationView {
            List(posts) { post in
                Text(post.title ?? "")
                    .padding()
                    .onAppear {
                        guard posts.isLastItem(post) else {
                            return
                        }
                        postsSubject.send(after)
                    }
            }
            .navigationTitle("Reddit")
            .onAppear {
                postsSubject.send(nil)
            }
            .onReceive(postsPublisher) { (posts, after) in
                self.posts += posts
                self.after = after
            }
        }
    }
}

extension RandomAccessCollection where Self.Element: Identifiable {
    func isLastItem<Item: Identifiable>(_ item: Item) -> Bool {
        guard let lastItem = last else {
            return false
        }

        return item.id.hashValue == lastItem.id.hashValue
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(posts: [
            Post(title: "Test 1"),
            Post(title: "Test 2")
        ])
    }
}

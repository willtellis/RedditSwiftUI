//
//  ContentView.swift
//  RedditSwiftUI
//
//  Created by Will Ellis on 11/5/20.
//

import SwiftUI
import Combine

private let postsPublisher: AnyPublisher<[Post], Never> = RedditAPIClient()
    .postsPublisher(after: nil)
    .receive(on: DispatchQueue.main)
    .map { PostsGenerator.make(model: $0) }
    .catch { Just(PostsGenerator.make(with: $0)) }
    .eraseToAnyPublisher()

struct ContentView: View {
    @State var posts: [Post] = []

    var body: some View {
        NavigationView {
            List(posts) { post in
                Text(post.title ?? "")
                    .padding()
            }
            .navigationTitle("Reddit")
            .onReceive(postsPublisher, perform: { posts in
                self.posts = posts
            })
        }
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

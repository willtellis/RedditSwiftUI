//
//  ContentView.swift
//  RedditSwiftUI
//
//  Created by Will Ellis on 11/5/20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var postsModel: ContentViewModel = ContentViewModel()

    var body: some View {
        NavigationView {
            List(postsModel.posts) { post in
                Text(post.title ?? "")
                    .padding()
                    .onAppear {
                        guard postsModel.posts.isLastItem(post) else {
                            return
                        }
                        postsModel.fetchNextPage()
                    }
            }
            .navigationTitle("Reddit")
            .onAppear {
                postsModel.fetchNextPage()
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
        ContentView(
            postsModel: ContentViewModel(
                posts: [
                    Post(title: "Test 1"),
                    Post(title: "Test 2")
                ],
                apiClient: nil
            )
        )
    }
}

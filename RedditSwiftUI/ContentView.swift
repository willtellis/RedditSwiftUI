//
//  ContentView.swift
//  RedditSwiftUI
//
//  Created by Will Ellis on 11/5/20.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var after: String?
    @State private var viewModel = ViewModel(posts: [])

    private let afterSubject = PassthroughSubject<String?, Never>()
    private let apiClient: RedditAPIClient
    private var viewModelGenerator: ViewModelGenerator

    private var postsPublisher: AnyPublisher<(ViewModel, [IndexPath]), Never>

    init(apiClient: RedditAPIClient = RedditAPIClient(),
         viewModelGenerator: ViewModelGenerator = ViewModelGenerator()) {
        self.apiClient = apiClient
        var viewModelGenerator = viewModelGenerator
        self.viewModelGenerator = viewModelGenerator
        self.postsPublisher = apiClient.postsPublisher(after: nil)
            .receive(on: DispatchQueue.main)
            .map { viewModelGenerator.make(appending: $0) }
            .catch { Just(viewModelGenerator.make(with: $0)) }
            .eraseToAnyPublisher()
    }

    private var cancellables = Set<AnyCancellable>()

    var body: some View {
        NavigationView {
            List(viewModel.posts) { post in
                Text(post.title ?? "")
                    .padding()
            }
            .navigationTitle("Reddit")
            .onReceive(postsPublisher, perform: { (viewModel, indexPaths) in
                self.viewModel = viewModel
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

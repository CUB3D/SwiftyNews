//
//  TopPostListView.swift
//  Swifty News
//
//  Created by user on 02/10/2020.
//

import Foundation
import SwiftUI
import Combine

class PostListViewModel: ObservableObject {
    @Published var posts: Array<HNItem> = []

    var api: HNApi;
    var tokens: Set<AnyCancellable> = []

    init(api: HNApi) {
        self.api = api;
    }

    func getPosts() {
        self.api.getTopStoriesAsync().sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break;
            case .failure(let error):
                print("Error:", error)
            }
        }, receiveValue: { items in
            self.posts = items.filter { (item: HNItem) -> Bool in
                item.type == "story"
            }
        }).store(in: &tokens)
    }
}

struct TopPostListView: View {
    @ObservedObject var viewModel = PostListViewModel(api: HNApi())

    @State private var selection: String? = nil
    
    private var type: String

    init(type: String) {
        self.type = type
    }

    
    var body: some View {
        NavigationView {
            List(viewModel.posts) { i in
                NavigationLink(
                    destination: SingleItemDetailView(item: i),
                    tag: String(i.id),
                    selection: $selection
                ) {
                    VStack(alignment: .leading) {
                        Text(i.title!).padding()
                        Text("Posted at \(formatDate(i: i))")
                            .padding()
                            .foregroundColor(Color.gray)
                    }
                }
            }.onAppear {
                viewModel.getPosts()
            }
            .navigationBarTitle("Top Stories")
        }
    }
}

func formatDate(i: HNItem) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    
    formatter.locale = Locale(identifier: "en_GB")
    let formattedDate = formatter.string(from: i.time)
    return formattedDate;
}

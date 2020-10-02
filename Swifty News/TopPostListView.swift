//
//  TopPostListView.swift
//  Swifty News
//
//  Created by user on 02/10/2020.
//

import Foundation
import SwiftUI

struct TopPostListView: View {
    @ObservedObject var topStories = HNApi()
    
    @State private var selection: String? = nil
    
    private var type: String

    init(type: String) {
        self.type = type
    }

    
    var body: some View {
        NavigationView {
            List(topStories.items.filter({ (item: HNItem) -> Bool in
                item.type == "story"
            })) { i in
                NavigationLink(
                    destination: SingleItemDetailView(item: i),
                    tag: String(i.id),
                    selection: $selection
                ) {
                    VStack {
                        Text(i.title!).padding()
                        Text("Posted at \(formatDate(i: i))")
                    }
                }
            }.onAppear {
                topStories.getTopStories()
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

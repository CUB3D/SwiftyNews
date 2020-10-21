//
//  ItemChildrenView.swift
//  Swifty News
//
//  Created by user on 02/10/2020.
//

import Foundation
import SwiftUI
import Combine

class ViewModel: ObservableObject {
    @Published var children: Array<HNItem> = []

    var api: HNApi
    var tokens: Set<AnyCancellable> = []

    init(api: HNApi) {
        self.api = api;
    }

    func getChildren(item: HNItem) {
        self.api.loadChildren(item: item).sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break;
            case .failure(let error):
                print("Error:", error)
            }
        }, receiveValue: { items in
            self.children = items.filter { (item: HNItem) -> Bool in
                //TODO: is this check even needed anymore
                item.type == "comment"
            }
        }).store(in: &tokens)
    }
}

struct ItemChildrenView: View {
    @ObservedObject var viewModel = ViewModel(api: HNApi())

    var item: HNItem
    init(item: HNItem) {
        self.item = item
    }
    
    var body: some View {
        VStack {
            Text(self.item.text?.stringByDecodingHTMLEntities ?? "").padding()
            List(viewModel.children) { comment in
                ItemChildrenView(item: comment)
            }.onAppear {
                viewModel.getChildren(item: self.item)
            }
        }
    }
}

//
//  SingleItemView.swift
//  Swifty News
//
//  Created by user on 02/10/2020.
//

import Foundation
import SwiftUI

class SingleItemDetailViewModel: ObservableObject {
    var activity: NSUserActivity? = nil
}

struct SingleItemDetailView: View
{
    @ObservedObject var viewModel = SingleItemDetailViewModel()
    var item: HNItem

    init(item: HNItem) {
        self.item = item
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Text(self.item.title ?? "").padding()
                Button("Open link") {
                    UIApplication.shared.open(self.item.url!)
                }
                let x = self.item.by ?? ""
                Text("Post by \(x)")
                Text("\(self.item.score ?? 0) votes")
                Text("Posted at \(self.item.time)")
                Text(self.item.text ?? "").padding()

                ItemChildrenView(item: self.item)
            }
        }.onAppear {
            self.viewModel.activity = NSUserActivity(activityType: "pw.cub3d.browse")
            self.viewModel.activity!.webpageURL = self.item.url
            self.viewModel.activity!.becomeCurrent()
        }
    }
}

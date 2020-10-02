//
//  SingleItemView.swift
//  Swifty News
//
//  Created by user on 02/10/2020.
//

import Foundation
import SwiftUI

struct SingleItemDetailView: View
{
    var item: HNItem
    @ObservedObject var api = HNApi()
    
    init(item: HNItem) {
        self.item = item
    }
    
    var body: some View {
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
    }
}

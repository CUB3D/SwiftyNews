//
//  ItemChildrenView.swift
//  Swifty News
//
//  Created by user on 02/10/2020.
//

import Foundation
import SwiftUI

struct ItemChildrenView: View {
    @ObservedObject var api = HNApi()
    
    var item: HNItem
    init(item: HNItem) {
        self.item = item
    }
    
    var body: some View {
        VStack {
            Text(self.item.text?.stringByDecodingHTMLEntities ?? "").padding()
            List(api.items.filter({ (item: HNItem) -> Bool in
                item.type == "comment" && item.parent == self.item.id
            })) { comment in
                ItemChildrenView(item: comment)
            }.onAppear {
                api.loadChildren(item: self.item)
            }
        }
    }
}

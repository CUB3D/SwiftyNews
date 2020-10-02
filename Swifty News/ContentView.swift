//
//  ContentView.swift
//  Swifty News
//
//  Created by user on 02/10/2020.
//

import SwiftUI

struct ContentView: View
{    
    var body: some View {
        TabView {
            TopPostListView(type: "story")
                .tabItem { Text("Top Stories") }
            TopPostListView(type: "job")
                .tabItem { Text("Top Jobs") }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

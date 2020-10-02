//
//  HNApi.swift
//  Swifty News
//
//  Created by user on 02/10/2020.
//

import Foundation
import Alamofire

//TODO: future idea: maybe seperate post/comment/etc into separate structs in future
struct HNItem: Identifiable {
    public var id: Int
    public var deleted: Bool
    public var type: String
    public var by: String?
    public var time: Date
    public var text: String?
    public var dead: Bool
    public var parent: Int?
    public var poll: Int
    public var kids: [Int]
    public var url: URL?
    public var score: Int?
    public var title: String?
    public var parts: [Int]
    public var decendants: Int
}

class HNApi : ObservableObject {
    @Published var items = [HNItem]()
    
    @Published var topStoriesIds = [Int]()
        
    func getTopStories() {
        AF.request("https://hacker-news.firebaseio.com/v0/topstories.json")
            .responseJSON {
                response in
                print("Got api response")
                print(response)
                
                if let json = response.value {
                    if let json = (json as? [Int]) {                        
                        json.forEach({ x in
                            self.getItem(id: x)
                            self.topStoriesIds.append(x)
                        })
                    } else {
                        print("Failed to convert response to int array")
                    }
                } else {
                    print("Failed to request top stories")
                }
            }
    }
    
    func getItem(id: Int) {
        if items.contains(where: { (x: HNItem) -> Bool in
            x.id == id
        }) {
            // Dont reload things we dont need, lets be nice to the api
            return;
        }
        AF.request("https://hacker-news.firebaseio.com/v0/item/\(id).json")
            .responseJSON {
                response in
                print("Got api item response")
                print(response)
                
                if let json = response.value {
                    if (json as? [String: AnyObject]) != nil {
                        
                        if let dictionaryArray = json as? Dictionary<String, AnyObject?> {
                            let by = dictionaryArray["by"] as? String
                            let score = dictionaryArray["score"] as? Int
                            let time = dictionaryArray["time"] as! Double
                            let title = dictionaryArray["title"] as? String
                            let text = dictionaryArray["text"] as? String
                            let type = dictionaryArray["type"] as! String
                            let url = dictionaryArray["url"] as? String
                            let kids = dictionaryArray["kids"] as? [Int] ?? []
                            let parent = dictionaryArray["parent"] as? Int

                            
                            self.items.append(
                                HNItem(
                                    id: id,
                                    deleted: false,
                                    type: type,
                                    by: by,
                                    time: Date(timeIntervalSince1970: time),
                                    text: text,
                                    dead: false,
                                    parent: parent,
                                    poll: 0,
                                    kids: kids,
                                    url: url.map({ (urlStr) -> URL in
                                        URL(string: urlStr)!
                                    }),
                                    score: score,
                                    title: title,
                                    parts: [0],
                                    decendants: 0
                                )
                            )
                        }
                    }
                } else {
                    print("Failed to load item \(id)")
                }
            }
    }
    
    func loadChildren(item: HNItem) {
        item.kids.forEach { (child: Int) in
            self.getItem(id: child)
        }
    }
}

//
//  HNApi.swift
//  Swifty News
//
//  Created by user on 02/10/2020.
//

import Foundation
import Alamofire
import Combine

//TODO: future idea: maybe seperate post/comment/etc into separate structs in future
struct HNItem: Identifiable, Codable {
    public var id: Int
    public var deleted: Bool?
    public var type: String
    public var by: String?
    public var time: Date
    public var text: String?
    public var dead: Bool?
    public var parent: Int?
    public var poll: Int?
    public var kids: [Int]?
    public var url: URL?
    public var score: Int?
    public var title: String?
    public var parts: [Int]?
    public var descendants: Int?
}

class HNApi : ObservableObject {
    @Published var items = [HNItem]()

    @Published var topStoriesIds = [Int]()

    func getTopStoryIdsAsync() -> AnyPublisher<[Int], AFError> {
        AF.request("https://hacker-news.firebaseio.com/v0/topstories.json").publishDecodable(type: [Int].self).value()
    }

    func getItemAsync(id: Int) -> AnyPublisher<HNItem, AFError> {
        AF.request("https://hacker-news.firebaseio.com/v0/item/\(id).json").publishDecodable(type: HNItem.self).value()
    }

    func getTopStoriesAsync() -> AnyPublisher<[HNItem], AFError> {
        getTopStoryIdsAsync()
                .flatMap { [self] (ids: [Int]) in
                    Publishers.Sequence<[AnyPublisher<HNItem, AFError>], AFError>(sequence: ids.prefix(10).map { id in
                                getItemAsync(id: id)
                            })
                            .flatMap {
                                $0
                            }
                            .collect()
                            .eraseToAnyPublisher()
                }.eraseToAnyPublisher()
    }
    
    func loadChildren(item: HNItem) -> AnyPublisher<[HNItem], AFError> {
        Publishers.Sequence<[AnyPublisher<HNItem, AFError>], AFError>(sequence: (item.kids ?? []).map { childId in self.getItemAsync(id: childId) })
                .flatMap {
                    $0
                }
                .collect()
                .eraseToAnyPublisher()
    }
}

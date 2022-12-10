//
//  ArrayUniqueTests.swift
//  
//
//  Created by Ezequiel Becerra on 10/12/2022.
//

@testable import App
import XCTVapor

final class ArrayUniqueTests: XCTestCase {
    func testArrayUnique() throws {
        let trend1 = Trend(
            id: 1,
            name: "foo 1",
            relatedTopics: [],
            title: "bar 1",
            url: URL(string: "https://www.apple.com")!,
            category: nil
        )

        let trend1dup = Trend(
            id: 2,
            name: "foo 2",
            relatedTopics: [],
            title: "bar 2",
            url: URL(string: "https://www.apple.com")!,
            category: nil
        )

        let trend2 = Trend(
            id: 3,
            name: "foo 3",
            relatedTopics: [],
            title: "bar 3",
            url: URL(string: "https://www.google.com")!,
            category: nil
        )

        let array = [trend1, trend1dup, trend2]
        XCTAssertEqual(array.unique(by: { $0.url }).count, 2)
    }
}

//
//  AsyncAwaitCTTests.swift
//  AsyncAwaitCTTests
//
//  Created by Russell Mirabelli on 12/6/21.
//

import XCTest
@testable import AsyncAwaitCT

class AsyncAwaitCTTests: XCTestCase {

    func testClosure() throws {
        let expectation = expectation(description: "posts fetched")
        PostsService().fetchPosts { result in
            let posts = try? result.get()
            XCTAssert(!(posts?.isEmpty ?? true))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 4.0)
    }

    func testAsync() async throws {
        let posts = try await PostsService().posts()
        XCTAssert(!posts.isEmpty)
    }

}

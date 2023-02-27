//
//  fetchChallengeTests.swift
//  fetchChallengeTests
//
//  Created by Cal Dudley on 2/21/23.
//

import XCTest
@testable import fetchChallenge

class fetchChallengeTests: XCTestCase {
    
    var recipeManager: RecipeManager!
    
    override func setUp() {
        super.setUp()
        recipeManager = RecipeManager()
    }
    
    override func tearDown() {
        recipeManager = nil
        super.tearDown()
    }
    
    

}

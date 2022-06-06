//
//  TvMonsterTests.swift
//  TvMonsterTests
//
//  Created by Obed Garcia on 5/6/22.
//

import XCTest
@testable import TvMonster

class TvMonsterTests: XCTestCase {

    var dataService: TvDataService!
    var dataManager: TestDataManager!

    override func setUp() {
        super.setUp()
        
        dataManager = TestDataManager()
        dataService = TvDataService(dataManager: dataManager)
    }
    
    override func tearDown() {
        super.tearDown()
        
        dataManager = nil
        dataService = nil
    }
    
    func testSyncSavingShowShouldReturnSavedEntity() throws {
        var savedResult: Result<Bool, Error>?
        
        let show = Show(id: 1,
                        name: "Vikings",
                        genres: ["Action"],
                        schedule: ShowSchedule(time: "22:00", days: ["Friday"]),
                        summary: "Vkiking show.",
                        rating: ShowRating(average: 10.0),
                        image: nil,
                        premiered: "2014",
                        savedId: nil)
        
        let expectation = self.expectation(description: "Save show expectation")
        
        dataService.saveShow(show: show) { result in
            savedResult = result

            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 4) { error in
            XCTAssertNil(error)
            
            switch savedResult {
            case .success(let isSaved):
                XCTAssertTrue(isSaved)
            case .failure, .none:
                XCTFail()
            }
        }
    }
    
    func testSyncFavoriteShowsShouldBeEmpty() throws {
        let favoriteShows = dataService.getFavoriteShows()
        
        XCTAssertEqual(favoriteShows.count, 0)
    }

}

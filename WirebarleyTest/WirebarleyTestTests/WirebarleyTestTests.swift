//
//  WirebarleyTestTests.swift
//  WirebarleyTestTests
//
//  Created by 남기범 on 2021/01/12.
//

import XCTest
import RxSwift
import RxCocoa
@testable import WirebarleyTest

class WirebarleyTestTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCalculationRepositoryDecodeCheck() throws {
        let repository = CalculationRepository()
        let observable = repository.fetchRates()
        let bag = DisposeBag()
        
        observable.subscribe(onNext: { element in
            XCTAssertNotNil(element)
        }).disposed(by: bag)
    }
}

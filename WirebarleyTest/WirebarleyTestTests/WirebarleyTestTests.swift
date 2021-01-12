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
    let disposeBag = DisposeBag()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCalculationRepositoryDecodeCheck() throws {
        let repository = CalculationRepository()
        let observable = repository.fetchRates()
        var observableError: Error?

        observable.subscribe(onNext: { element in
            XCTAssertNotNil(element)
        }, onError: { error in
            observableError = error
        }).disposed(by: disposeBag)
        
        XCTAssertNil(observableError)
    }
    
    func testCalculationViewModelSubscribeCheck() throws {
        let viewModel = CalculationViewModel()
        
        var remittanceCountry: String?
        var recipientCountry: String?
        var exchangeRate: String?
        
        viewModel.remittanceCountry.subscribe(onNext: { element in
            remittanceCountry = element
        }, onCompleted: {
            XCTAssertEqual(remittanceCountry, "미국")
        }).disposed(by: disposeBag)
        
        viewModel.recipientCountry.subscribe(onNext: { element in
            recipientCountry = element
        }, onCompleted: {
            XCTAssertEqual(recipientCountry, "한국")
        }).disposed(by: disposeBag)
        
        viewModel.exchangeRate.subscribe(onNext: { element in
            exchangeRate = element
        }, onCompleted: {
            XCTAssertEqual(exchangeRate, "1.0")
        }).disposed(by: disposeBag)
        
        viewModel.quotes.onNext(ExchangeRateData(송금국가: "미국", 수취국가: "한국", 환율: "1.0"))
    }
}

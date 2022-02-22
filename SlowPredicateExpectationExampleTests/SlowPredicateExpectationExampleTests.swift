import XCTest
@testable import SlowPredicateExpectationExample

class SlowPredicateExpectationExampleTests: XCTestCase {

    /// This test simply establishes that a synchronous test does not pick up the ascyn toggling
    /// behavior.
    func testBaseline() {
        let sut = AsyncWorkPerformer()
        sut.toggleAsynchronousley(after: 0.1)
        XCTAssertFalse(AsyncWorkPerformer().flag)
    }

    // MARK: NSPredicate Examples
    //
    // I decided to copy paste the test implementation rather than DRY it in a method so that each
    // test tells its own story without having to jump between it and an helper method.
    //
    // Also, if all tests were to fail on the same helper method, the follow failure UI would get
    // confusing.

    func testWithPredicate_0_2s() {
        // Arrange SUT
        let sut = AsyncWorkPerformer()
        // Arrange async expectation
        //
        // You could also do this after the "Act" step, if the code read better to you that way.
        let expectation = XCTNSPredicateExpectation(
            predicate: NSPredicate { _, _ in sut.flag },
            object: .none
        )

        // Act
        sut.toggleAsynchronousley(after: 0.1)

        // Assert. Or rather, wait for assertion to be met.
        XCTExpectFailure(strict: true)
        wait(for: [expectation], timeout: 0.2)
    }

    func testWithPredicate_0_4s() {
        let sut = AsyncWorkPerformer()
        let expectation = XCTNSPredicateExpectation(
            predicate: NSPredicate { _, _ in sut.flag },
            object: .none
        )

        sut.toggleAsynchronousley(after: 0.1)

        XCTExpectFailure(strict: true)
        wait(for: [expectation], timeout: 0.4)
    }

    func testWithPredicate_0_8s() {
        let sut = AsyncWorkPerformer()
        let expectation = XCTNSPredicateExpectation(
            predicate: NSPredicate { _, _ in sut.flag },
            object: .none
        )

        sut.toggleAsynchronousley(after: 0.1)

        XCTExpectFailure(strict: true)
        wait(for: [expectation], timeout: 0.8)
    }

    func testWithPredicate_0_9s() {
        let sut = AsyncWorkPerformer()
        let expectation = XCTNSPredicateExpectation(
            predicate: NSPredicate { _, _ in sut.flag },
            object: .none
        )

        sut.toggleAsynchronousley(after: 0.1)

        XCTExpectFailure(strict: true)
        wait(for: [expectation], timeout: 0.9)
    }

    func testWithPredicate_1s() {
        let sut = AsyncWorkPerformer()
        let expectation = XCTNSPredicateExpectation(
            predicate: NSPredicate { _, _ in sut.flag },
            object: .none
        )

        sut.toggleAsynchronousley(after: 0.1)

        XCTExpectFailure(strict: false) // Not strict because this sometimes fails sometimes doesn't
        wait(for: [expectation], timeout: 1)
    }

    func testWithPredicate_1_1s() {
        let sut = AsyncWorkPerformer()
        let expectation = XCTNSPredicateExpectation(
            predicate: NSPredicate { _, _ in sut.flag },
            object: .none
        )

        sut.toggleAsynchronousley(after: 0.1)

        wait(for: [expectation], timeout: 1.1)
    }

    func testWithPredicate_2s() {
        let sut = AsyncWorkPerformer()
        let expectation = XCTNSPredicateExpectation(
            predicate: NSPredicate { _, _ in sut.flag },
            object: .none
        )

        sut.toggleAsynchronousley(after: 0.1)

        wait(for: [expectation], timeout: 2)
    }
}

class AsyncWorkPerformer {

    private(set) var flag = false

    func toggleAsynchronousley(after interval: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) { [weak self] in
            self?.flag.toggle()
        }
    }
}

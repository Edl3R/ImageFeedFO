import XCTest
@testable import ImageFeed

final class ImagesListTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        // Given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsFetchPhotosNextPage() {
        // Given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        presenter.fetchPhotosNextPage()
        
        // Then
        XCTAssertTrue(presenter.didFetchPhotosNextPageCalled)
    }
    
    func testPresenterCallsChangeLike() {
        // Given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenterSpy()
        let indexPath = IndexPath(row: 0, section: 0)
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        presenter.changeLike(at: indexPath)
        
        // Then
        XCTAssertTrue(presenter.didChangeLikeCalled)
    }
    
    func testViewControllerUpdatesTableView() {
        // Given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        viewController.updateTableViewAnimated(oldCount: 0, newCount: 10)
        
        // Then
        XCTAssertTrue(viewController.updateTableViewAnimatedCalled)
    }
}

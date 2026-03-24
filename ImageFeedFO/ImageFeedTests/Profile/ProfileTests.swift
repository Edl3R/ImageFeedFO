import XCTest
@testable import ImageFeed

final class ProfileTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        // Given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsUpdateProfileDetails() {
        // Given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        viewController.updateProfileDetails(
            name: "Test Name",
            loginName: "@testuser",
            bio: "Test Bio"
        )
        
        // Then
        XCTAssertTrue(viewController.updateProfileDetailsCalled)
    }
    
    func testPresenterCallsUpdateAvatar() {
        // Given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenterSpy()
        let testURL = URL(string: "https://example.com/avatar.jpg")!
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        viewController.updateAvatar(url: testURL)
        
        // Then
        XCTAssertTrue(viewController.updateAvatarCalled)
    }
    
    func testPresenterCallsLogout() {
        // Given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        presenter.didTapLogout()
        
        // Then
        XCTAssertTrue(presenter.didTapLogoutCalled)
    }
    
    func testViewControllerShowsLogoutAlert() {
        // Given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        viewController.showLogoutAlert()
        
        // Then
        XCTAssertTrue(viewController.showLogoutAlertCalled)
    }
}

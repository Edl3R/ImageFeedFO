import ImageFeed
import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var didTapLogoutCalled: Bool = false
    var logoutCalled: Bool = false
    var view: ProfileViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didTapLogout() {
        didTapLogoutCalled = true
    }
    
    func logout() {
        logoutCalled = true
    }
    
    func updateProfileDetails() {
        // Mock implementation
    }
    
    func updateAvatar() {
        // Mock implementation
    }
}

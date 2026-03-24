import ImageFeed
import Foundation
import UIKit

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    
    var updateProfileDetailsCalled: Bool = false
    var updateAvatarCalled: Bool = false
    var showLogoutAlertCalled: Bool = false
    
    func updateProfileDetails(name: String, loginName: String, bio: String?) {
        updateProfileDetailsCalled = true
    }
    
    func updateAvatar(url: URL) {
        updateAvatarCalled = true
    }
    
    func showLogoutAlert() {
        showLogoutAlertCalled = true
    }
}

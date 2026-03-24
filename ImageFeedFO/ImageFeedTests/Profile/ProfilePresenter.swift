import Foundation
@testable import ImageFeed

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    
    private let profileService: ProfileService
    private let profileImageService: ProfileImageService
    private let profileLogoutService: ProfileLogoutService
    
    init(
        profileService: ProfileService = .shared,
        profileImageService: ProfileImageService = .shared,
        profileLogoutService: ProfileLogoutService = .shared
    ) {
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.profileLogoutService = profileLogoutService
    }
    
    func viewDidLoad() {
        updateProfileDetails()
        updateAvatar()
    }
    
    func didTapLogout() {
        view?.showLogoutAlert()
    }
    
    func updateProfileDetails() {
        guard let profile = profileService.profile else { return }
        
        view?.updateProfileDetails(
            name: profile.name,
            loginName: profile.loginName,
            bio: profile.bio
        )
    }
    
    func updateAvatar() {
        guard
            let avatarURLString = profileImageService.avatarURL,
            let avatarURL = URL(string: avatarURLString)
        else { return }
        
        view?.updateAvatar(url: avatarURL)
    }
    
    func logout() {
        profileLogoutService.logout()
    }
}

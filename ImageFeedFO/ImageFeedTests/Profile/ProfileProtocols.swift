import Foundation

// MARK: - Profile Protocols

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateProfileDetails(name: String, loginName: String, bio: String?)
    func updateAvatar(url: URL)
    func showLogoutAlert()
}

protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func didTapLogout()
    func logout()
    func updateProfileDetails()
    func updateAvatar()
}

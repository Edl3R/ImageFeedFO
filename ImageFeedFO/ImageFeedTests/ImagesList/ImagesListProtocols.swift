import Foundation
import UIKit

// MARK: - ImagesList Protocols

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    func updateTableViewAnimated(oldCount: Int, newCount: Int)
    func showError(_ error: Error)
}

protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
    func fetchPhotosNextPage()
    func changeLike(at indexPath: IndexPath)
    func getPhotosCount() -> Int
    func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath)
}

@testable import ImageFeed
import Foundation
import UIKit

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var didFetchPhotosNextPageCalled: Bool = false
    var didChangeLikeCalled: Bool = false
    var configuredCellIndexPaths: [IndexPath] = []
    var view: ImagesListViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func fetchPhotosNextPage() {
        didFetchPhotosNextPageCalled = true
    }
    
    func changeLike(at indexPath: IndexPath) {
        didChangeLikeCalled = true
    }
    
    func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        configuredCellIndexPaths.append(indexPath)
    }
    
    func getPhotosCount() -> Int {
        return 0
    }
}

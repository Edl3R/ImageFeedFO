import ImageFeed
import Foundation

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol?
    
    var updateTableViewAnimatedCalled: Bool = false
    var showErrorCalled: Bool = false
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        updateTableViewAnimatedCalled = true
    }
    
    func showError(_ error: Error) {
        showErrorCalled = true
    }
}

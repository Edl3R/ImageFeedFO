import Foundation
import UIKit
@testable import ImageFeed

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    
    private let imagesListService: ImagesListService
    
    init(imagesListService: ImagesListService = .shared) {
        self.imagesListService = imagesListService
    }
    
    func viewDidLoad() {
        subscribeToNotifications()
        fetchPhotosNextPage()
    }
    
    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func changeLike(at indexPath: IndexPath) {
        guard let photo = getPhoto(at: indexPath) else { return }
        
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] (result: Result<Void, Error>) in
            guard let self = self else { return }
            
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success:
                // Notify view to update the cell
                self.view?.updateTableViewAnimated(oldCount: self.getPhotosCount(), newCount: self.getPhotosCount())
            case .failure(let error):
                self.view?.showError(error)
            }
        }
    }
    
    func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        guard let imageListCell = cell as? ImagesListCell,
              let photo = getPhoto(at: indexPath) else { return }
        
        // Configure the cell with photo data
        imageListCell.setIsLiked(photo.isLiked)
        
        // Configure date label if available
        if let createdAt = photo.createdAt {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none
            imageListCell.dateLabel.text = dateFormatter.string(from: createdAt)
        } else {
            imageListCell.dateLabel.text = nil
        }
        
        // Load image (simplified - you might want to use a proper image loading mechanism)
        if let url = URL(string: photo.thumbImageURL) {
            loadImage(from: url, into: imageListCell.cellImage)
        }
    }
    
    func getPhotosCount() -> Int {
        return imagesListService.photos.count
    }
    
    func getPhoto(at indexPath: IndexPath) -> Photo? {
        guard indexPath.row < imagesListService.photos.count else { return nil }
        return imagesListService.photos[indexPath.row]
    }
    
    // MARK: - Private Methods
    
    private func subscribeToNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTableViewAnimated),
            name: ImagesListService.didChangeNotification,
            object: nil
        )
    }
    
    @objc private func updateTableViewAnimated() {
        let oldCount = getPhotosCount()
        let newCount = imagesListService.photos.count
        view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
    }
    
    private func loadImage(from url: URL, into imageView: UIImageView) {
        // Simple image loading - in production you'd use a proper image loading library
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                imageView.image = image
            }
        }.resume()
    }
}

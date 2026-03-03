import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!

    var photo: Photo? {
        didSet {
            guard isViewLoaded else { return }
            loadImage()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScrollView()
        loadImage()
    }

    @IBAction private func didTapShareButton(_ sender: UIButton) {
        guard let image = imageView.image else { return }

        let activityVC = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(activityVC, animated: true)
    }

    @IBAction private func didTapBackButton() {
        dismiss(animated: true)
    }

    private func configureScrollView() {
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        scrollView.delegate = self
    }

    private func loadImage() {
        guard
            let photo = photo,
            let url = URL(string: photo.largeImageURL)
        else { return }
        
        imageView.kf.indicatorType = .activity
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: url) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }

            if case .success(let value) = result {
                self.imageView.frame.size = value.image.size
                self.rescaleAndCenterImage(value.image)
            }
        }
    }

    private func rescaleAndCenterImage(_ image: UIImage) {
        view.layoutIfNeeded()

        let visibleSize = scrollView.bounds.size
        let imageSize = image.size

        let widthScale = visibleSize.width / imageSize.width
        let heightScale = visibleSize.height / imageSize.height
        let scale = min(
            scrollView.maximumZoomScale,
            max(scrollView.minimumZoomScale, min(widthScale, heightScale))
        )

        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()

        let contentSize = scrollView.contentSize
        let offsetX = (contentSize.width - visibleSize.width) / 2
        let offsetY = (contentSize.height - visibleSize.height) / 2

        scrollView.setContentOffset(CGPoint(x: offsetX, y: offsetY), animated: false)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}

@testable import ImageFeed
import XCTest

@MainActor
final class WebViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadRequest() async {
        let viewController = WebViewViewControllerSpy()
        let authHelper = await MainActor.run { AuthHelper() }
        let presenter = WebViewPresenter(authHelper: authHelper)
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(viewController.loadRequestCalled)
    }
    
    func testProgressVisibleWhenLessThenOne() async {
        let authHelper = await MainActor.run { AuthHelper() }
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        
        let sholdHideProgress = presenter.shouldHideProgress(for: progress)
        
        XCTAssertFalse(sholdHideProgress)
    }
    
    func testProgressHiddenWhenOne() async {
        let authHelper = await MainActor.run { AuthHelper() }
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1
        
        let sholdHideProgress = presenter.shouldHideProgress(for: progress)
        
        XCTAssertTrue(sholdHideProgress)
    }
    
    func testAuthHelperAuthURL() async {
        
        let configuration = AuthConfiguration.standard
        let authHelper = await MainActor.run { AuthHelper(configuration: configuration) }
        
        let url = authHelper.authURL()
        guard let urlString = url?.absoluteString else {
            XCTFail("Авторизационная ссылка собрана неверно")
            return
        }
        
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }
    
    func testCodeFromURL() async {
        //given
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
        urlComponents.queryItems = [URLQueryItem(name: "code", value: "test code")]
        let url = urlComponents.url!
        let authHelper = await MainActor.run { AuthHelper() }
        
        //when
        let code = authHelper.code(from: url)
        
        //then
        XCTAssertEqual(code, "test code")
    } 
}


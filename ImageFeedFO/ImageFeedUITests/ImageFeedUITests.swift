import XCTest

// MARK: - Extension для принудительного тапа
extension XCUIElement {
    func forceTap() {
        self.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
    }
}

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication() // переменная приложения
    
    override func setUpWithError() throws {
        continueAfterFailure = false // прекращаем выполнение, если что-то пошло не так
        app.launch() // запускаем приложение перед каждым тестом
    }
    
    // MARK: - Tests
    
    func testAuth() throws {
        // Проверяем, авторизованы ли мы уже. Если да — разлогиниваемся.
        if !app.buttons["Authenticate"].exists {
            app.tabBars.buttons.element(boundBy: 1).tap()
            
            let logoutButton = app.buttons["Logout Button"]
            XCTAssertTrue(logoutButton.waitForExistence(timeout: 5))
            logoutButton.tap()
            
            app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
            
            // Ждем, пока не вернемся на экран с кнопкой авторизации
            XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 5))
        }
        
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 10))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 10))
        
        loginTextField.tap()
        loginTextField.typeText("") // логин
        webView.swipeUp()
        hideKeyboard()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 10))
        
        passwordTextField.tap()
        passwordTextField.typeText("") // пароль
        webView.swipeUp()
        hideKeyboard()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
        app.swipeUp()
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        XCTAssertTrue(cellToLike.waitForExistence(timeout: 5))
        
        let likeButton = cellToLike.buttons["No Active"]
        XCTAssertTrue(likeButton.waitForExistence(timeout: 5))
        likeButton.forceTap()
        
        sleep(1)
        
        let activeLikeButton = cellToLike.buttons["Active"]
        XCTAssertTrue(activeLikeButton.waitForExistence(timeout: 5))
        activeLikeButton.forceTap()
        
        sleep(1)
        
        cellToLike.forceTap()
        
        let image = app.scrollViews.images.element(boundBy: 0)
        XCTAssertTrue(image.waitForExistence(timeout: 5))
        
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["Backward"]
        XCTAssertTrue(navBackButtonWhiteButton.waitForExistence(timeout: 5))
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        let cell = app.tables.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["Name Label"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Login Name Label"].exists)
        
        let logoutButton = app.buttons["Logout Button"]
        XCTAssertTrue(logoutButton.waitForExistence(timeout: 5))
        logoutButton.tap()
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
        
        XCTAssertTrue(app.buttons["Authenticate"].waitForExistence(timeout: 5))
    }
    
    // MARK: - Helpers
    
    func hideKeyboard() {
        let app = XCUIApplication()
        let doneButton = app.buttons["Done"]
        let returnButton = app.buttons["Return"]
        let goButton = app.buttons["Go"]
        
        if doneButton.exists {
            doneButton.tap()
        } else if returnButton.exists {
            returnButton.tap()
        } else if goButton.exists {
            goButton.tap()
        } else {
            let webView = app.webViews["UnsplashWebView"]
            if webView.exists {
                webView.coordinate(withNormalizedOffset: CGVector(dx: 0.1, dy: 0.1)).tap()
            } else {
                app.swipeDown()
            }
        }
    }
}

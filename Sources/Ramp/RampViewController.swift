import UIKit
import WebKit

public final class RampViewController: UIViewController {
    private let url: URL
    
    private weak var webView: WKWebView!
    private weak var stackView: UIStackView!
    private var contentController: WKUserContentController {
        webView.configuration.userContentController
    }
    
    public weak var delegate: RampDelegate?
    
    // MARK: Lifecycle
    
    public init(configuration: Configuration) throws {
        self.url = try configuration.buildUrl()
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    public override func loadView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        view = stackView
        self.stackView = stackView
        
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.uiDelegate = self
        stackView.addArrangedSubview(webView)
        self.webView = webView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        subscribeMessageHandler()
        setupSwipeBackGesture()
        Logger.debug("Loading URL: \(url.absoluteString)")
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    deinit {
        unsubscribeMessageHandler()
    }
    
    // MARK: Actions
    
    private func setupSwipeBackGesture() {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipeBackGesture))
        gesture.edges = .left
        webView.addGestureRecognizer(gesture)
    }
    
    @objc private func handleSwipeBackGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        let view = sender.view!
        let deltaX = sender.translation(in: view).x
        guard sender.state == .ended else {
            return
        }
        let fraction = abs(deltaX / view.bounds.width)
        if fraction >= 0.27 {
            sendOutgoingEvent(.backButtonPressed)
        }
    }
    
    private func showCloseAlert() {
        let alert = UIAlertController(title: Localizable.closeAlertTitle,
                                      message: Localizable.closeAlertMessage,
                                      preferredStyle: .alert)
        alert.view.tintColor = .rampColor
        let yesAction = UIAlertAction(title: Localizable.yes, style: .destructive) { [unowned self] _
            in self.closeRamp()
        }
        let noAction = UIAlertAction(title: Localizable.no, style: .cancel)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true)
    }
    
    private func closeRamp() {
        presentingViewController?.dismiss(animated: true) { [unowned self] in
            self.delegate?.rampDidClose(self)
        }
    }
    
    // MARK: Message handling
    
    private func subscribeMessageHandler() {
        let handler = ScriptMessageHandler()
        handler.delegate = self
        contentController.add(handler, name: Constants.scriptMessageHandlerName)
    }
    
    private func unsubscribeMessageHandler() {
        contentController.removeScriptMessageHandler(forName: Constants.scriptMessageHandlerName)
    }
    
    private func sendOutgoingEvent(_ event: OutgoingEvent) {
        let message: String
        do {
            message = try event.messagePayload()
        } catch {
            Logger.error(error)
            return
        }
        let script = "window.postMessage(\(message);"
        webView.evaluateJavaScript(script) { _, _ in }
    }
    
    private func handleIncomingEvent(_ event: IncomingEvent) {
        switch event {
        case .onrampPurchaseCreated(let payload): handleOnrampPurchaseCreatedEvent(payload)
        case .widgetClose(let payload): handleWidgetCloseEvent(payload)
        case .sendCrypto(let payload): handleSendCryptoEvent(payload)
        case .offrampSaleCreated(let payload): handleOfframpSaleCreatedEvent(payload)
        }
    }
    
    private func handleOnrampPurchaseCreatedEvent(_ payload: OnrampPurchaseCreatedPayload) {
        delegate?.ramp(self, didCreateOnrampPurchase: payload.purchase, payload.purchaseViewToken, payload.apiUrl)
    }
    
    private func handleWidgetCloseEvent(_ payload: WidgetClosePayload) {
        if payload.showAlert {
            showCloseAlert()
        } else {
            closeRamp()
        }
    }
    
    private func handleSendCryptoEvent(_ payload: SendCryptoPayload) {
        delegate?.ramp(self, didRequestSendCrypto: payload) { resultPayload in
            let event: OutgoingEvent = .sendCryptoResult(resultPayload)
            self.sendOutgoingEvent(event)
        }
    }
    
    private func handleOfframpSaleCreatedEvent(_ payload: OfframpSaleCreatedPayload) {
        delegate?.ramp(self, didCreateOfframpSale: payload.sale, payload.saleViewToken, payload.apiUrl)
    }
}

extension RampViewController: WKUIDelegate {
    public func webView(_ webView: WKWebView,
                        createWebViewWith configuration: WKWebViewConfiguration,
                        for navigationAction: WKNavigationAction,
                        windowFeatures: WKWindowFeatures) -> WKWebView? {
        let app = UIApplication.shared
        if let navigationUrl = navigationAction.request.url,
           app.canOpenURL(navigationUrl) {
            app.open(navigationUrl)
        }
        return nil
    }
}

extension RampViewController: ScriptMessageDelegate {
    func handler(_ scriptMessageHandler: ScriptMessageHandler, didReceiveMessage body: [String : Any]) {
        let event: IncomingEvent
        do {
            event = try IncomingEvent(dictionary: body)
        } catch {
            Logger.error(error)
            return
        }
        handleIncomingEvent(event)
    }
}

private extension UIColor {
    static var rampColor: UIColor {
        UIColor(red: 19/255.0, green: 159/255.0, blue: 106/255.0, alpha: 1)
    }
}

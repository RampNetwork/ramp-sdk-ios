import UIKit
import WebKit
import Passbase

public final class RampViewController: UIViewController {
    private let url: URL

    private weak var webView: WKWebView!
    private weak var stackView: UIStackView!
    private var contentController: WKUserContentController { webView.configuration.userContentController }
    
    public weak var delegate: RampDelegate?
    
    // MARK: Lifecycle
    
    public init(configuration: Configuration) throws {
        self.url = try configuration.buildUrl()
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    public override func loadView() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        view = stackView
        self.stackView = stackView
        
        let configuration = WKWebViewConfiguration()
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
        guard sender.state == .ended else { return }
        let fraction = abs(deltaX / view.bounds.width)
        if fraction >= 0.27 { sendOutgoingEvent(.backButtonPressed) }
    }
    
    private func showCloseAlert() {
        let alert = UIAlertController(title: Constants.closeAlertTitle,
                                      message: Constants.closeAlertMessage, preferredStyle: .alert)
        alert.view.tintColor = Constants.rampColor
        let yesAction = UIAlertAction(title: Constants.closeAlertYesAction, style: .destructive) { [unowned self]  _ in
            self.closeRamp()
        }
        let noAction = UIAlertAction(title: Constants.closeAlertNoAction, style: .cancel)
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
        guard let message = try? event.messagePayload() else { return }
        let script = Constants.postMessageScript(message)
        webView.evaluateJavaScript(script) { _, _ in }
    }
    
    private func handleIncomingEvent(_ event: IncomingEvent) {
        switch event {
        case .kycInit(let payload): startPassbaseFlow(payload)
        case .purchaseCreated(let payload):
            delegate?.ramp(self, didCreatePurchase: payload.purchase,
                           purchaseViewToken: payload.purchaseViewToken, apiUrl: payload.apiUrl)
        case .purchaseFailed: delegate?.rampPurchaseDidFail(self)
        case .widgetClose(let payload): handleCloseRampEvent(payload)
        }
    }
    
    private func handleCloseRampEvent(_ payload: WidgetClosePayload) {
        if payload.showAlert { showCloseAlert() }
        else { closeRamp() }
    }
    
    // MARK: Passbase actions
    
    private var verificationId: Int?
    
    private func startPassbaseFlow(_ payload: KycInitPayload) {
        verificationId = payload.verificationId
        
        PassbaseSDK.initialize(publishableApiKey: payload.apiKey)
        PassbaseSDK.prefillUserEmail = payload.email
        PassbaseSDK.prefillCountry = payload.countryCode
        PassbaseSDK.metaData = payload.metaData
        PassbaseSDK.delegate = self
        
        DispatchQueue.main.async {
            try? PassbaseSDK.startVerification(from: self)
        }
    }
    
    // MARK: Passbase outgoing events
    
    private func handlePassbaseStarted() {
        guard let verificationId = verificationId else { return }
        let payload = KycStartedPayload(verificationId: verificationId)
        let event: OutgoingEvent = .kycStarted(payload)
        sendOutgoingEvent(event)
    }
    
    private func handlePassbaseSubmitted(identityAccessKey: String) {
        guard let verificationId = verificationId else { return }
        let payload = KycSubmittedPayload(verificationId: verificationId, identityAccessKey: identityAccessKey)
        let event: OutgoingEvent = .kycSubmitted(payload)
        sendOutgoingEvent(event)
    }
    
    private func handlePassbaseSuccess(identityAccessKey: String) {
        guard let verificationId = verificationId else { return }
        let payload = KycSuccessPayload(verificationId: verificationId, identityAccessKey: identityAccessKey)
        let event: OutgoingEvent = .kycSuccess(payload)
        sendOutgoingEvent(event)
    }
    
    private func handlePassbaseAborted() {
        guard let verificationId = verificationId else { return }
        let payload = KycAbortedPayload(verificationId: verificationId)
        let event: OutgoingEvent = .kycAborted(payload)
        sendOutgoingEvent(event)
    }
    
    private func handlePassbaseError() {
        guard let verificationId = verificationId else { return }
        let payload = KycErrorPayload(verificationId: verificationId)
        let event: OutgoingEvent = .kycError(payload)
        sendOutgoingEvent(event)
    }
}

extension RampViewController: WKUIDelegate {
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        let app = UIApplication.shared
        if let navigationUrl = navigationAction.request.url, app.canOpenURL(navigationUrl) { app.open(navigationUrl) }
        return nil
    }
}

extension RampViewController {
    public enum Error: Swift.Error {
        case closeRampFailed
        case serializeOutgoingEventFailed
        case missingKycVerificationId
        case unableToOpenUrl
        case deserializeIncomingEventFailed
        case messaveEventReceiveFailed
        case unknownPassbaseError
    }
}

extension RampViewController: ScriptMessageDelegate {
    func handler(_ scriptMessageHandler: ScriptMessageHandler, didReceiveMessage body: [String : Any]) {
        guard let event = try? IncomingEvent(dictionary: body) else { return }
        handleIncomingEvent(event)
    }
}

// MARK: - Passbase delegate

/// Documentation: https://docs.passbase.com/ios#4-handling-verifications
extension RampViewController: PassbaseDelegate {
    public func onStart() {
        handlePassbaseStarted()
    }
    
    public func onSubmitted(identityAccessKey: String) {
        handlePassbaseSubmitted(identityAccessKey: identityAccessKey)
    }
    
    public func onFinish(identityAccessKey: String) {
        handlePassbaseSuccess(identityAccessKey: identityAccessKey)
    }
    
    public func onError(errorCode: String) {
        guard let error = PassbaseError(rawValue: errorCode) else { return }
        switch error {
        case .cancelledByUser: handlePassbaseAborted()
        case .biometricAuthenticationFailed: handlePassbaseError()
        }
    }
}

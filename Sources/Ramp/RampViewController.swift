import UIKit
import WebKit
import Passbase

public final class RampViewController: UIViewController {
    private let scriptMessageHandlerName: String = "RampInstantMobile"
    private let defaultPassbaseApiKey: String = "9275d00a4d7fced8b6898b5ea59409e02183a3422c7ed095ec9e81e8898480ce"
    private let url: URL
    
    private var rampColor: UIColor { UIColor(red: 19/255.0, green: 159/255.0, blue: 106/255.0, alpha: 1) }

    private weak var webView: WKWebView!
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
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        view = verticalStackView
        
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        self.webView = webView
        verticalStackView.addArrangedSubview(webView)
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.uiDelegate = self
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        subscribeMessageHandler()
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    deinit {
        unsubscribeMessageHandler()
    }
    
    private func showCloseAlert() {
        let title = "Do you really want to close Ramp?"
        let message = "You will loose all progress and will have to start over"
        let yesTitle = "Yes, close"
        let noTitle = "No, continue"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = rampColor
        let yesAction = UIAlertAction(title: yesTitle, style: .destructive) { [unowned self]  _ in
            self.closeRamp()
        }
        let noAction = UIAlertAction(title: noTitle, style: .cancel)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true)
    }
    
    private func closeRamp() {
        guard let presentingViewController = presentingViewController
        else {
            delegate?.ramp(self, didRaiseError: Error.closeRampFailed)
            return
        }
        presentingViewController.dismiss(animated: true) { [unowned self] in
            self.delegate?.rampDidClose(self)
        }
    }
    
    // MARK: Message handling
        
    private func subscribeMessageHandler() {
        let handler = ScriptMessageHandler()
        handler.delegate = self
        contentController.add(handler, name: scriptMessageHandlerName)
    }
    
    private func unsubscribeMessageHandler() {
        contentController.removeScriptMessageHandler(forName: scriptMessageHandlerName)
    }
    
    private func sendOutgoingEvent(_ event: OutgoingEvent) {
        let message: String
        do { message = try event.messagePayload() }
        catch {
            delegate?.ramp(self, didRaiseError: Error.serializeOutgoingEventFailed)
            return
        }
        let script = "window.postMessage(\(message));"
        webView.evaluateJavaScript(script) { [weak self] response, error in
            if let error = error, let self = self {
                self.delegate?.ramp(self, didRaiseError: error)
            }
        }
    }
    
    private func handleIncomingEvent(_ event: IncomingEvent) {
        switch event {
        case .kycInit(let payload): startPassbaseFlow(payload)
        case .purchaseCreated(let payload): delegate?.ramp(self, didCreatePurchase: payload.rampPurchase)
        case .purchaseFailed: delegate?.rampPurchaseDidFail(self)
        case .widgetClose(let payload): handleCloseRampEvent(payload)
        default: break
        }
    }
    
    private func handleCloseRampEvent(_ payload: WidgetClosePayload) {
        if payload.showAlert {
            showCloseAlert()
        }
        else {
            closeRamp()
        }
    }
    
    // MARK: Passbase actions
    
    private var verificationId: Int?
    
    private func startPassbaseFlow(_ payload: KycInitPayload) {
        let apiKey = payload.apiKey ?? defaultPassbaseApiKey
        verificationId = payload.verificationId
        
        PassbaseSDK.initialize(publishableApiKey: apiKey)
        PassbaseSDK.prefillUserEmail = payload.email
        PassbaseSDK.prefillCountry = payload.countryCode
        PassbaseSDK.metaData = payload.metaData
        PassbaseSDK.delegate = self
        
        // Hacky way to present Passbase view
        let passbaseButton = PassbaseButton(frame: .zero)
        view.addSubview(passbaseButton)
        passbaseButton.sendActions(for: .touchUpInside)
        passbaseButton.removeFromSuperview()
    }
    
    // MARK: Passbase outgoing events
    
    private func handlePassbaseStarted() {
        guard let verificationId = verificationId
        else {
            delegate?.ramp(self, didRaiseError: Error.missingKycVerificationId)
            return
        }
        let payload = KycStartedPayload(verificationId: verificationId)
        let event: OutgoingEvent = .kycStarted(payload)
        sendOutgoingEvent(event)
    }
    
    private func handlePassbaseSubmitted(identityAccessKey: String) {
        guard let verificationId = verificationId
        else {
            delegate?.ramp(self, didRaiseError: Error.missingKycVerificationId)
            return
        }
        let payload = KycSubmittedPayload(verificationId: verificationId, identityAccessKey: identityAccessKey)
        let event: OutgoingEvent = .kycSubmitted(payload)
        sendOutgoingEvent(event)
    }
    
    private func handlePassbaseSuccess(identityAccessKey: String) {
        guard let verificationId = verificationId
        else {
            delegate?.ramp(self, didRaiseError: Error.missingKycVerificationId)
            return
        }
        let payload = KycSuccessPayload(verificationId: verificationId, identityAccessKey: identityAccessKey)
        let event: OutgoingEvent = .kycSuccess(payload)
        sendOutgoingEvent(event)
    }
    
    private func handlePassbaseAborted() {
        guard let verificationId = verificationId
        else {
            delegate?.ramp(self, didRaiseError: Error.missingKycVerificationId)
            return
        }
        let payload = KycAbortedPayload(verificationId: verificationId)
        let event: OutgoingEvent = .kycAborted(payload)
        sendOutgoingEvent(event)
    }
    
    private func handlePassbaseError() {
        guard let verificationId = verificationId
        else {
            delegate?.ramp(self, didRaiseError: Error.missingKycVerificationId)
            return
        }
        let payload = KycErrorPayload(verificationId: verificationId)
        let event: OutgoingEvent = .kycError(payload)
        sendOutgoingEvent(event)
    }
}

extension RampViewController: WKUIDelegate {
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        let app = UIApplication.shared
        if let navigationUrl = navigationAction.request.url, app.canOpenURL(navigationUrl) {
            app.open(navigationUrl)
        }
        else {
            delegate?.ramp(self, didRaiseError: Error.unableToOpenUrl)
        }
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
        let event: IncomingEvent
        do { event = try IncomingEvent(dictionary: body) }
        catch {
            delegate?.ramp(self, didRaiseError: Error.deserializeIncomingEventFailed)
            return
        }
        handleIncomingEvent(event)
    }
    
    func handler(_ scriptMessageHandler: ScriptMessageHandler, didFailToReceiveMessage body: Any) {
        delegate?.ramp(self, didRaiseError: Error.messaveEventReceiveFailed)
    }
}

/// Documentation: https://docs.passbase.com/ios#4-handling-verifications
extension RampViewController: PassbaseDelegate {
    private enum PassbaseError: String {
        case cancelledByUser = "CANCELLED_BY_USER"
        case biometricAuthenticationFailed = "BIOMETRIC_AUTHENTICATION_FAILED"
    }

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
        guard let error = PassbaseError(rawValue: errorCode)
        else {
            delegate?.ramp(self, didRaiseError: Error.unknownPassbaseError)
            return
        }
        switch error {
        case .cancelledByUser: handlePassbaseAborted()
        case .biometricAuthenticationFailed: handlePassbaseError()
        }
    }
}

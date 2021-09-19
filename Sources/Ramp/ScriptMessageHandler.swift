import WebKit

protocol ScriptMessageDelegate: AnyObject {
    func handler(_ scriptMessageHandler: ScriptMessageHandler, didReceiveMessage body: [String: Any])
}

class ScriptMessageHandler: NSObject {
    weak var delegate: ScriptMessageDelegate?
}

extension ScriptMessageHandler: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let body = message.body as? [String: Any] else { return }
        delegate?.handler(self, didReceiveMessage: body)
    }
}

import WebKit

protocol ScriptMessageDelegate: AnyObject {
    func handler(_ scriptMessageHandler: ScriptMessageHandler, didReceiveMessage body: [String: Any])
    func handler(_ scriptMessageHandler: ScriptMessageHandler, didFailToReceiveMessage body: Any)
}

class ScriptMessageHandler: NSObject {
    weak var delegate: ScriptMessageDelegate?
}

extension ScriptMessageHandler: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let body = message.body as? [String: Any] { delegate?.handler(self, didReceiveMessage: body) }
        else { delegate?.handler(self, didFailToReceiveMessage: message.body) }
    }
}

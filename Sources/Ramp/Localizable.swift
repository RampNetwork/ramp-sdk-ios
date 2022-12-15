import Foundation

struct Localizable {
    static var closeAlertTitle: String {
        NSLocalizedString("Do you really want to close Ramp?",
                          comment: "Alert title for closing Ramp")
    }
    static var closeAlertMessage: String {
        NSLocalizedString("You will loose all progress and will have to start over",
                          comment: "Alert message for closing Ramp")
    }
    static var yes: String { NSLocalizedString("Yes", comment: "Yes") }
    static var no: String { NSLocalizedString("No", comment: "No") }
}

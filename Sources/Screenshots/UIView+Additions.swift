import Foundation
import UIKit

extension UIView {
    func screenshotForCroppingRect(croppingRect: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(croppingRect.size, false, UIScreen.main.scale)

        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        context.translateBy(x: -croppingRect.origin.x, y: -croppingRect.origin.y)
        self.layoutIfNeeded()
        self.layer.render(in: context!)

        let screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenshotImage
    }

    @objc public var screenshot: UIImage? {
        return self.screenshotForCroppingRect(croppingRect: self.bounds)
    }
}

import Foundation
import UIKit

extension UIImage {


    /// Given a Color and a Size, this function creates a new Image
    /// ~~~
    /// UIImage.imageWithColor(color: .black, size: CGSize(width: 50,height: 50))
    /// ~~~
    /// - Warning: If the function cannot instantiate a Graphics Context, the return value is nil
    /// - Parameters:
    ///   - color: The color to fill the image
    ///   - size: The size for this image
    /// - Returns: An image filled with the given color
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        color.set()
        context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIImage {

    /// Given a list of images, this methods adds their height and find the max width.
    /// ~~~
    /// let imagesArray: [UIImage] = […]
    /// let fullSize: CGSize = UIImage.verticalAppendedTotalImageSizeFromImagesArray(imagesArray: imagesArray)
    /// ~~~
    /// - Parameter imagesArray: The list of images to proccess
    /// - Returns: the added height of all the image by the biggest width in a CGSize struct
    class func verticalAppendedTotalImageSizeFromImagesArray(imagesArray: [UIImage]) -> CGSize {
        var totalSize = CGSize.zero
        for image in imagesArray {
            let imSize = image.size
            totalSize.height += imSize.height
            totalSize.width = max(totalSize.width, imSize.width)
        }
        return totalSize
    }

    /// Stitches verticaly all the images in the collection passed on. With the first on top an so on.
    /// ~~~
    /// let imagesArray: [UIImage] = […]
    /// let newImage: UIImage = UIImage.verticalImageFromArray(imagesArray: imagesArray)
    /// ~~~
    /// - Warning: If the function cannot instantiate a Graphics Context, the return value is nil
    /// - Parameter imagesArray: The list of images to proccess
    /// - Returns: a new image containing all the elementes from the collection passed
    class func verticalImageFromArray(imagesArray: [UIImage]) -> UIImage? {

        var unifiedImage: UIImage?
        let totalImageSize = self.verticalAppendedTotalImageSizeFromImagesArray(imagesArray: imagesArray)

        UIGraphicsBeginImageContextWithOptions(totalImageSize, false, 0)

        var imageOffsetFactor: CGFloat = 0

        for image in imagesArray {
            image.draw(at: CGPoint(x: 0, y: imageOffsetFactor))
            imageOffsetFactor += image.size.height
        }
        unifiedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return unifiedImage
    }
}

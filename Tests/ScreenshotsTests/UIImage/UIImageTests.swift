//
//  File.swift
//  
//
//  Created by Iván GalazJeria on 12-10-20.
//

import XCTest
@testable import Screenshots

final class UIImageTests: XCTestCase {
    
    func testImageWithColorReturnCorrectColorAndSize() {
        // Given
        let width: CGFloat = 50
        let height: CGFloat = 100
        // When
        let image = UIImage.imageWithColor(color: .black, size: CGSize(width: width, height: height))
        // Then
        XCTAssertNotNil(image)
        XCTAssertEqual(image!.size.width, width, "The image have to have the expected width")
        XCTAssertEqual(image!.size.height, height, "The image have to have the expected height")
    }

    func testImageCorrectlyCalculateMaxWidhAndHeightForAListOfImages() {
        // Given
        let sizeA = CGSize(width: 20, height: 30)
        let imageA = UIImage.imageWithColor(color: .blue, size: sizeA)
        let sizeB = CGSize(width: 40, height: 60)
        let imageB = UIImage.imageWithColor(color: .blue, size: sizeB)
        let sizeC = CGSize(width: 20, height: 35)
        let imageC = UIImage.imageWithColor(color: .blue, size: sizeC)
        let images = [imageA!, imageB!, imageC!]
        let fullHeight = sizeA.height + sizeB.height + sizeC.height
        let maxWidth: CGFloat = 40
        // When
        let fullSize = UIImage.verticalAppendedTotalImageSizeFromImagesArray(imagesArray: images)
        // Then
        XCTAssertEqual(fullSize.height, fullHeight, "The returned height should be equal to the sum of all the images height")
        XCTAssertEqual(fullSize.width, maxWidth, "The returned width should be the widest from the list")

    }

    func testCreatesAnImageWithTheGivenList() {
        // Given
        let sizeA = CGSize(width: 20, height: 30)
        let imageA = UIImage.imageWithColor(color: .blue, size: sizeA)
        let sizeB = CGSize(width: 40, height: 60)
        let imageB = UIImage.imageWithColor(color: .green, size: sizeB)
        let sizeC = CGSize(width: 20, height: 35)
        let imageC = UIImage.imageWithColor(color: .red, size: sizeC)
        let images = [imageA!, imageB!, imageC!]
        let fullHeight = sizeA.height + sizeB.height + sizeC.height
        let maxWidth: CGFloat = 40
        // When
        let image = UIImage.verticalImageFromArray(imagesArray: images)
        // Then
        XCTAssertNotNil(image, "An image should have been created")
        XCTAssertEqual(image?.size.height, fullHeight, "The returned image height should be equal to the sum of all the images height")
        XCTAssertEqual(image?.size.width, maxWidth, "The returned image width should be the widest from the list")

        XCTAssertEqual(image?.pixelColor(x: 5, y: 5), imageA?.pixelColor(x: 5, y: 5), "This first part should be blue")
        XCTAssertEqual(image?.pixelColor(x: 0, y: 60), imageB?.pixelColor(x: 5, y: 5), "This part should be green")
        if let fullHeight = image?.cgImage?.height {
            XCTAssertEqual(image?.pixelColor(x: 5, y: fullHeight - 5), imageC?.pixelColor(x: 5, y: 5), "This part should be red")
        }
    }
    static var allTests = [
        ("testImageCorrectlyCalculateMaxWidhAndHeightForAListOfImages", testImageCorrectlyCalculateMaxWidhAndHeightForAListOfImages),
        ("testImageCorrectlyCalculateMaxWidhAndHeightForAListOfImages", testImageCorrectlyCalculateMaxWidhAndHeightForAListOfImages),
        ("testCreatesAnImageWithTheGivenList", testCreatesAnImageWithTheGivenList)
    ]
}

public extension UIImage {

    var pixelWidth: Int {
        return cgImage?.width ?? 0
    }

    var pixelHeight: Int {
        return cgImage?.height ?? 0
    }

    func pixelColor(x: Int, y: Int) -> UIColor {
        assert(
            0..<pixelWidth ~= x && 0..<pixelHeight ~= y,
            "Pixel coordinates are out of bounds")

        guard
            let cgImage = cgImage,
            let data = cgImage.dataProvider?.data,
            let dataPtr = CFDataGetBytePtr(data),
            let colorSpaceModel = cgImage.colorSpace?.model,
            let componentLayout = cgImage.bitmapInfo.componentLayout
        else {
            assertionFailure("Could not get the color of a pixel in an image")
            return .clear
        }

        assert(
            colorSpaceModel == .rgb,
            "The only supported color space model is RGB")
        assert(
            cgImage.bitsPerPixel == 32 || cgImage.bitsPerPixel == 24,
            "A pixel is expected to be either 4 or 3 bytes in size")

        let bytesPerRow = cgImage.bytesPerRow
        let bytesPerPixel = cgImage.bitsPerPixel/8
        let pixelOffset = y*bytesPerRow + x*bytesPerPixel

        if componentLayout.count == 4 {
            let components = (
                dataPtr[pixelOffset + 0],
                dataPtr[pixelOffset + 1],
                dataPtr[pixelOffset + 2],
                dataPtr[pixelOffset + 3]
            )

            var alpha: UInt8 = 0
            var red: UInt8 = 0
            var green: UInt8 = 0
            var blue: UInt8 = 0

            switch componentLayout {
            case .bgra:
                alpha = components.3
                red = components.2
                green = components.1
                blue = components.0
            case .abgr:
                alpha = components.0
                red = components.3
                green = components.2
                blue = components.1
            case .argb:
                alpha = components.0
                red = components.1
                green = components.2
                blue = components.3
            case .rgba:
                alpha = components.3
                red = components.0
                green = components.1
                blue = components.2
            default:
                return .clear
            }

            // If chroma components are premultiplied by alpha and the alpha is `0`,
            // keep the chroma components to their current values.
            if cgImage.bitmapInfo.chromaIsPremultipliedByAlpha && alpha != 0 {
                let invUnitAlpha = 255/CGFloat(alpha)
                red = UInt8((CGFloat(red)*invUnitAlpha).rounded())
                green = UInt8((CGFloat(green)*invUnitAlpha).rounded())
                blue = UInt8((CGFloat(blue)*invUnitAlpha).rounded())
            }

            return .init(red: red, green: green, blue: blue, alpha: alpha)

        } else if componentLayout.count == 3 {
            let components = (
                dataPtr[pixelOffset + 0],
                dataPtr[pixelOffset + 1],
                dataPtr[pixelOffset + 2]
            )

            var red: UInt8 = 0
            var green: UInt8 = 0
            var blue: UInt8 = 0

            switch componentLayout {
            case .bgr:
                red = components.2
                green = components.1
                blue = components.0
            case .rgb:
                red = components.0
                green = components.1
                blue = components.2
            default:
                return .clear
            }

            return .init(red: red, green: green, blue: blue, alpha: UInt8(255))

        } else {
            assertionFailure("Unsupported number of pixel components")
            return .clear
        }
    }

}

public extension UIColor {

    convenience init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        self.init(
            red: CGFloat(red)/255,
            green: CGFloat(green)/255,
            blue: CGFloat(blue)/255,
            alpha: CGFloat(alpha)/255)
    }

}

public extension CGBitmapInfo {

    enum ComponentLayout {

        case bgra
        case abgr
        case argb
        case rgba
        case bgr
        case rgb

        var count: Int {
            switch self {
            case .bgr, .rgb: return 3
            default: return 4
            }
        }

    }

    var componentLayout: ComponentLayout? {
        guard let alphaInfo = CGImageAlphaInfo(rawValue: rawValue & Self.alphaInfoMask.rawValue) else { return nil }
        let isLittleEndian = contains(.byteOrder32Little)

        if alphaInfo == .none {
            return isLittleEndian ? .bgr : .rgb
        }
        let alphaIsFirst = alphaInfo == .premultipliedFirst || alphaInfo == .first || alphaInfo == .noneSkipFirst

        if isLittleEndian {
            return alphaIsFirst ? .bgra : .abgr
        } else {
            return alphaIsFirst ? .argb : .rgba
        }
    }

    var chromaIsPremultipliedByAlpha: Bool {
        let alphaInfo = CGImageAlphaInfo(rawValue: rawValue & Self.alphaInfoMask.rawValue)
        return alphaInfo == .premultipliedFirst || alphaInfo == .premultipliedLast
    }

}

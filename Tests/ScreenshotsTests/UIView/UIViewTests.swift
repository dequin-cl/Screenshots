//
//  File.swift
//  
//
//  Created by Iván GalazJeria on 12-10-20.
//

import XCTest
@testable import Screenshots

final class UIViewTests: XCTestCase {
    
    func testScreenshotIsEqualToViewContent() {
        //Given
        let view = UIView(frame: CGRect(origin: .zero,
                                        size: CGSize(width: 264,
                                                     height: 264)))
        let image = UIImage.imageWithColor(color: .red, size: CGSize(width: 264,
                                                                     height: 264))
        let imageView = UIImageView(image: image)
        view.addSubview(imageView)
        //When
        let screenshots = view.screenshot
        //Then
        let data1 = image?.pngData()
        let data2 = screenshots?.pngData()
        
        XCTAssertEqual(data1, data2)
    }
    
    func testScreenshotFromRectIsEqualToSection() {
        //Given
        let image = UIImage.imageWithColor(color: .red, size: CGSize(width: 264,
                                                                     height: 264))
        let imageB = UIImage.imageWithColor(color: .blue, size: CGSize(width: 264,
                                                                     height: 264))
        let images = [image!, imageB!]
        let newImage = UIImage.verticalImageFromArray(imagesArray: images)
        let view = UIView(frame: CGRect(origin: .zero,
                                        size: CGSize(width: 264,
                                                     height: 528)))

        let imageView = UIImageView(image: newImage)
        view.addSubview(imageView)

        let croppingRect = CGRect(origin: .zero, size: CGSize(width: 264,
                                                              height: 264))
        let croppingRectB = CGRect(origin: CGPoint(x: 0, y: 264),
                                  size: CGSize(width: 264, height: 264))
        //When
        let screenshotA = view.screenshotForCroppingRect(croppingRect: croppingRect)
        let screenshotB = view.screenshotForCroppingRect(croppingRect: croppingRectB)
        //Then
        let dataA = image?.pngData()
        let dataB = imageB?.pngData()
        let data2 = screenshotA?.pngData()
        let data3 = screenshotB?.pngData()
        
        XCTAssertEqual(dataA, data2)
        XCTAssertEqual(dataB, data3)
    }
}

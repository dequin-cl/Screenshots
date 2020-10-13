//
//  File.swift
//  
//
//  Created by Iván GalazJeria on 12-10-20.
//

import XCTest
@testable import Screenshots

final class UIScrollViewTests: XCTestCase {
    var view: UIView!
    var scrollView: UIScrollView!
    
    override func setUp() {
        view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 264,
                                                                height: 264)))
        scrollView = UIScrollView()
        
        //Add and setup scroll view
        self.view.addSubview(self.scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false;
        
        //Constrain scroll view
        self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true;
        self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true;
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true;
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true;
        
     
        self.view.setNeedsLayout()
        self.view.setNeedsDisplay()
    }
    
    func testSomethimg() {
        //Given
        let view = UIView(frame: CGRect(origin: .zero,
                                        size: CGSize(width: 264,
                                                     height: 264)))
        let image = UIImage.imageWithColor(color: .red, size: CGSize(width: 264,
                                                                     height: 264))
        let imageView = UIImageView(image: image)
        view.addSubview(imageView)

        scrollView.addSubview(view)
        
        let screenshot = scrollView.screenshotOfVisibleContent
        XCTAssertNotNil(screenshot)
    }
}

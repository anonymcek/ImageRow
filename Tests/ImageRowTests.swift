//
//  ImageRowTests.swift
//  Eureka
//
//  Created by Florian Fittschen on 13/01/16.
//  Copyright © 2016 Xmartlabs. All rights reserved.
//

import XCTest

@testable import ImageRow
import Eureka
import UIKit

class ImageRowTests: XCTestCase {
    
    var formVC = FormViewController()
    
    var availableSources: ImageRowSourceTypes {
        var result: ImageRowSourceTypes = []
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            result.insert(ImageRowSourceTypes.PhotoLibrary)
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            result.insert(ImageRowSourceTypes.Camera)
        }
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            result.insert(ImageRowSourceTypes.SavedPhotosAlbum)
        }
        return result
    }
    
    override func setUp() {
        super.setUp()
        
        let form = Form()
        
        form +++ Section()
            <<< ImageRow("DefaultImageRow") {
                $0.title = $0.tag
                // Default sourceTypes == .All
            }
            <<< ImageRow("SingleSourceImageRow") { (row: ImageRow) in
                row.title = row.tag
                row.sourceTypes = .Camera
            }
            <<< ImageRow("TwoSourcesImageRow") { (row: ImageRow) in
                row.title = row.tag
                row.sourceTypes = [.SavedPhotosAlbum, .PhotoLibrary]
            }
        formVC.form = form
        
        // load the view to test the cells
        formVC.view.frame = CGRect(x: 0, y: 0, width: 375, height: 3000)
        formVC.tableView?.frame = formVC.view.frame
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testEmptyImageRowSourceTypes() {
        let result = ImageRowSourceTypes()
        XCTAssertTrue(result.isEmpty)
        XCTAssertFalse(result.contains(.PhotoLibrary))
        XCTAssertFalse(result.contains(.Camera))
        XCTAssertFalse(result.contains(.SavedPhotosAlbum))
    }
    
    func testImagePickerControllerSourceTypeRawValue() {
        XCTAssert(UIImagePickerController.SourceType.photoLibrary.rawValue == ImageRowSourceTypes.PhotoLibrary.imagePickerControllerSourceTypeRawValue)
        XCTAssert(UIImagePickerController.SourceType.camera.rawValue == ImageRowSourceTypes.Camera.imagePickerControllerSourceTypeRawValue)
        XCTAssert(UIImagePickerController.SourceType.savedPhotosAlbum.rawValue == ImageRowSourceTypes.SavedPhotosAlbum.imagePickerControllerSourceTypeRawValue)
    }
    
    func testImageRow() {
        guard let defaultImageRow = formVC.form.rowBy(tag: "DefaultImageRow") as? ImageRow else {
            XCTFail()
            return
        }
        
        guard let singleSourceImageRow = formVC.form.rowBy(tag: "SingleSourceImageRow") as? ImageRow else {
            XCTFail()
            return
        }
        
        guard let twoSourcesImageRow = formVC.form.rowBy(tag: "TwoSourcesImageRow") as? ImageRow else {
            XCTFail()
            return
        }
        
        XCTAssert(defaultImageRow.sourceTypes == ImageRowSourceTypes.All)
        XCTAssert(singleSourceImageRow.sourceTypes == ImageRowSourceTypes.Camera)
        XCTAssert(twoSourcesImageRow.sourceTypes == ImageRowSourceTypes([ImageRowSourceTypes.SavedPhotosAlbum, ImageRowSourceTypes.PhotoLibrary]))
    }
    
    
    
}

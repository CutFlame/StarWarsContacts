//
//  ImageStore.swift
//  Star Wars Contacts
//
//  Created by Michael Holt on 6/5/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import CoreGraphics
import SwiftUI

protocol ImageStoreProtocol {
    func addImage(for key:String, data: Data)
    func addImage(for key:String, image: CGImage)
    func getImage(for key:String) -> CGImage?
    func hasImage(for key:String) -> Bool
    func deleteImages()
}

class ImageStore: ImageStoreProtocol {
    private var imageCache = [String:CGImage]()

    func deleteImages() {
        imageCache.removeAll()
    }

    func addImage(for key:String, data: Data) {
        if let image = convertToImage(data) {
            addImage(for: key, image: image)
        } else {
            handleError(POSIXError.init(.EFAULT))
        }
    }

    func addImage(for key:String, image: CGImage) {
        self.imageCache[key] = image
    }

    func convertToImage(_ data:Data) -> CGImage? {
        guard
            let imageSource = CGImageSourceCreateWithData(data as CFData, nil),
            let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
            else {
                return nil
        }
        return image
    }

    func getImage(for key: String) -> CGImage? {
        return imageCache[key]
    }

    func hasImage(for key: String) -> Bool {
        return imageCache.keys.contains(key)
    }

    func handleError(_ error:Error) {
        print("ERROR: \(error)")
    }

}

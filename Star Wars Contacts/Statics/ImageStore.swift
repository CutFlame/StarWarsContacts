//
//  ImageStore.swift
//  Star Wars Contacts
//
//  Created by Michael Holt on 6/5/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import CoreGraphics
import SwiftUI

class ImageStore {
    private(set) var imageCache = [String:CGImage]()

    func handleImageDataResult(_ key:String, _ result:Result<Data, Error>) {
        switch result {
        case .success(let data):
            self.handleImageData(key, data)
        case .failure(let error):
            self.handleError(error)
        }
    }

    func handleImageData(_ key:String, _ data:Data) {
        if let image = convertToImage(data) {
            self.imageCache[key] = image
        } else {
            handleError(POSIXError.init(.EFAULT))
        }
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

    func handleError(_ error:Error) {
        print("ERROR: \(error)")
    }

}


class OLDImageStore {
    fileprivate typealias _ImageDictionary = [String: [Int: CGImage]]
    fileprivate var images: _ImageDictionary = [:]

    fileprivate static var originalSize = 250
    fileprivate static var scale = 2

    static var shared = OLDImageStore()

    func image(name: String, size: Int) -> Image {
        let index = _guaranteeInitialImage(name: name)

        let sizedImage = images.values[index][size]
            ?? _sizeImage(images.values[index][Self.originalSize]!, to: size * Self.scale)
        images.values[index][size] = sizedImage

        return Image(sizedImage, scale: Length(Self.scale), label: Text(verbatim: name))
    }

    fileprivate func _guaranteeInitialImage(name: String) -> _ImageDictionary.Index {
        if let index = images.index(forKey: name) { return index }

        guard
            let url = Bundle.main.url(forResource: name, withExtension: nil),
            let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
            let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
            else {
                fatalError("Couldn't load image \(name) from main bundle.")
        }

        images[name] = [Self.originalSize: image]
        return images.index(forKey: name)!
    }

    fileprivate func _sizeImage(_ image: CGImage, to size: Int) -> CGImage {
        guard
            let colorSpace = image.colorSpace,
            let context = CGContext(
                data: nil,
                width: size, height: size,
                bitsPerComponent: image.bitsPerComponent,
                bytesPerRow: image.bytesPerRow,
                space: colorSpace,
                bitmapInfo: image.bitmapInfo.rawValue)
            else {
                fatalError("Couldn't create graphics context.")
        }
        context.interpolationQuality = .high
        context.draw(image, in: CGRect(x: 0, y: 0, width: size, height: size))

        if let sizedImage = context.makeImage() {
            return sizedImage
        } else {
            fatalError("Couldn't resize image.")
        }
    }
}

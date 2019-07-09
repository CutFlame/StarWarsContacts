//
//  ImageStore.swift
//  Star Wars Contacts
//
//  Created by Michael Holt on 6/5/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import CoreGraphics
import SwiftUI
import MobileCoreServices

protocol ImageStoreProtocol {
    func addImage(for key:String, data: Data)
    func addImage(for key:String, image: CGImage)
    func getImage(for key:String) -> CGImage?
    func hasImage(for key:String) -> Bool
    func deleteImages()
}

class ImageStore: ImageStoreProtocol {
    private var imageCache = [ImageID:CGImage]()

    init() {
        loadCache()
    }

    private(set) var imageCacheDirectoryURL: URL = {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        guard let cacheDirectory = paths.first else {
            fatalError("Could not get cachesDirectory")
        }
        guard let cacheDirectoryURL = URL(string: "file://\(cacheDirectory)")?.appendingPathComponent("Images", isDirectory: true) else {
            fatalError("Invalid URL")
        }
        try? FileManager.default.createDirectory(at: cacheDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        return cacheDirectoryURL
    }()

    private var imageCacheContents: [String] {
        let contents = (try? FileManager.default.contentsOfDirectory(atPath: imageCacheDirectoryURL.path)) ?? []
        return contents
    }

    private func removeCache() {
        for fileName in imageCacheContents {
            let url = imageCacheDirectoryURL.appendingPathComponent(fileName)
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                print(error)
            }
        }
    }

    private func loadCache() {
        for fileName in imageCacheContents {
            loadCacheImage(fileName: fileName)
        }
    }

    private func loadCacheImage(fileName: String) {
        let url = imageCacheDirectoryURL.appendingPathComponent(fileName)
        loadCacheImage(url: url)
    }

    let validFileExtensions = ["png", "jpg", "gif"]

    private func loadCacheImage(url: URL) {
        if !validFileExtensions.contains(url.pathExtension) {
            //print("Not a valid file extension: '\(url.pathExtension)'")
            return
        }
        let key = url.lastPathComponent
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            print(error)
            return
        }
        guard let image = convertToImage(data) else {
            print("ERROR: failed to convert data to image: \(url)")
            return
        }
        imageCache[key] = image
    }

    private func saveCacheImage(key: ImageID, image: CGImage) {
        let url = imageCacheDirectoryURL.appendingPathComponent(key)
        saveCacheImage(url: url, image: image)
    }
    private func saveCacheImage(url: URL, image: CGImage) {
        writeCGImage(image, to: url)
    }

    @discardableResult
    func writeCGImage(_ image: CGImage, to destinationURL: URL) -> Bool {
        guard let destination = CGImageDestinationCreateWithURL(destinationURL as CFURL, kUTTypePNG, 1, nil) else { return false }
        CGImageDestinationAddImage(destination, image, nil)
        return CGImageDestinationFinalize(destination)
    }

    func deleteImages() {
        imageCache.removeAll()
        removeCache()
    }

    func addImage(for key:ImageID, data: Data) {
        if let image = convertToImage(data) {
            addImage(for: key, image: image)
        } else {
            handleError(POSIXError.init(.EFAULT))
        }
    }

    func addImage(for key:ImageID, image: CGImage) {
        self.imageCache[key] = image
        saveCacheImage(key: key, image: image)
    }

    private func convertToImage(_ data:Data) -> CGImage? {
        guard
            let imageSource = CGImageSourceCreateWithData(data as CFData, nil),
            let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
            else {
                return nil
        }
        return image
    }

    private func convertToData(_ image:CGImage) -> Data? {
        guard let data = image.dataProvider?.data else {
            return nil
        }
        return data as Data
    }

    func getImage(for key: ImageID) -> CGImage? {
        return imageCache[key]
    }

    func hasImage(for key: ImageID) -> Bool {
        return imageCache.keys.contains(key)
    }

    func handleError(_ error:Error) {
        print("ERROR: \(error)")
    }

}

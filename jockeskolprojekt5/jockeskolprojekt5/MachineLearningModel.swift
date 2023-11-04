//
//  MachineModel.swift
//  skoluppgift4
//
//  Created by Joakim Sjöstedt on 2023-10-28.
//

import Foundation
import UIKit
import Vision

class MachineLearningModel {
    static func identifyImage(named: String) -> String {
        let defaultConfig = MLModelConfiguration()
        print("sa", named)
        guard
            let imageClassifierWrapper = try? JockeImageClassifierComplete(configuration: defaultConfig),
            let image = UIImage(named: named),
            let bufferedImage = buffer(from: image)
        else {
            return ""
        }
        
        do {
            let output = try imageClassifierWrapper.prediction(image: bufferedImage)
            
            print("-- ", output.classLabel, output.classLabelProbs[output.classLabel])
            return output.classLabel
        } catch {
            print("Oh my!")
            return ""
        }
    }
    
    
    private static func buffer(from image: UIImage) -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.translateBy(x: 0, y: image.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
}

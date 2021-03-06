//
//  NextLevel+Additions.swift
//  NextLevel (http://nextlevel.engineering/)
//
//  Copyright (c) 2016-present patrick piemonte (http://patrickpiemonte.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import AVFoundation

extension NextLevel {
    
    // MARK: Device Format
    
    public class func isCaptureDeviceFormat(inRange format: AVCaptureDeviceFormat, frameRate: CMTimeScale) -> Bool {
        return NextLevel.isCaptureDeviceFormat(inRange: format, frameRate: frameRate, dimensions: CMVideoDimensions(width: 0, height: 0))
    }
    
    public class func isCaptureDeviceFormat(inRange format: AVCaptureDeviceFormat, frameRate: CMTimeScale, dimensions: CMVideoDimensions) -> Bool {
        let formatDimensions: CMVideoDimensions = CMVideoFormatDescriptionGetDimensions(format.formatDescription)
        
        if (formatDimensions.width >= dimensions.width && formatDimensions.height >= dimensions.height) {
            let videoSupportedFrameRateRanges: [AVFrameRateRange] = format.videoSupportedFrameRateRanges as! [AVFrameRateRange]
            for frameRateRange in videoSupportedFrameRateRanges {
                if frameRateRange.minFrameDuration.timescale >= frameRate && frameRateRange.maxFrameDuration.timescale <= frameRate {
                    return true
                }
            }
        }
        return false
    }
    
    // MARK: Frame Rate
    
    public class func maxFrameRate(forFormat format: AVCaptureDeviceFormat, minFrameRate: CMTimeScale) -> CMTimeScale {
        var lowestTimeScale: CMTimeScale = 0
        let videoSupportedFrameRateRanges: [AVFrameRateRange] = format.videoSupportedFrameRateRanges as! [AVFrameRateRange]
        for range in videoSupportedFrameRateRanges {
            if range.minFrameDuration.timescale >= minFrameRate && (lowestTimeScale == 0 || range.minFrameDuration.timescale < lowestTimeScale) {
                lowestTimeScale = range.minFrameDuration.timescale
            }
        }
        return lowestTimeScale
    }
    
    // MARK: Configuration
    
    public class func averageVideoBitRate(fromWidth width: Int, height: Int) {
        
    }
    
    // MARK: Storage
    
    public class func availableStorageSpaceInBytes() -> UInt64 {
        do {
            if let lastPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last {
                let attributes = try FileManager.default.attributesOfFileSystem(forPath: lastPath)
                if let freeSize = attributes[FileAttributeKey.systemFreeSize] as? UInt64 {
                    return freeSize
                }
            }
        } catch {
            print("could not determine user attributes of file system")
            return 0
        }
        return 0
    }

}

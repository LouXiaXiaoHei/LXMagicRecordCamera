//
//  LXMagicRecordCameraConfig.swift
//  Pods
//
//  Created by 邓小涛 on 2017/7/13.
//
//

import Foundation
import AVFoundation

class LXMagicRecordCameraConfig:NSObject {
    
    //Max Recording Video Time
    public static let maxRecordingTime:TimeInterval = 30
    
    //Min Recording Video Time
    public static let minRecordingTime:TimeInterval = 3
    
    //Video Setting
    public static let videoSetting:[String : Any] = [
        AVVideoCodecKey : AVVideoCodecH264,
        AVVideoWidthKey : 720,
        AVVideoHeightKey: 1280,
        AVVideoCompressionPropertiesKey:
            [
                AVVideoProfileLevelKey : AVVideoProfileLevelH264Main31,
                AVVideoAllowFrameReorderingKey : false,
                //码率
                AVVideoAverageBitRateKey : 720 * 1280 * 3
        ]
    ]
    
    //audio Setting
    public static let audioSetting:[String : Any] = [
        AVFormatIDKey : kAudioFormatMPEG4AAC,
        AVNumberOfChannelsKey : 2,
        AVSampleRateKey : 16000,
        AVEncoderBitRateKey : 32000
    ]
    
    //Video Path
    public static let videoPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/Video")
    
    //Video OutPut Size
    public static let outputVideoSize:CGSize = CGSize.init(width: 720, height: 1280)
}

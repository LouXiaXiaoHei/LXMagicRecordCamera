//
//  LXMagicRecordCamera.swift
//  Pods
//
//  Created by 邓小涛 on 2017/7/13.
//
//

import Foundation
import AVFoundation
import GPUImage

public class LXMagicRecordCamera: GPUImageView{
    
    fileprivate var camera:GPUImageVideoCamera = GPUImageVideoCamera.init(sessionPreset: AVCaptureSessionPreset1280x720, cameraPosition: AVCaptureDevicePosition.back);
    
    fileprivate var filterView:GPUImageView?;
    fileprivate var filter:GPUImageFilter = GPUImageFilter.init();
    fileprivate var movieWriter:GPUImageMovieWriter?
    
    override public init(frame: CGRect) {
        super.init(frame:frame)
        //init camera
        camera.outputImageOrientation = UIInterfaceOrientation.portrait;
        camera.horizontallyMirrorFrontFacingCamera = true;
        camera.addAudioInputsAndOutputs();
        
        //init filter
        filter = GPUImageFilter.init();
        
        //add renderView in filter
        camera.addTarget(filter);
        filter.addTarget(self);
        
    }
    public func initRecording(){
        let size = CGSize.init(width: LXMagicRecordCameraConfig.videoSetting["AVVideoWidthKey"] as! Int, height: LXMagicRecordCameraConfig.videoSetting["AVVideoHeightKey"] as! Int)
        movieWriter = GPUImageMovieWriter.init(movieURL: getVideoFilePath(), size: size, fileType: AVFileTypeQuickTimeMovie, outputSettings: LXMagicRecordCameraConfig.videoSetting);
        
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Start Camera Capture Video in Screen
    public func startCapture(){
        camera.startCapture();
    }
    
    //Stop Camera Capture Video in Screen
    public func stopCapture(){
        camera.stopCapture();
    }
    
    //Pause Camera Capture Video in Screen
    public func pauseCapture(){
        camera.pauseCapture();
    }
    
    //Resume Camera Capture Video in Screen
    public func resumeCapture(){
        camera.resumeCameraCapture();
    }
    
    func getVideoFilePath() -> URL {
        let path = LXMagicRecordCameraConfig.videoPath;
        let filePath = path?.appending("/\(Int(Date().timeIntervalSince1970)).mp4")
        do {
            try FileManager.default.createDirectory(atPath: path!, withIntermediateDirectories: true, attributes: nil)
        } catch {
            
        }
        return URL.init(fileURLWithPath: filePath!)
    }
}

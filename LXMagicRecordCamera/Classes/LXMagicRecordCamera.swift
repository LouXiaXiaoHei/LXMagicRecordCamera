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

let MaxDragOffset:CGFloat = 300;

public class LXMagicRecordCamera: GPUImageView{
    
    fileprivate var camera:GPUImageVideoCamera = GPUImageVideoCamera.init(sessionPreset: AVCaptureSessionPreset1280x720, cameraPosition: AVCaptureDevicePosition.back);
    
    fileprivate var filterView:GPUImageView?;
    fileprivate var filter:GPUImageFilter = GPUImageFilter.init();
    fileprivate var movieWriter:GPUImageMovieWriter?
    fileprivate var currentVideoPath:URL?
    
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
    
    //init Recording
    public func initRecording(){
        currentVideoPath = getVideoFilePath();
        let size = CGSize.init(width: LXMagicRecordCameraConfig.videoSetting["AVVideoWidthKey"] as! Int, height: LXMagicRecordCameraConfig.videoSetting["AVVideoHeightKey"] as! Int)
        movieWriter = GPUImageMovieWriter.init(movieURL: getVideoFilePath(), size: size, fileType: AVFileTypeQuickTimeMovie, outputSettings: LXMagicRecordCameraConfig.videoSetting);
        movieWriter?.setHasAudioTrack(true, audioSettings: LXMagicRecordCameraConfig.audioSetting);
        filter.addTarget(self.movieWriter);
        camera.audioEncodingTarget = movieWriter;
        movieWriter?.encodingLiveVideo = true;
    }
    
    //start record video
    public func startRecording() {
        movieWriter?.startRecording()
    }
    //over record video
    public func overRecording(complete:@escaping ((URL) -> Void)){
        movieWriter?.finishRecording(completionHandler: { 
            DispatchQueue.main.async {
                self.filter.removeTarget(self.movieWriter);
                self.camera.pauseCapture();
                if let path = self.currentVideoPath{
                    complete(path);
                }
            }
        })
    }
    //rotate camera back or font
    public func rotateCamera(){
        camera.rotateCamera();
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
        self.filter.removeTarget(self.movieWriter);
        camera.pauseCapture();
    }
    
    //Resume Camera Capture Video in Screen
    public func resumeCapture(){
        if let tPath = currentVideoPath {
            do {
                try FileManager.default.removeItem(at: tPath)
                currentVideoPath = nil
            } catch {
                print("video delete failure")
            }
        }
        self.filter.addTarget(self.movieWriter);
        camera.resumeCameraCapture();
        self.setVideoZoomFactor(zoom: 0)
    }
    
    // set video zoom factor
    fileprivate func setVideoZoomFactor(zoom:CGFloat) {
        do {
            try camera.inputCamera.lockForConfiguration()
            camera.inputCamera.videoZoomFactor = zoom + 1.0
            camera.inputCamera.unlockForConfiguration()
        } catch {
            
        }
    }
    //flash status operation
    public func changeFlashStatus()->AVCaptureTorchMode{
        if !camera.inputCamera.hasFlash || !camera.inputCamera.hasTorch{
            return .auto;
        }
        let rawValue = camera.inputCamera.torchMode.rawValue;
        let mode = AVCaptureTorchMode(rawValue: rawValue + 1 > 3 ? 0 : rawValue)!;
        do {
            try camera.inputCamera.lockForConfiguration()
            camera.inputCamera.torchMode = mode
            camera.inputCamera.unlockForConfiguration()
        } catch  {
            
        }
        return mode
    }
    
    public func cameraZoom(offseY:CGFloat) {
        let maxZoomFactor = camera.inputCamera.activeFormat.videoMaxZoomFactor 
        let max = maxZoomFactor > LXMagicRecordCameraConfig.maxVideoZoomFactor ? LXMagicRecordCameraConfig.maxVideoZoomFactor : maxZoomFactor
        let per = MaxDragOffset / max
        let zoom = offseY / per
        self.setVideoZoomFactor(zoom: zoom)
    }
    
    //video path
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

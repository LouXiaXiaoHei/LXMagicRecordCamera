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

class LXMagicRecordCamera{
    let camera:GPUImageVideoCamera;
    let renderView:GPUImageView;
    let filter:GPUImageFilter;
    
    init(showView:UIView) {
        //init camera
        camera = GPUImageVideoCamera.init(sessionPreset: AVCaptureSessionPreset1280x720, cameraPosition: AVCaptureDevicePosition.back);
        camera.outputImageOrientation = UIInterfaceOrientation.portrait;
        camera.horizontallyMirrorFrontFacingCamera = true;
        
        //init filter
        filter = GPUImageFilter.init();
        camera.addTarget(filter);
        
        //init renderView
        renderView = GPUImageView.init(frame: showView.bounds);
        showView.addSubview(renderView);
        
        //add renderView in filter
        filter.addTarget(renderView);
    }
    
    //Start Camera Capture Video in Screen
    func startCapture(){
        camera.startCapture();
    }
    
    //Stop Camera Capture Video in Screen
    func stopCapture(){
        camera.stopCapture();
    }
    
}

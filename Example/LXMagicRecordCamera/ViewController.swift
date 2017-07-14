//
//  ViewController.swift
//  LXMagicRecordCamera
//
//  Created by mr_supergift@163.com on 07/13/2017.
//  Copyright (c) 2017 mr_supergift@163.com. All rights reserved.
//

import UIKit
import LXMagicRecordCamera

class ViewController: UIViewController {

    fileprivate let ScreenWidth = UIScreen.main.bounds.size.width;
    fileprivate let ScreenHeight = UIScreen.main.bounds.size.height;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let lxCamera = LXMagicRecordCamera.init(frame: self.view.bounds)
        self.view.addSubview(lxCamera)
        lxCamera.startCapture();
        
        self.initRecordButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        UIApplication.shared.setStatusBarHidden(true, with: UIStatusBarAnimation.none);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initRecordButton(){
        let layer:CAShapeLayer = CAShapeLayer.init();
        layer.lineWidth = 5;
        layer.strokeColor = UIColor.white.cgColor;
        layer.fillColor = UIColor.clear.cgColor;
        let roundedRect:CGRect = CGRect.init(x:ScreenWidth/2-30 , y: ScreenHeight-60-50-10, width: 60, height: 60)
        let path:UIBezierPath = UIBezierPath.init(roundedRect:roundedRect , byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize.init(width: 30, height: 30));
        layer.path = path.cgPath;
        self.view.layer.addSublayer(layer);
    }
    
}


//
//  PhotoViewController.swift
//  CustomCamera
//
//  Created by Frascella Claudio on 8/11/17.
//  Copyright © 2017 TeamDecano. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    var takenPhoto:UIImage?
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.hidesBarsOnTap = true
        self.tabBarController?.tabBar.isHidden = true
        
        messageImageView.image = nil
        messageImageView.center = self.view.center
        messageImageView.contentMode = .center
        messageImageView.alpha = 0
        self.view.addSubview(messageImageView)

        if let availableImage = takenPhoto {
            imageView.image = availableImage
        }
        
        loadFrame()
        setupGestures()
    }
    
    @objc func swiped(gesture: UISwipeGestureRecognizer) {
        if !gesture.isEqual(nil) {
            switch gesture.direction {
            case UISwipeGestureRecognizerDirection.right, UISwipeGestureRecognizerDirection.left:
                //captureScreen()
                self.dismiss(animated: true, completion: nil)

            default:
                break
            }
        }
    }

    @objc func saveOnTap(_ sender: UITapGestureRecognizer) {
        captureScreen()

        messageImageView.image = UIImage(named: "save.png")
        messageImageView.alpha = 1
    }

    func setupGestures() {
        //Swipe right/left to go back to camera
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(PhotoViewController.swiped(gesture:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(PhotoViewController.swiped(gesture:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        //Tap to save and exit
        let tap = UITapGestureRecognizer(target: self, action:
            #selector(PhotoViewController.saveOnTap))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(tap)
    }
    
    func captureScreen() {
        messageImageView.alpha = 0
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
    }
    
    func loadFrame() {
        let newImageView = UIImageView(image: UIImage(named: "frame.png"))
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .none
        newImageView.contentMode = .scaleToFill
        self.view.addSubview(newImageView)
        
        messageImageView.image = UIImage(named: "tap.png")
        messageImageView.alpha = 1
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}

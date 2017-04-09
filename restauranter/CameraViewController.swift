//
//  CameraViewController.swift
//  restauranter
//
//  Created by Darko Dujmovic on 05/04/2017.
//  Copyright © 2017 Darko Dujmovic. All rights reserved.
//

import AVFoundation
import UIKit
import GoogleMaps

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    @IBAction func cancelCamera(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var callerMarker = GMSMarker()
    var masterImagePath = String()
    var masterImageName = String()

    let cancelButton = UIButton()
    let takePhoto = UIButton()
    let cdh = coreDataHandler()
    let stillImageOutput = AVCaptureStillImageOutput()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startCamera()
        addInteractionToView()
       
    }
    
    func addInteractionToView(){
        let halfOfTheView:CGFloat = (self.view.frame.width/CGFloat(2))
        let widthOfTheButton:CGFloat = (self.view.frame.width * 0.8)
        let positionOfButton = halfOfTheView - (widthOfTheButton/2)
        
        //position and size of cancel button
        let positionForCancelButton:CGRect = CGRect(x: positionOfButton ,
                                                    y: self.view.bounds.maxY - 65,
                                                    width: widthOfTheButton,
                                                    height: 60)
        
        
        let positionForShutterButton:CGRect = CGRect(x: ((self.view.bounds.maxX/2)-35) ,
                                                     y: (self.view.bounds.maxY-(self.view.bounds.maxY/5.5)),
                                                     width: 70,
                                                     height: 70)
        
        
        //take photo button
        takePhoto.setImage(UIImage(named:"circumference"), for: .normal)
        takePhoto.frame = positionForShutterButton
        takePhoto.addTarget(self, action: #selector(takeAPhoto), for: .touchUpInside)
        
        
        //cancel button
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        cancelButton.frame = positionForCancelButton
        cancelButton.addTarget(self, action: #selector(closeViewFinder), for: .touchUpInside)
        
        view.layer.addSublayer(previewLayer)
        self.view.addSubview(cancelButton)
        self.view.addSubview(takePhoto)

    }
    
    var captureSesssion : AVCaptureSession!
    var cameraOutput : AVCapturePhotoOutput!
    var previewLayer : AVCaptureVideoPreviewLayer!
    
    func startCamera(){
        
        captureSesssion = AVCaptureSession()
        captureSesssion.sessionPreset = AVCaptureSessionPresetPhoto
        cameraOutput = AVCapturePhotoOutput()
        
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        if let input = try? AVCaptureDeviceInput(device: device) {
            if (captureSesssion.canAddInput(input)) {
                captureSesssion.addInput(input)
                if (captureSesssion.canAddOutput(cameraOutput)) {
                    captureSesssion.addOutput(cameraOutput)
                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSesssion)
                    previewLayer.frame = self.view.bounds
                    previewLayer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.maxX, height: self.view.bounds.maxY)
                    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                    self.view.layer.addSublayer(previewLayer)
                    captureSesssion.startRunning()
                }
            } else {
                print("issue here : captureSesssion.canAddInput")
            }
        } else {
            print("some problem here")
        }
 
    
    }
    
    func takeAPhoto(){
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [
            kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
            kCVPixelBufferWidthKey as String: 160,
            kCVPixelBufferHeightKey as String: 160
        ]
        settings.previewPhotoFormat = previewFormat
        cameraOutput.capturePhoto(with: settings, delegate: self)
    
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let error = error {
            print("error occure : \(error.localizedDescription)")
        }
        
        if  let sampleBuffer = photoSampleBuffer,
            let previewBuffer = previewPhotoSampleBuffer,
            let dataImage =  AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer:  sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
            print(UIImage(data: dataImage)?.size as Any)
            
            let dataProvider = CGDataProvider(data: dataImage as CFData)
            let cgImageRef: CGImage! = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
            let image = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: UIImageOrientation.right)
            
            
            //pripremi documents + imagename
            let imageName = UUID().uuidString
            let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
            
            if let jpegData = UIImageJPEGRepresentation(image, 80) {
                try? jpegData.write(to: imagePath)
                
              //  print("\nfotografija spremljna na \(imagePath) s imenom \(imageName)\n")
            }
           
          //  print("Image path is \(imagePath.path)")
            masterImagePath = imagePath.path
            masterImageName = imageName
            
            // prikaži sliku nakon slikanja
            let presentImage = UIImageView()
            presentImage.image = UIImage(contentsOfFile: masterImagePath)
            presentImage.contentMode = .scaleAspectFill
            presentImage.frame = previewLayer.frame
            
            
            
            
            //buttons
            let positionForQuestionButton :CGRect = CGRect(x: 0 ,
                                                    y: 0,
                                                    width: self.view.bounds.maxX,
                                                    height: 80)
            
            let questionButton = UIButton()
            questionButton.setTitle("Did you take a good one ?", for: .normal)
           // questionButton.backgroundColor = UIColor(red:0.97, green:0.26, blue:0.34, alpha:1.0)
            questionButton.backgroundColor = UIColor(red:0.82, green:0.89, blue:0.25, alpha:1.0) //D1E340
            questionButton.isEnabled = false
            //questionButton.layer.cornerRadius = 20
            questionButton.frame = positionForQuestionButton
            questionButton.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 30)
            
            
            
            
            
            let positionForNotOKButton:CGRect = CGRect(x: ((self.view.bounds.maxX/2)-180) ,
                                                    y: self.view.bounds.maxY - 60,
                                                    width: 360,
                                                    height: 40)
            
            
            
            
            let notOkButton = UIButton()
            notOkButton.setTitle("Cancel", for: .normal)
           //  notOkButton.backgroundColor = UIColor(red:0.87, green:0.96, blue:0.26, alpha:1.0)
            notOkButton.backgroundColor = UIColor(red:0.97, green:0.26, blue:0.34, alpha:1.0) //F74257
            notOkButton.layer.cornerRadius = 20
            notOkButton.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
            notOkButton.frame = positionForNotOKButton
            notOkButton.addTarget(self, action: #selector(closeViewFinder), for: .touchUpInside)
            
            
            let positionForOKButton:CGRect = CGRect(x: ((self.view.bounds.maxX/2)-180) ,
                                                        y: self.view.bounds.maxY - 130,
                                                        width: 360,
                                                        height: 60)
            
            
            
            
            let okButton = UIButton()
            okButton.setTitle("Yeah, it's awesome", for: .normal)
            okButton.backgroundColor = UIColor(red:0.09, green:0.64, blue:0.51, alpha:1.0)
            okButton.layer.cornerRadius = 20
            okButton.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
            okButton.frame = positionForOKButton
            okButton.addTarget(self, action: #selector(saveThePhoto), for: .touchUpInside)
            
            UIView.animate(withDuration: 5, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                self.view.addSubview(presentImage)
                self.takePhoto.frame.offsetBy(dx: 200, dy: 0)
               // self.takePhoto.isHidden =  true
                self.cancelButton.isHidden = true
                self.view.addSubview(questionButton)
                self.view.addSubview(notOkButton)
                self.previewLayer.removeFromSuperlayer()
                self.view.addSubview(okButton)
            }, completion: nil)
            
      
        } else {
            print("some error here")
        }
    }
    
    func closeViewFinder(){
   
        self.dismiss(animated: true, completion:nil)
    }

    
    func saveThePhoto(completion: ()->Void){
        DispatchQueue.global(qos: .background).async {
        let id = (self.callerMarker.userData as! Restaurant).id
        let idInt = Int32(id)
        self.cdh.addPhotoToRestaurant(markerID: idInt, photoAddress: self.masterImageName)
        }
        

        
        closeViewFinder()
    }

    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    
}







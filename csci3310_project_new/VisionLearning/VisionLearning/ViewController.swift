//
//  ViewController.swift
//  VisionLearning
//
//  Created by Chan Paul on 16/12/2017.
//  Copyright © 2017年 Chan Paul. All rights reserved.
//

import UIKit
import CoreML
import os.log


class ViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var classifier: UILabel!
    @IBOutlet weak var fromLanguage: UITextField!
    @IBOutlet weak var toLanguage: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var thing:Thing?
    var englishtext: String!
    var text:String!
    var result1: String!
    var model: Inceptionv3!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //englishtext.delegate = self
        if let thing = thing{
            imageView.image = thing.photo
            classifier.text = thing.translatedName
            englishtext = thing.englishName
            text = thing.translatedName
        }
        updateSaveButtonState()    }
    
    override func viewWillAppear(_ animated: Bool) {
        model = Inceptionv3()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: Action
    @IBAction func camera(_ sender: Any) {
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            return
        }
        
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        cameraPicker.allowsEditing = false
        
        present(cameraPicker, animated: true)
    }
    
    @IBAction func openLibrary(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    @IBAction func translate(_ sender: Any) {
        let translator = ROGoogleTranslate()
        translator.apiKey = "AIzaSyDRPYAnuiL9K7-Be3JE1888J60VgTdYHR0" // Add your API Key here
        
        
        var params = ROGoogleTranslateParams()
        params.source = fromLanguage.text ?? "en"
        params.target = toLanguage.text ?? "zh-TW"
        params.text = text ?? "Analyzing Image..."
        translator.translate(params: params) { (result) in
            DispatchQueue.main.async {
                self.classifier.text = "\(result)"
                self.result1 = "\(result)"
            }
        }
        updateSaveButtonState()
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        print("cancel called\n")
    }
    
    //MARK: NAvigation
    
    override func prepare (for segue: UIStoryboardSegue, sender: Any?){
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button == saveButton else{
            os_log("The save button was not pressed, cancelling", log:OSLog.default, type: .debug)
            return
        }
        
        let englishName = englishtext ?? ""
        let imageOfTheThing = imageView.image
        let translatedName = result1 ?? ""
        
        thing = Thing(englishName: englishName, photo: imageOfTheThing, translatedName: translatedName)
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false;
    }
    
    private func updateSaveButtonState(){
        print("Test")
        let text1 = englishtext ?? ""
        print(englishtext)
        saveButton.isEnabled = !text1.isEmpty;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }
    
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true)
        classifier.text = "Analyzing Image..."
        guard let image = info["UIImagePickerControllerOriginalImage"] as? UIImage else {
            return
        } //1
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 299, height: 299), true, 2.0)
        image.draw(in: CGRect(x: 0, y: 0, width: 299, height: 299))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(newImage.size.width), Int(newImage.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(newImage.size.width), height: Int(newImage.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) //3
        
        context?.translateBy(x: 0, y: newImage.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        newImage.draw(in: CGRect(x: 0, y: 0, width: newImage.size.width, height: newImage.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        imageView.image = newImage
        
        // Core ML
        guard let prediction = try? model.prediction(image: pixelBuffer!) else {
            return
        }
        classifier.text = "\(prediction.classLabel)"
        englishtext = prediction.classLabel
        text = englishtext
    }
}

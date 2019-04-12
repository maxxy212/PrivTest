//
//  PriverdoMethods.swift
//  PrivTest
//
//  Created by Maxwell Chukwuemeka on 09/04/2019.
//  Copyright © 2019 Maxwell. All rights reserved.
//

import Foundation
import UIKit
import Photos
import Fusuma
import AWSCore
import AWSS3
import UICircularProgressRing

struct PriverdoMethods {
    static func getImageForEscortAccout(_ status: String?) -> UIImage {
        if status == PriveConstants.ESCORT_ACCOUNT_STATUS_LOCKED {
            return UIImage(named: "IconStatusLocked")!
        }
        else if status == PriveConstants.ESCORT_ACCOUNT_STATUS_BASIC{
            return UIImage(named: "IconStatusBasic")!
        }
        else if status == PriveConstants.ESCORT_ACCOUNT_STATUS_GOLD {
            return UIImage(named: "IconStatusGold")!
        }
        else if ((status?.caseInsensitiveCompare(PriveConstants.ESCORT_ACCOUNT_STATUS_PLATINUM)) != nil) {
            return UIImage(named: "IconStatusPlatinum")!
        }
        return UIImage()
    }
    
    static func getLocalImage(viewController: UIViewController, fusumaDelegate: FusumaDelegate, allowMultipleSelection: Bool = false) -> Bool {
        var fusumaModes = [FusumaMode]()
        
        if isCameraAuthorized(viewController) {
            fusumaModes.append(.camera)
            print("-----Appended camera")
            
            if isPhotoLibraryAuthorized(viewController) {
                fusumaModes.append(.library)
                print("----Append Library")
            }
        }
        
        if fusumaModes.count > 0 {
            getLocalImage(viewController: viewController, fusumaDelegate: fusumaDelegate, fusumaModes: fusumaModes, allowMultipleSelection: allowMultipleSelection)
            return true
        }else {
            return false
        }
        
    }
    
    fileprivate static func getLocalImage(viewController: UIViewController, fusumaDelegate: FusumaDelegate, fusumaModes: [FusumaMode], allowMultipleSelection: Bool = false) {
        let fusuma = FusumaViewController()
        fusuma.delegate = fusumaDelegate
        fusuma.availableModes = fusumaModes
        //        fusuma.hasVideo = false //To allow for video capturing with .library and .camera available by default
        fusuma.cropHeightRatio = 1.0 // Height-to-width ratio. The default value is 1, which means a squared-size photo.
        fusuma.allowMultipleSelection = allowMultipleSelection // You can select multiple photos from the camera roll. The default value is false.
        viewController.present(fusuma, animated: true, completion: nil)
    }
    
    static func isPhotoLibraryAuthorized(_ viewController: UIViewController) -> Bool {
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            return true
        }else {
            PHPhotoLibrary.requestAuthorization() {
                status in
                switch status {
                case .denied:
                    print("----denied")
                    break
                case .authorized:
                    print("-----authorized")
                case .restricted:
                    print("----restricted")
                case .notDetermined:
                    print("-----notDetermined")
                }
            }
            return false
        }
    }
    
    static func isCameraAuthorized(_ viewController: UIViewController) -> Bool {
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        
        switch cameraAuthorizationStatus {
        case .denied:
            print("---- denied")
            break
        case .authorized:
            print("---- authorized")
            return true
        case .restricted:
            print("---- restricted")
            return true
        case .notDetermined:
            print("---- notDetermined")
            AVCaptureDevice.requestAccess(for: cameraMediaType) {
                granted in
                if granted {
                    print("----Granted access to \(cameraMediaType)")
                }else {
                    print("----Granted access to \(cameraMediaType)")
                }
            }
            break
        }
        
        return false
    }
    
    static func showCameraAndPhotoAlert(_ viewController: UIViewController) {
        let message = "Please grant access to your camera and photo library."
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) {
            (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10, *){
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)")
                    })
                }else {
                    UIApplication.shared.openURL(settingsUrl)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        let uiAlert = UIAlertController(title: "Information", message: message, preferredStyle: .alert)
        
        uiAlert.addAction(settingsAction)
        uiAlert.addAction(cancelAction)
        viewController.present(uiAlert, animated: true)
    }
    
    static func getRandomAlphanumericString(_ length: Int = 14) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0...length-1).map{ _ in letters.randomElement()! })
    }
    
    static func makePhoneCall(number: String, viewController: UIViewController) {
        if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }else {
                UIApplication.shared.openURL(url)
            }
        }else {
            viewController.presentOkAlert("Bad phone number", "The number '\(number)' appears to be an invalid phone number.")
        }
    }
    
    static func postImageToAWS(imageUrl: URL, circularProgressBar: UICircularProgressRing? = nil, completionHandler: @escaping (NetworkResponseModel) -> Void) {
        let accessKey = "AKIAJTOMPBOEHIK3OCZQ"
        let secretKey = "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"
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: accessKey, secretKey: secretKey)
        let configuration = AWSServiceConfiguration(region: AWSRegionType.USEast1, credentialsProvider: credentialsProvider)
        AWSServiceManager.default()?.defaultServiceConfiguration = configuration
        
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest?.bucket = "priverdo-userfiles-mobilehub-543857052"
            uploadRequest?.key = "\(getRandomAlphanumericString()).jpeg"
        uploadRequest?.contentType = "image/jpeg"
        uploadRequest?.body = imageUrl
        //        uploadRequest?.serverSideEncryption = AWSS3ServerSideEncryption.AES256
        uploadRequest?.acl = .publicRead
        
        if let progressBar = circularProgressBar {
            progressBar.isHidden = false
            uploadRequest?.uploadProgress = { (bytesSent, totalBytesSent, totalBytesExpectedToSend) -> Void in
                DispatchQueue.main.async(execute: {
                    let bytesSent = CGFloat(totalBytesSent)
                    let bytesToSend = CGFloat(totalBytesExpectedToSend)
                    let progressValue = (bytesSent/bytesToSend) * 100
                    progressBar.startProgress(to: progressValue, duration: 0.1)
                    print("progressBar moved to \(progressValue)")
                    //                    progressBar.setProgress(to: Double(totalBytesSent/totalBytesExpectedToSend), withAnimation: true)
                })
            }
        }
        
        var networkResponse = NetworkResponseModel(statusCode: 400)
        
        print("Starting upload request")
        if let uploadRequest = uploadRequest {
            let transferManager = AWSS3TransferManager.default()
            
            print("About to start transfer")
            transferManager.upload(uploadRequest)
                .continueWith(executor: AWSExecutor.mainThread(), block: {(task: AWSTask) -> Any? in
                    
                    if task.error != nil {
                        // Error.
                        print("Error \(String(describing: task.error?.localizedDescription)) ---> \(task.error.debugDescription) uploading to AWS")
                        networkResponse.data = task.error?.localizedDescription
                        
                        // TODO: Show a red/stuck progress bar
                        if let progressBar = circularProgressBar {
                            progressBar.fadeViewToHidden()
                        }
                    } else {
                        // Do something with your result.
                        print("Successfully uploaded")
                        print("https://s3.amazonaws.com/\(uploadRequest.bucket!)/\(uploadRequest.key!)")
                        print("https://s3-us-east-1.amazonaws.com/\(uploadRequest.bucket!)/\(uploadRequest.key!)")
                        networkResponse.statusCode = 200
                        networkResponse.success = true
                        networkResponse.data = "https://s3.amazonaws.com/\(uploadRequest.bucket!)/\(uploadRequest.key!)"
                        //                    task.result
                        
                        if let progressBar = circularProgressBar {
                            progressBar.fadeViewToHidden()
                        }
                    }
                    completionHandler(networkResponse)
                    return nil
                })
        }else {
            print("No uploadRequest")
        }
    
    }
}

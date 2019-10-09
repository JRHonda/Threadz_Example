//
//  AnimationDemoViewController.swift
//  Threadz_Example
//
//  Created by Justin Honda on 10/8/19.
//  Copyright © 2019 Justin Honda. All rights reserved.
//

import UIKit

class AnimationDemoViewController: UIViewController {
    
    lazy var downloadProgressLabel: UILabel = {
        let lbl = UILabel()
        lbl.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        lbl.font = UIFont(name: "arial", size: 18)
        lbl.textColor = .yellow
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var viewToAnimate: UIView = {
        let vw = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        vw.backgroundColor = .blue
        return vw
    }()
    
    lazy var progressViewForUrl30MB: UIProgressView = {
        let pv = UIProgressView(progressViewStyle: UIProgressView.Style.default)
        pv.progress = 0.01 // default to 1%
        pv.progressTintColor = UIColor.red
        pv.backgroundColor = .white
        pv.frame.size.width = view.frame.width * 0.9
        pv.frame.size.height = 20
        return pv
    }()
    
    lazy var progressViewForURLneedsaname: UIProgressView = {
        let pv = UIProgressView(progressViewStyle: UIProgressView.Style.default)
        pv.progress = 0.01 // default to 1%
        pv.progressTintColor = UIColor.green
        pv.backgroundColor = .white
        pv.frame.size.width = view.frame.width * 0.9
        pv.frame.size.height = 20
        return pv
    }()
    
    lazy var progressViewForUrlneedsanametoo: UIProgressView = {
        let pv = UIProgressView(progressViewStyle: UIProgressView.Style.default)
        pv.progress = 0.01 // default to 1%
        pv.progressTintColor = UIColor.blue
        pv.backgroundColor = .white
        pv.frame.size.width = view.frame.width * 0.9
        pv.frame.size.height = 20
        return pv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.init(red: 105/255, green: 190/255, blue: 40/255, alpha: 1) // Seahawks - Action Green
        
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
        let downloadTask = urlSession.downloadTask(with: URLs.urlOne30MB!)
        
        DispatchQueue.global().async {
            downloadTask.resume()
        }
        
        
        
        
        elementsToLoadOnBackgroundThread { (success) in
            print("The current thread is ", Thread.current)
            print("Background tasks complete")
        }
        
        elementsToLoadOnMainThread { (success) in
            print("The current thread is ", Thread.current)
            print("Background tasks complete")
        }
        
    }
    
    func elementsToLoadOnBackgroundThread(completion: @escaping (Bool) -> ()) {
        DispatchQueue.global(qos: .background).async {
            //self.getDownload()
            completion(true)
        }
        
    }
    
    func elementsToLoadOnMainThread(completion: @escaping (Bool) -> ()) {
        DispatchQueue.main.async {
            self.view.addSubview(self.viewToAnimate)
            self.viewToAnimate.center = self.view.center
            self.view.addSubview(self.progressViewForUrl30MB)
            self.progressViewForUrl30MB.center.y = self.view.frame.height * 0.90
            self.progressViewForUrl30MB.center.x = self.view.center.x
            self.view.addSubview(self.downloadProgressLabel)
            self.downloadProgressLabel.center = self.view.center
            completion(true)
        }
    }
    
    // open func downloadTask(with url: URL, completionHandler: @escaping (URL?, URLResponse?, Error?) -> Void) -> URLSessionDownloadTask
    
    func getDownload(url: String) {
        let downloadUrl = URL(string: url) //http://speedtest-ca.turnkeyinternet.net/100mb.bin
        let downloadTask = URLSession.shared.downloadTask(with: downloadUrl!) { (url, urlResponse, error) in
            
            DispatchQueue.main.async {
                
            }
            print("HTTP response is: ", urlResponse as Any)
            print("HTTP expected content length is: ", urlResponse?.expectedContentLength as Any)
            print("url is: ", url?.absoluteString as Any)
            let fileUrl = url
            
            do {
                
                let documentsURL = try
                FileManager.default.url(for: .documentDirectory,
                                        in: .userDomainMask,
                                        appropriateFor: nil,
                                        create: false)
                let savedURL = documentsURL.appendingPathComponent(
                    fileUrl!.lastPathComponent)
                try FileManager.default.moveItem(at: fileUrl!, to: savedURL)
                
            } catch {
                print("Error is: ", error.localizedDescription)
            }
        }
        
        downloadTask.resume()
        
    }
    
}

extension AnimationDemoViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("required protocol stub call")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
       // print("Total bytes expected to write: ", totalBytesExpectedToWrite)
        //print("Total bytes written: ", totalBytesWritten)
        let percentProgressString = String(Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)).prefix(4)
        print("Progress is: ", percentProgressString)
        
        DispatchQueue.main.async {
            self.downloadProgressLabel.text = String(percentProgressString)
            self.progressViewForUrl30MB.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        }
        
    }
    

    
    
}


struct URLs {
    static let urlOne30MB = URL(string: "https://speedtest.southeast.rr.com:8080/download?nocache=72f4bb69-a130-458e-a0bf-b2561bc4381f&size=30589428&guid=24cc3d9a-fa7b-4c79-afff-acbe4b6d19d5")
}

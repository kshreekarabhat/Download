//
//  ViewController.swift
//  Download
//
//  Created by Shreekara on 7/14/17.
//  Copyright © 2017 Shreekara. All rights reserved.
//

import UIKit

class ViewController: UIViewController,URLSessionDownloadDelegate {

    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBAction func downloadAsyncProgress(_ sender: Any) {
        
        self.progressIndicator.isHidden = false
        self.progressIndicator.hidesWhenStopped = true
        self.progressIndicator.startAnimating()
        self.demoDownloadWithCompletionHandler()
    }
    
    @IBAction func downloadAsync(_ sender: Any) {

        self.demoDownloadWithDelegate()
    }
    
    public func processDownloadFileAt(_ downloadURL:URL)->Void
    {
        var cachesDir:String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
        cachesDir = cachesDir+"/temp.png"
        if FileManager.default.fileExists(atPath: cachesDir)
        {
            try! FileManager.default.removeItem(atPath: cachesDir)
        }
        
        do
        {
            try FileManager.default.moveItem(atPath: downloadURL.path, toPath: cachesDir)
            print("File downloaded successfully")
            
            DispatchQueue.main.async {
                self.imageView.image = UIImage.init(contentsOfFile: cachesDir)
                self.progressIndicator.stopAnimating()
                self.progressLabel.isHidden = true
            }
        }
        catch
        {
            print("File move failed")
        }
    }
    
    public func demoDownloadWithCompletionHandler()->Void
    {
        let request:URLRequest = URLRequest.init(url: URL.init(string: "http://unsplash.com/photos/GWe0dlVD9e0/download?force=true")!, cachePolicy:.reloadIgnoringLocalCacheData, timeoutInterval: 60)
        let session:URLSession = URLSession.init(configuration: URLSessionConfiguration.default)
        let downloadTask:URLSessionDownloadTask = session.downloadTask(with: request) { (url,reposne,error) in
            self.processDownloadFileAt(url!)
        }
        downloadTask.resume()
    }
    
    public func demoDownloadWithDelegate()->Void
    {
        let request:URLRequest = URLRequest.init(url: URL.init(string: "http://unsplash.com/photos/GWe0dlVD9e0/download?force=true")!, cachePolicy:.reloadIgnoringLocalCacheData, timeoutInterval: 60)
        let session:URLSession = URLSession.init(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        let downloadTask:URLSessionDownloadTask = session.downloadTask(with: request)
        downloadTask .resume()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: URLSessionDelegates
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL)
    {
        self.processDownloadFileAt(location)
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
    {
        DispatchQueue.main.async {
            
            print("bytesWritten :\(bytesWritten)  totalBytesWritten:\(totalBytesWritten) totalBytesExpectedToWrite:\(totalBytesExpectedToWrite)")
            let progress = Int(Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)*100)
            self.progressLabel.text = "\(progress)%"
        }
    }

}

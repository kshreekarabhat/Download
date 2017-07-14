//
//  ViewController.swift
//  Download
//
//  Created by Shreekara on 7/14/17.
//  Copyright © 2017 Shreekara. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let request:URLRequest = URLRequest.init(url: URL.init(string: "http://unsplash.com/photos/GWe0dlVD9e0/download?force=true")!, cachePolicy:.reloadIgnoringLocalCacheData, timeoutInterval: 60)
        let session:URLSession = URLSession.init(configuration: URLSessionConfiguration.default)
        let downloadTask:URLSessionDownloadTask = session.downloadTask(with: request) { (url,reposne,error) in
            
            var cachesDir:String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
            cachesDir = cachesDir+"/temp.png"
            if FileManager.default.fileExists(atPath: cachesDir)
            {
                try! FileManager.default.removeItem(atPath: cachesDir)
            }

            do
            {
                try FileManager.default.moveItem(atPath: url!.path, toPath: cachesDir)
                print("File downloaded successfully")
                
                DispatchQueue.main.async {
                    self.imageView.image = UIImage.init(contentsOfFile: cachesDir)
                    self.progressIndicator.stopAnimating()
                }
            }
            catch
            {
                print("File move failed")
            }
        }
        downloadTask.resume()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

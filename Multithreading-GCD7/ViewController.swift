//
//  ViewController.swift
//  Multithreading-GCD7
//
//  Created by ruslan on 22.11.2021.
//

import UIKit

// some different ways to download images asynchronously

final class ViewController: UIViewController {
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var downloadButton: UIButton!
    
    let imageURL = URL(string: "https://images.unsplash.com/photo-1637672531763-7b7a63b3269b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2274&q=80")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadButton.layer.cornerRadius = 15
//        myImageView.image = UIImage(systemName: "nosign")
    }
    
    // the first approach
    private func firstMethodToDownloadImage() {
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            if let data = try? Data(contentsOf: self.imageURL) {
                DispatchQueue.main.async {
                    self.myImageView.image = UIImage(data: data)
                }
            }
        }
    }
    
    // the second approach (URLSession)
    private func secondMethodToDownloadImage() {
        let task = URLSession.shared.dataTask(with: imageURL) { data, response, error in
            if let imageData = data {
                print("1")
                DispatchQueue.main.async {
                    self.myImageView.image = UIImage(data: imageData)
                }
                print("2")
            }
        }
        task.resume()
    }
    
    // the third approach (DispatchWorkItem)
    private func thirdMethodToDownloadImage() {
        var data: Data?
        let queue = DispatchQueue.global(qos: .utility)
        let workItem = DispatchWorkItem {
            data = try? Data(contentsOf: self.imageURL)
        }
        queue.async(execute: workItem)
        workItem.notify(queue: DispatchQueue.main) {
            if let data = data {
                self.myImageView.image = UIImage(data: data)
            }
        }
    }
    
    // the fourth approach (DispatchWorkItem)
    private func fourthMethodToDownloadImage(imageURL: URL,
                                             runQueue: DispatchQueue,
                                             completionQueue: DispatchQueue,
                                             completion: @escaping (UIImage?, Error?) -> ()) {
        runQueue.async {
            do {
                let data = try Data(contentsOf: imageURL)
                completionQueue.async {
                    completion(UIImage(data: data), nil)
                }
            } catch let error {
                completionQueue.async {
                    completion(nil, error)
                }
            }
        }
    }
    
    @IBAction func downloadButtonAction(_ sender: UIButton) {
        myImageView.image = nil
//        firstMethodToDownloadImage()
//        secondMethodToDownloadImage()
//        thirdMethodToDownloadImage()
        fourthMethodToDownloadImage(imageURL: imageURL, runQueue: DispatchQueue.global(), completionQueue: DispatchQueue.main) { result, error in
            guard let image = result else { return }
            self.myImageView.image = image
        }
    }
}


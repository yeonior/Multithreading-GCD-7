//
//  ViewController.swift
//  Multithreading-GCD7
//
//  Created by ruslan on 22.11.2021.
//

import UIKit

// some different ways to async download images

final class ViewController: UIViewController {
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var downloadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadButton.layer.cornerRadius = 15
//        myImageView.image = UIImage(systemName: "nosign")
    }
    
    // first approach
    private func downloadImage() {
        
    }
    
    @IBAction func downloadButtonAction(_ sender: UIButton) {
        
    }
}


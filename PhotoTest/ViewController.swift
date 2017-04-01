//
//  ViewController.swift
//  PhotoTest
//
//  Created by tom555cat on 2017/4/1.
//  Copyright © 2017年 Hello World Corporation. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func album(_ sender: Any) {
        let albumVC = AlbumsViewController.init()
        self.navigationController?.pushViewController(albumVC, animated: true)
    }
    
}


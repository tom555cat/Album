//
//  PhotoPreviewCell.swift
//  SwiftTest
//
//  Created by tom555cat on 2017/3/29.
//  Copyright © 2017年 Hello World Corporation. All rights reserved.
//

import UIKit
import Photos

class PhotoPreviewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    var asset: PHAsset? {
        didSet {
            PHImageManager.default().requestImage(for: asset!, targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.aspectFill, options: nil) { (result: UIImage?, info: [AnyHashable : Any]?) in
                self.imageView.image = result
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

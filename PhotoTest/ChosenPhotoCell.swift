//
//  ChosenPhotoCell.swift
//  SwiftTest
//
//  Created by tom555cat on 2017/3/31.
//  Copyright © 2017年 Hello World Corporation. All rights reserved.
//

import UIKit
import Photos

typealias DeletePhotoClickedClousre = () -> Void

class ChosenPhotoCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    var deletePhotoClickedClosure: DeletePhotoClickedClousre?
    
    var asset: PHAsset? {
        didSet {
            PHImageManager.default().requestImage(for: asset!, targetSize: CGSize.init(width: (asset?.pixelWidth)!, height: (asset?.pixelHeight)!), contentMode: PHImageContentMode.aspectFill, options: nil) { (result: UIImage?, info: [AnyHashable : Any]?) in
                self.imageView.image = result
            }
        }
    }
    
    @IBAction func deletePhoto(_ sender: Any) {
        if self.deletePhotoClickedClosure != nil {
            self.deletePhotoClickedClosure!()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

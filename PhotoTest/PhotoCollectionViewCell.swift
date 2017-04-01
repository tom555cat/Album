//
//  PhotoCollectionViewCell.swift
//  SwiftTest
//
//  Created by tom555cat on 2017/3/28.
//  Copyright © 2017年 Hello World Corporation. All rights reserved.
//

import UIKit
import Photos

typealias ChoosePhotoButtonClickedClosure = () -> Void

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var chooseBtn: UIButton!
    
    var choosePhotoButtonClickedClosure: ChoosePhotoButtonClickedClosure?
    
    var asset: PHAsset? {
        didSet {
            PHImageManager.default().requestImage(for: asset!, targetSize: CGSize.init(width: (asset?.pixelWidth)!, height: (asset?.pixelHeight)!), contentMode: PHImageContentMode.aspectFill, options: nil) { (result: UIImage?, info: [AnyHashable : Any]?) in
                self.imageView.image = result
            }
        }
    }
    
    var isChosen: Bool = false {
        didSet {
            if isChosen == false {
                self.chooseBtn.setImage(UIImage.init(named: "unselected"), for: .normal)
            } else {
                self.chooseBtn.setImage(UIImage.init(named: "selected"), for: .normal)
            }
        }
    }
    
    @IBAction func chooseButtonClicked(_ sender: Any) {
        if self.choosePhotoButtonClickedClosure != nil {
            self.choosePhotoButtonClickedClosure!()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

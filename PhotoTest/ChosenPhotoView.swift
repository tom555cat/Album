//
//  ChosenPhotoView.swift
//  SwiftTest
//
//  Created by tom555cat on 2017/3/30.
//  Copyright © 2017年 Hello World Corporation. All rights reserved.
//

import UIKit
import Photos

let photoWH: CGFloat = 30
let photoGap: CGFloat = 5
let maxChosenPhotoNum = 10

protocol ReloadDataDelegate {
    func reloadCurrentPhotoData()
}

typealias SendButtonClickedClosure = () -> Void

class ChosenPhotoView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var sendButton: UIButton!
    
    var delegate: ReloadDataDelegate?
    
    var sendButtonClickedClosure: SendButtonClickedClosure?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderWidth = 0.1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.backgroundColor = UIColor.init(red: 249/255.0, green: 249/255.0, blue: 249/255.0, alpha: 1)
        
        let collectionViewLayout = UICollectionViewFlowLayout.init()
        collectionViewLayout.minimumLineSpacing = 5
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.itemSize = CGSize.init(width: 60, height: 60)
        
        self.collectionView.backgroundColor = UIColor.init(red: 249/255.0, green: 249/255.0, blue: 249/255.0, alpha: 1)
        self.collectionView.collectionViewLayout = collectionViewLayout
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.contentSize = CGSize.init(width: maxChosenPhotoNum * (60 + 5), height: 0)
        let nib = UINib.init(nibName: "ChosenPhotoCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "ChosenPhotoCell")
        
        // 发送按钮
        self.sendButton.layer.cornerRadius = 3
        self.sendButton.layer.masksToBounds = true
        self.sendButton.setTitleColor(UIColor.white, for: .normal)
        self.sendButton.backgroundColor = UIColor.init(red: 0.91, green: 0.93, blue: 0.94, alpha: 1)
        self.sendButton.addTarget(self, action: #selector(sendPhotos), for: .touchUpInside)
    }
    
    @objc private func sendPhotos() {
        if self.sendButtonClickedClosure != nil {
            self.sendButtonClickedClosure!()
        }
    }
    
    class func instanceFromNib() -> ChosenPhotoView {
        return UINib.init(nibName: "ChosenPhotoView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ChosenPhotoView
    }
    
    func updateSendButtonTitle() {
        if ChosenPhotosModule.sharedInstance.chosenPhotoArray.count > 0 {
            self.sendButton.backgroundColor = UIColor.init(red: 255/255.0, green: 33/255.0, blue: 74/255.0, alpha: 1)
            self.sendButton.setTitle(String.init(format: "确定(%d)", ChosenPhotosModule.sharedInstance.chosenPhotoArray.count), for: .normal)
        } else {
            self.sendButton.backgroundColor = UIColor.init(red: 0.91, green: 0.93, blue: 0.94, alpha: 1)
            self.sendButton.setTitle("确定", for: .normal)
        }
    }
    
    //MARK: - CollectionView delegate & datasource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ChosenPhotosModule.sharedInstance.chosenPhotoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "ChosenPhotoCell"
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? ChosenPhotoCell
        if cell == nil {
            cell = ChosenPhotoCell()
        }
        
        cell?.asset = ChosenPhotosModule.sharedInstance.chosenPhotoArray[indexPath.row]
        
        weak var weakSelf = self
        cell?.deletePhotoClickedClosure = {
            // 如果删除的图片在当前相册中是已经选中的，那么选中状态改为未选中, 对应的collectionView也需要更新
            for assetModel in CurrentAlbumAssetModule.sharedInstance.assetArray {
                if assetModel.asset == ChosenPhotosModule.sharedInstance.chosenPhotoArray[indexPath.row] {
                    assetModel.isChosen = false
                    if self.delegate != nil {
                        self.delegate?.reloadCurrentPhotoData()
                    }
                }
            }
            
            ChosenPhotosModule.sharedInstance.chosenPhotoArray.remove(at: indexPath.row)
            weakSelf?.collectionView.reloadData()
        }
        
        return cell!
    }
    
}

//
//  AlbumDetailConllectionViewController.swift
//  SwiftTest
//
//  Created by tom555cat on 2017/3/28.
//  Copyright © 2017年 Hello World Corporation. All rights reserved.
//

import UIKit
import Photos

let chosenPhotoViewHeight: CGFloat = 90

class AlbumDetailCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, ReloadDataDelegate {
    
    var albumColletion: PHAssetCollection?
    var collectionView: UICollectionView?
    var chosenPhotoView: ChosenPhotoView?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        CurrentAlbumAssetModule.sharedInstance.assetArray.removeAll()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        CurrentAlbumAssetModule.sharedInstance.assetArray.removeAll()
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CollectionView布局
        let collectionLayout = UICollectionViewFlowLayout.init()
        collectionLayout.minimumLineSpacing = 0
        collectionLayout.minimumInteritemSpacing = 0
        collectionLayout.itemSize = CGSize.init(width: self.view.frame.size.width/4.0, height: self.view.frame.size.width/4.0)
        
        // 创建collectionView
        self.collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - chosenPhotoViewHeight), collectionViewLayout: collectionLayout)
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        let nib = UINib.init(nibName: "PhotoCollectionViewCell", bundle: nil)
        self.collectionView?.register(nib, forCellWithReuseIdentifier: "PhotoCollectionViewCell")
        self.view.addSubview(self.collectionView!)
        
        // 选中图片视图
        self.chosenPhotoView = ChosenPhotoView.instanceFromNib()
        self.chosenPhotoView?.frame = CGRect.init(x: 0, y: self.view.frame.size.height - chosenPhotoViewHeight, width: self.view.frame.size.width, height: chosenPhotoViewHeight)
        self.chosenPhotoView?.delegate = self
        self.chosenPhotoView?.sendButtonClickedClosure = {
            DDLog("在这里配置你的发送相片操作")
            _ = self.navigationController?.popToViewController((self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 3])!, animated: true)   // 返回上上层
        }
        self.view.addSubview(self.chosenPhotoView!)
        
        // 准备数据
        self.setAlbum()
        self.collectionView?.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 预览图片可能选中的图片状态，因此需要更新CollectionView和ChosenPhotoView
        self.collectionView?.reloadData()
        self.chosenPhotoView?.collectionView.reloadData()
        self.chosenPhotoView?.updateSendButtonTitle()
    }
    
    deinit {
        // 当前相册退出时，清理当前相册的状态
        // CurrentAlbumAssetModule.sharedInstance.assetArray.removeAll()
    }
    
    //MARK: - ReloadDataDelegate
    func reloadCurrentPhotoData() {
        self.collectionView?.reloadData()
    }
    
    //MARK: - 设置当前相册图片状态
    func setAlbum() {
        let result = PHAsset.fetchAssets(in: self.albumColletion!, options: nil)
        result.enumerateObjects({ (obj: PHAsset, idx: Int, ptr: UnsafeMutablePointer<ObjCBool>) in
            let assetModel = AssetModel.init(asset: obj, isChosen: false)
            CurrentAlbumAssetModule.sharedInstance.assetArray.append(assetModel)
        })
    }
    
    //MARK: - CollectionViewDelegate & CollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CurrentAlbumAssetModule.sharedInstance.assetArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "PhotoCollectionViewCell"
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? PhotoCollectionViewCell
        if cell == nil {
            cell = PhotoCollectionViewCell()
        }
        let currentAsset = CurrentAlbumAssetModule.sharedInstance.assetArray[indexPath.row].asset
        cell?.asset = currentAsset
        cell?.isChosen = CurrentAlbumAssetModule.sharedInstance.assetArray[indexPath.row].isChosen!
        
        weak var weakCell = cell
        weak var weakSelf = self
        cell?.choosePhotoButtonClickedClosure = {
            weakCell?.isChosen = !((weakCell?.isChosen)!)
            CurrentAlbumAssetModule.sharedInstance.assetArray[indexPath.row].isChosen = weakCell?.isChosen
            
            if weakCell?.isChosen == true {
                // 如果asset是选中，将图片加入
                ChosenPhotosModule.sharedInstance.chosenPhotoArray.append(currentAsset!)
            } else {
                // 如果没有选中
                if ChosenPhotosModule.sharedInstance.chosenPhotoArray.contains(currentAsset!)  {
                    ChosenPhotosModule.sharedInstance.chosenPhotoArray.remove(at: ChosenPhotosModule.sharedInstance.chosenPhotoArray.index(of: currentAsset!)!)
                }
            }
            
            // 更新选中视图信息
            weakSelf?.chosenPhotoView?.collectionView.reloadData()
            weakSelf?.chosenPhotoView?.updateSendButtonTitle()
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let albumPreviewVC = AlbumDetailPreviewViewController.init(photoIndex: indexPath.row)
        self.navigationController?.pushViewController(albumPreviewVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

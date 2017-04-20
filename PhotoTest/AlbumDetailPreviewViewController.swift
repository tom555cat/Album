//
//  AlbumDetailPreviewViewController.swift
//  SwiftTest
//
//  Created by tom555cat on 2017/3/28.
//  Copyright © 2017年 Hello World Corporation. All rights reserved.
//

import UIKit
import Photos

class AlbumDetailPreviewViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, ReloadDataDelegate {
    
    private var collectionView: UICollectionView?
    private var rightItemButton: UIButton?
    private var chosenPhotoView: ChosenPhotoView?
    
    var currentPhotoIndex: Int = 0 {
        didSet {
            if CurrentAlbumAssetModule.sharedInstance.assetArray[currentPhotoIndex].isChosen! {
                self.rightItemButton?.isSelected = true
            } else {
                self.rightItemButton?.isSelected = false
            }
        }
    }
    
    init(photoIndex: Int) {
        super.init(nibName: nil, bundle: nil)
        self.currentPhotoIndex = photoIndex
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CollectionView布局
        let collectionLayout = UICollectionViewFlowLayout.init()
        collectionLayout.minimumLineSpacing = 0
        collectionLayout.minimumInteritemSpacing = 0
        collectionLayout.scrollDirection = .horizontal
        collectionLayout.itemSize = self.view.frame.size
        
        // 创建collectionView
        self.collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - chosenPhotoViewHeight), collectionViewLayout: collectionLayout)
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.isPagingEnabled = true
        self.collectionView?.backgroundColor = UIColor.black
        let nib = UINib.init(nibName: "PhotoPreviewCell", bundle: nil)
        self.collectionView?.register(nib, forCellWithReuseIdentifier: "PhotoPreviewCell")
        self.collectionView?.scrollToItem(at: IndexPath.init(row: self.currentPhotoIndex, section: 0), at: .right, animated: false)
        self.view.addSubview(self.collectionView!)
        
        // 选中图片视图
        self.chosenPhotoView = ChosenPhotoView.instanceFromNib()
        self.chosenPhotoView?.frame = CGRect.init(x: 0, y: self.view.frame.size.height - chosenPhotoViewHeight, width: self.view.frame.size.width, height: chosenPhotoViewHeight)
        self.chosenPhotoView?.delegate = self
        self.chosenPhotoView?.sendButtonClickedClosure = {
            DDLog("图片信息保存在ChosenPhotosModule.sharedInstance.chosenPhotoArray")
            DDLog("在这里配置你的发送相片操作")
            _ = self.navigationController?.popToViewController((self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 4])!, animated: true)   // 返回上上上层
        }
        self.view.addSubview(self.chosenPhotoView!)
        
        // rightItemButton
        self.rightItemButton = UIButton.init(type: .custom)
        self.rightItemButton?.frame = CGRect.init(x: 0, y: 0, width: 23, height: 23)
        self.rightItemButton?.setImage(UIImage.init(named: "unselected"), for: .normal)
        self.rightItemButton?.setImage(UIImage.init(named: "selected"), for: .selected)
        self.rightItemButton?.addTarget(self, action: #selector(choosePhoto), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightItemButton!)
        
        // 处理第一次载入时的按钮选中状态
        if CurrentAlbumAssetModule.sharedInstance.assetArray[currentPhotoIndex].isChosen! {
            self.rightItemButton?.isSelected = true
        } else {
            self.rightItemButton?.isSelected = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.chosenPhotoView?.collectionView.reloadData()
        self.chosenPhotoView?.updateSendButtonTitle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func choosePhoto() {
        
        let currentAsset = CurrentAlbumAssetModule.sharedInstance.assetArray[currentPhotoIndex].asset
        
        if (self.rightItemButton?.isSelected)! {
            
            // 如果已经是选中状态，则需要改成未选中状态，从选中图片中将其删除
            self.rightItemButton?.isSelected = false
            CurrentAlbumAssetModule.sharedInstance.assetArray[currentPhotoIndex].isChosen = false
            if ChosenPhotosModule.sharedInstance.chosenPhotoArray.contains(currentAsset!)  {
                ChosenPhotosModule.sharedInstance.chosenPhotoArray.remove(at: ChosenPhotosModule.sharedInstance.chosenPhotoArray.index(of: currentAsset!)!)
            }
        } else {
            
            // 如果是未选中状态，则更改为选中状态，并加入选中图片中
            self.rightItemButton?.isSelected = true
            CurrentAlbumAssetModule.sharedInstance.assetArray[currentPhotoIndex].isChosen = true
            ChosenPhotosModule.sharedInstance.chosenPhotoArray.append(currentAsset!)
        }
        
        // 更新选中视图中的信息
        self.chosenPhotoView?.collectionView.reloadData()
        self.chosenPhotoView?.updateSendButtonTitle()
    }
    
    //MARK: - ReloadDataDelegate
    func reloadCurrentPhotoData() {
        if CurrentAlbumAssetModule.sharedInstance.assetArray[currentPhotoIndex].isChosen == false {
            self.rightItemButton?.isSelected = false
        } else {
            self.rightItemButton?.isSelected = true
        }
    }
    
    //MARK: - ScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 滚动后修改当前相片index
        self.currentPhotoIndex = Int(scrollView.contentOffset.x) / Int(self.view.frame.size.width)
    }
    
    //MARK: - CollectionViewDelegate & CollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CurrentAlbumAssetModule.sharedInstance.assetArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "PhotoPreviewCell"
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? PhotoPreviewCell
        if cell == nil {
            cell = PhotoPreviewCell()
        }
        cell?.asset = CurrentAlbumAssetModule.sharedInstance.assetArray[indexPath.row].asset
        
        return cell!
    }
}

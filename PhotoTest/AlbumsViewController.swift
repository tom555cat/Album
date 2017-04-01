//
//  AlbumViewController.swift
//  TeamTalkSwift
//
//  Created by tom555cat on 2017/3/28.
//  Copyright © 2017年 Hello World Corporation. All rights reserved.
//

import UIKit
import Photos

class AlbumsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var albumsArray: [PHAssetCollection] = []
    var tableView: UITableView?
    var chosenPhotoView: ChosenPhotoView?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        // 清理上次选中的图片
        ChosenPhotosModule.sharedInstance.chosenPhotoArray.removeAll()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - chosenPhotoViewHeight), style: .plain)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.tableFooterView = UIView.init()
        self.view.addSubview(self.tableView!)
        
        // 选中图片视图
        self.chosenPhotoView = ChosenPhotoView.instanceFromNib()
        self.chosenPhotoView?.frame = CGRect.init(x: 0, y: self.view.frame.size.height - chosenPhotoViewHeight, width: self.view.frame.size.width, height: chosenPhotoViewHeight)
        self.chosenPhotoView?.sendButtonClickedClosure = {
            DDLog("在这里配置你的发送相片操作")
            _ = self.navigationController?.popViewController(animated: true)        // 返回上层VC
        }
        self.view.addSubview(self.chosenPhotoView!)
        
        // 读取相册的内容并tableView reload
        self.checkAlbumAuthority()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.chosenPhotoView?.updateSendButtonTitle()
        self.chosenPhotoView?.collectionView.reloadData()
    }
    
    deinit {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkAlbumAuthority() {
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) in
                if status == PHAuthorizationStatus.authorized {
                    self.getAlbumsArray()
                    self.tableView?.reloadData()
                }
            })
        } else {
            self.getAlbumsArray()
            self.tableView?.reloadData()
        }
    }
    
    func getAlbumsArray() {
        // 胶卷相册
        let smartAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil).lastObject!
        self.albumsArray.append(smartAlbum)
        
        // 剩余相册
        let restAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        restAlbums.enumerateObjects({ (album: PHAssetCollection, index: Int, ptr: UnsafeMutablePointer<ObjCBool>) in
            self.albumsArray.append(album)
        })
    }
    
    //MARK: - TableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albumsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "DDAlbumsCellIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: identifier)
        }
        
        let assets = PHAsset.fetchAssets(in: self.albumsArray[indexPath.row], options: nil)
        if assets.count > 0 {
            PHImageManager.default().requestImage(for: assets[0], targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: nil, resultHandler: { (result: UIImage?, info: [AnyHashable : Any]?) in
                cell?.imageView?.image = result
                cell?.layoutSubviews()
            })
        }
        
        cell?.textLabel?.text = self.albumsArray[indexPath.row].localizedTitle
        //cell?.textLabel?.textColor = RGB(145, 145, 145)
        cell?.textLabel?.highlightedTextColor = UIColor.white
        cell?.accessoryType = .disclosureIndicator
        let view = UIView.init(frame: (cell?.frame)!)
        //view.backgroundColor = RGB(246, 93, 137)
        cell?.selectedBackgroundView = view
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let albumDetailVC = AlbumDetailCollectionViewController.init()
        albumDetailVC.albumColletion = self.albumsArray[indexPath.row]
        self.navigationController?.pushViewController(albumDetailVC, animated: true)
    }
}

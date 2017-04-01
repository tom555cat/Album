//
//  ChosenPhotosModel.swift
//  SwiftTest
//
//  Created by tom555cat on 2017/3/28.
//  Copyright © 2017年 Hello World Corporation. All rights reserved.
//

import Foundation
import Photos

//MARK: - 所有选中的图片，可能来自多个相册，与CurrentAlbumAssetModule所区别
class ChosenPhotosModule {
    var chosenPhotoArray: [PHAsset] = []
    static let sharedInstance = ChosenPhotosModule()
}

//MARK: - 相片模型
class AssetModel {
    var asset: PHAsset?
    var isChosen: Bool?
    
    init(asset: PHAsset, isChosen: Bool) {
        self.asset = asset
        self.isChosen = isChosen
    }
}

//MARK: - 当前查看的相册中相片状态
class CurrentAlbumAssetModule {
    
    var assetArray:[AssetModel] = []
    
    static let sharedInstance = CurrentAlbumAssetModule()
}

//封装的日志输出功能（T表示不指定日志信息参数类型）
func DDLog<T>(_ message:T, file:String = #file, function:String = #function,
           line:Int = #line) {
    #if DEBUG
        //获取文件名
        let fileName = (file as NSString).lastPathComponent
        //打印日志内容
        print("\(fileName):\(line) \(function) | \(message)")
    #endif
}


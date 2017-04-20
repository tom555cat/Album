### 功能有3个页面:
1> 相册页面 AlbumsViewController 
2> 相册缩略图页面 AlbumDetailCollectionViewController
3> 相册预览图页面 AlbumDetailPreviewViewController

页面之间的跳转如下：
入口 -> AlbumsViewController <-> AlbumDetailCollectionViewController <-> AlbumDetailPreviewViewController

### 数据部分主要有2部分：
1> 当前浏览相册 CurrentAlbumAssetModule
2> 已经选中的图片 ChosenPhotosModule
在进入一个相册后，CurrentAlbumAssetModule保存了当前相册的图片以及其是否被选中的状态；当进入另一个相册后，CurrentAlbumAssetModule中的数据就会更新为另一个相册的内容。
ChosenPhotosModule中包含了提交图片之前所选择的图片信息。

### 图片提交功能自定义
3个页面都可以提交当前选择的图片，选择通过什么方式提交可以在3个页面的如下位置添加自己的处理代码
```
self.chosenPhotoView?.sendButtonClickedClosure = {
DDLog("图片信息保存在ChosenPhotosModule.sharedInstance.chosenPhotoArray")
DDLog("在这里配置你的发送相片操作")
_ = self.navigationController?.popToViewController((self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 4])!, animated: true)   // 返回上上上层
}
```

###### 下载地址
<https://github.com/tom555cat/Album.git>

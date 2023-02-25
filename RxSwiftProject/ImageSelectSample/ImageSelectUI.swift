//
//  ImageSelectUI.swift
//  RxSwiftProject
//
//  Created by dhzy on 2023/2/14.
//

import Foundation
import UIKit
import SnapKit

class ImageSelectUI: UIView {
    // 问题：lazy 和oc中的延迟加载是不是一个远离？比OC写法简单很多
    lazy var imageShow = UIImageView()
    lazy var cameraButton = UIButton()
    lazy var galleryButton = UIButton()
    lazy var cropButton = UIButton()
    
    // MARK: life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUIPos()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: public
    
    // MARK: private
    
    // MARK: helper
    func setUIPos() {
        self.addSubview(self.imageShow)
        self.imageShow.layer.borderColor = #colorLiteral(red: 0.9424466491, green: 0.6981263757, blue: 0.6917206645, alpha: 1)
        self.imageShow.layer.cornerRadius = 10
        self.imageShow.layer.borderWidth = 1
        self.imageShow.image = UIImage(named: "image")
        self.imageShow.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp_topMargin).offset(50)
            make.left.equalTo(self.snp_leftMargin).offset(20)
            make.right.equalTo(self.snp_rightMargin).offset(-20)
            // 问题：如何让当前view的大小只有父亲view的一半？
            make.height.equalTo((self.safeAreaInsets.bottom)).offset(self.frame.height * 2 / 5)
        }
        
        self.addSubview(self.cameraButton)
        self.setButtonProperty(view: self.cameraButton)
        self.cameraButton.setTitle("Camera", for: .normal)
        self.cameraButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.imageShow.snp_bottomMargin).offset(50)
            make.centerX.equalTo(self.snp_centerXWithinMargins)
            make.height.equalTo(50)
            // 问题： 这样写允许吗？
            make.width.equalTo(self.frame.width / 3)
        }
        
        self.addSubview(self.galleryButton)
        self.setButtonProperty(view: self.galleryButton)
        self.galleryButton.setTitle("Gallery", for: .normal)
        self.galleryButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.cameraButton.snp_bottomMargin).offset(50)
            make.centerX.equalTo(self.snp_centerXWithinMargins)
            make.size.equalTo(self.cameraButton)
        }

        self.addSubview(self.cropButton)
        self.setButtonProperty(view: self.cropButton)
        self.cropButton.setTitle("Crop", for: .normal)
        self.cropButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.galleryButton.snp_bottomMargin).offset(50)
            make.centerX.equalTo(self.snp_centerXWithinMargins)
            make.size.equalTo(self.galleryButton)
        }
    }
    
    func setButtonProperty(view: UIButton) {
        view.titleLabel?.font = UIFont(name: "PingFangSC-Medium", size: 25)
        view.backgroundColor = #colorLiteral(red: 0.9424466491, green: 0.6981263757, blue: 0.6917206645, alpha: 1)
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0.9424466491, green: 0.6981263757, blue: 0.6917206645, alpha: 1)
        view.titleLabel?.textColor = #colorLiteral(red: 0.9424466491, green: 0.6981263757, blue: 0.6917206645, alpha: 1)
    }
}

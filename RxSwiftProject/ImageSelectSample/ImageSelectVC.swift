//
//  ImageSelect.swift
//  RxSwiftProject
//
//  Created by dhzy on 2023/2/14.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ImageSelect: UIViewController {
    var imageUI: ImageSelectUI!
    var disposeBag = DisposeBag()
    // MARK: init
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem.title = "图片"
        self.tabBarItem.image = UIImage(systemName: "square")
        self.tabBarItem.selectedImage = UIImage(systemName: "square.fill")
        self.view.backgroundColor = .white
        self.navigationItem.title = "222"; //  不显示
        // 问题： 如何让当前view显示出navigationitem.title = “。。。”，已经解决，自定义的画布，需要单独设置一个navigation的UI
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageUI = ImageSelectUI.init(frame: self.view.frame)
        self.view.addSubview(self.imageUI)
        self.setRxSwift()
    }
    
    // MARK: private
    
    
    // MARK: RxSwift
    func setRxSwift() {
        self.imageUI.cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        self.imageUI.cameraButton.rx.tap
            .flatMapLatest { [weak self] _ in
                return UIImagePickerController.rx.createWithParent(self) { picker in
                    picker.sourceType = .camera
                    picker.allowsEditing = false
                }
                .flatMap { $0.rx.didFinishPickingMediaWithInfo }
                .take(1)
            }
            .map { info in
                return info[.originalImage] as? UIImage
            }
            .bind(to: self.imageUI.imageShow.rx.image)
            .disposed(by: disposeBag)
        
        self.imageUI.galleryButton.rx.tap
            .flatMapLatest { [weak self] _ in
                return UIImagePickerController.rx.createWithParent(self) { picker in
                    picker.sourceType = .photoLibrary
                    picker.allowsEditing = false
                }
                .flatMap {
                    $0.rx.didFinishPickingMediaWithInfo
                }
                .take(1)
            }
            .map { info in
                return info[.originalImage] as? UIImage
            }
            .bind(to: self.imageUI.imageShow.rx.image)
            .disposed(by: disposeBag)

        self.imageUI.cropButton.rx.tap
            .flatMapLatest { [weak self] _ in
                return UIImagePickerController.rx.createWithParent(self) { picker in
                    picker.sourceType = .photoLibrary
                    picker.allowsEditing = true
                }
                .flatMap { $0.rx.didFinishPickingMediaWithInfo }
                .take(1)
            }
            .map { info in
                return info[.editedImage] as? UIImage
            }
            .bind(to: self.imageUI.imageShow.rx.image)
            .disposed(by: disposeBag)
    }
}

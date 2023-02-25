//
//  UIImagePickerController+RxCreate.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 1/10/16.
//  Copyright © 2016 Krunoslav Zaher. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// 用来安全有效地关闭模态视图，方便后面使用
func dismissViewController(_ viewController: UIViewController, animated: Bool) {
    /// 是否有控制器在进程中没有显示或消失
    if viewController.isBeingDismissed || viewController.isBeingPresented {
        DispatchQueue.main.async { // 异步递归调用
            dismissViewController(viewController, animated: animated)
        }

        return
    }

    if viewController.presentingViewController != nil {
        viewController.dismiss(animated: animated, completion: nil)
    }
}

extension Reactive where Base: UIImagePickerController {
    /// 创建图片选择控制器Observable
    /// - Parameters:
    ///   - parent: 父控制器
    ///   - animated: 动画
    ///   - configureImagePicker: 配置闭包
    static func createWithParent(_ parent: UIViewController?, animated: Bool = true, configureImagePicker: @escaping (UIImagePickerController) throws -> Void = { x in }) -> Observable<UIImagePickerController> {
        return Observable.create { [weak parent] observer in
            let imagePicker = UIImagePickerController()
            let dismissDisposable = imagePicker.rx
                .didCancel
                .subscribe(onNext: { [weak imagePicker] _ in
                    guard let imagePicker = imagePicker else {
                        return
                    }
                    dismissViewController(imagePicker, animated: animated)
                })
            
            // 处理配置闭包
            do {
                try configureImagePicker(imagePicker)
            }
            catch let error {
                observer.on(.error(error))
                return Disposables.create()
            }

            guard let parent = parent else {
                observer.on(.completed)
                return Disposables.create()
            }

            parent.present(imagePicker, animated: animated, completion: nil)
            observer.on(.next(imagePicker))
            
            return Disposables.create(dismissDisposable, Disposables.create {
                    dismissViewController(imagePicker, animated: animated)
                })
        }
    }
}

extension Reactive where Base: UIImagePickerController {
    /**
     Reactive wrapper for `delegate` message.
     */
    public var didFinishPickingMediaWithInfo: Observable<[UIImagePickerController.InfoKey : AnyObject]> {
        return delegate
            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:)))
            .map({ (a) in
                return try castOrThrow(Dictionary<UIImagePickerController.InfoKey, AnyObject>.self, a[1])
            })
    }
    /**
     Reactive wrapper for `delegate` message.
     */
    public var didCancel: Observable<()> {
        return delegate
            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:)))
            .map {_ in () }
    }
    
}

private func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
guard let returnValue = object as? T else {
    throw RxCocoaError.castingError(object: object, targetType: resultType)
}
return returnValue
}

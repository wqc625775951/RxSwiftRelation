//
//  StepViewUISample.swift
//  RxSwiftProject
//
//  Created by dhzy on 2023/2/17.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

// vm
struct UserInfo {
    lazy var userName = BehaviorRelay(value: "boss")
    
    lazy var userOrigin = {
        return userName.asObservable().map{
            $0 == "boss" ? "你是管理员" : "你是普通用户"
        }
    }()
}

class TwoBindAndGesture: UIViewController {
    let disposeBag = DisposeBag()
    lazy var textFieldUI = UITextField()
    lazy var showOutputInfo = UILabel()
    lazy var userInfo = UserInfo()
    
    // 问题：改进，使用swipegesture，代替panGesture效果应该更好
    lazy var gestureDirUp = UISwipeGestureRecognizer()
    lazy var gestureDirDown = UISwipeGestureRecognizer()
    lazy var gestureDirLeft = UISwipeGestureRecognizer()
    lazy var gestureDirRight = UISwipeGestureRecognizer()
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUIView()
        self.setRxSwift()
    }
    
    // MARK: RxSwift
    func setRxSwift() {
        // 双向绑定符，好像需要单独重写操作符
        _ = self.textFieldUI.rx.textInput <-> self.userInfo.userName
        
        self.userInfo.userOrigin
            .bind(to: self.showOutputInfo.rx.text)
            .disposed(by: disposeBag)
        
        self.gestureDirUp.rx.event
            .subscribe({ [weak self] _ in
                self?.showAlert(title: "向上手势", str:"手势")
            })
            .disposed(by: disposeBag)
        
        self.gestureDirDown.rx.event
            .subscribe({ [weak self] _ in
                self?.showAlert(title: "向下手势", str:"手势")
            })
            .disposed(by: disposeBag)
        
        self.gestureDirLeft.rx.event
            .subscribe({ [weak self] _ in
                self?.showAlert(title: "向左手势", str:"手势")
            })
            .disposed(by: disposeBag)
        
        self.gestureDirRight.rx.event
            .subscribe({ [weak self] _ in
                self?.showAlert(title: "向右手势", str:"手势")
            })
            .disposed(by: disposeBag)
    }

    // MARK: private
    func initUIView() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.textFieldUI)
        self.textFieldUI.layer.borderWidth = 1
        self.textFieldUI.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaInsets).offset(100)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(200)
        }
        
        self.view.addSubview(self.showOutputInfo)
        self.showOutputInfo.layer.borderWidth = 1
        self.showOutputInfo.textAlignment = .center
        self.showOutputInfo.snp.makeConstraints { (make) in
            make.top.equalTo(self.textFieldUI.snp_bottomMargin).offset(50)
            make.centerX.equalTo(self.view)
            make.height.equalTo(200)
            make.width.equalTo(200)
        }
        
        self.view.addGestureRecognizer(self.gestureDirUp)
        self.gestureDirUp.direction = .up
        self.view.addGestureRecognizer(self.gestureDirDown)
        self.gestureDirDown.direction = .down
        self.view.addGestureRecognizer(self.gestureDirLeft)
        self.gestureDirLeft.direction = .left
        self.view.addGestureRecognizer(self.gestureDirRight)
        self.gestureDirRight.direction = .right
    }
    
    // MARK: action
    func showAlert(title:String, str: String) {
        let alter = UIAlertController(title: title, message: str, preferredStyle: .alert)
        let alterAction = UIAlertAction(title: "确认", style: .cancel, handler: nil)
        alter.addAction(alterAction)
        present(alter, animated: true, completion: nil)
    }
}


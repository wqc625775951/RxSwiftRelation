//
//  ViewController.swift
//  RxSwiftProject
//
//  Created by dhzy on 2023/2/13.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SignUpPage: UIViewController {
    
    var uiView: RxSwiftStudyOne!
    let disposeBag = DisposeBag()
    var alter = RxSwiftStudyOne()
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUIView()
        self.setRxSwift()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.tabBarItem.title = "登陆"
        self.tabBarItem.image = UIImage(systemName: "person")
        self.tabBarItem.selectedImage = UIImage(systemName: "person.fill")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: RxSwift
    func setRxSwift() {
        let isUsernameValid = self.uiView.usernameTexfiled.rx.text.orEmpty
            .map { $0.count >= self.uiView.minimalUsernameLength }
            .share(replay: 1)
        
        let isPasswordValid = self.uiView.passwordTexfiled.rx.text.orEmpty
            .map { $0.count >= self.uiView.minimalPasswordLength }
            .share(replay: 1)
        
        let isNameAndPasswordValid = Observable.combineLatest(isUsernameValid, isPasswordValid) { $0 && $1 }
        .share(replay: 1)
        
        isUsernameValid
            .bind(to: self.uiView.usernameAlert.rx.isHidden)
            .disposed(by: disposeBag)
        
        isUsernameValid
            .bind(to: self.uiView.passwordTexfiled.rx.isEnabled)
            .disposed(by: disposeBag)
        
        isPasswordValid
            .bind(to: self.uiView.passwordAlert.rx.isHidden)
            .disposed(by: disposeBag)
        
        isNameAndPasswordValid
            .bind(to: self.uiView.commitButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        self.uiView.commitButton.rx.tap
            .subscribe { [weak self] (element) in self?.buttonAction()}
            .disposed(by: disposeBag)
    }
    
    // MARK: action
    func buttonAction() {
        let alterUI = UIAlertController(  title: "RxExample",
                                          message: "This is wonderful",
                                          preferredStyle: .alert)
        alterUI.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alterUI, animated: true, completion: nil)
    }
    
    // MARK: private
    
    func initUIView() {
        self.view.backgroundColor = .white
        self.uiView = RxSwiftStudyOne.init(frame: self.view.frame)
        self.view.addSubview(self.uiView)
    }
}


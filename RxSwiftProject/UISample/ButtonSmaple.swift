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

class ButtonSample: UIViewController {
    let disposeBag = DisposeBag()
    lazy var buttonRichText = UIButton.init(type: .system)
    lazy var buttonWithSwitch = UIButton.init(type: .system)
    lazy var buttonAction = UIButton.init(type: .system)
    lazy var buttonChangeImg = UIButton.init(type: .system)
    lazy var switchUI = UISwitch()
    
    lazy var buttonSelectedOne = UIButton.init(type: .system)
    lazy var buttonSelectedTwo = UIButton.init(type: .system)
    lazy var buttonSelectedThree = UIButton.init(type: .system)
    
    let time = Observable<Int>.interval(RxTimeInterval.milliseconds(1000), scheduler: MainScheduler.instance)
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUIView()
        self.setRxSwift()
    }
    
    // MARK: RxSwift
    func setSwitchFun() {
        // 根据swift 改变按钮的状态
        self.switchUI.rx.isOn
            .bind(to: self.buttonWithSwitch.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    func setSelected() {
        self.buttonSelectedOne.isSelected = true
        // 给按钮一个选择状态
        let buttonArray = [self.buttonSelectedOne, self.buttonSelectedTwo, self.buttonSelectedThree].map({ $0! })
        // 先初始化一个按钮列表的序列，然后把已经点击过的按钮加入到另一个序列中，将所有的点击合成一个序列
        let selectedArray = Observable.from(buttonArray.map({ (btn) in
            btn.rx.tap.map({ btn })
        }))
        .merge()
        
        for btn in buttonArray {
            selectedArray.map({ btn == $0 })
                .bind(to: btn.rx.isSelected)
                .disposed(by: disposeBag)
        }
    }
    
    func setBackgoundImg() {
        // 更改按钮背景
        time.map({
            let imageName = $0 % 2 == 1 ? "oddNum" : "evenNum"
            return UIImage(named: imageName)!
        })
        .bind(to: self.buttonChangeImg.rx.backgroundImage())
        .disposed(by: disposeBag)
    }
    
    func setRichText() {
        // 设置富文本
        time.map(self.setRichTextAttribute(value:))
            .bind(to: self.buttonRichText.rx.attributedTitle())
            .disposed(by: disposeBag)
    }
    
    func setAction() {
        showMessage(name: "按钮点击")
    }
    
    func setRxSwift() {
        self.buttonRichText.rx.tap
            .bind { [weak self] in
                self?.setRichText()
            }.disposed(by: disposeBag)
  
        self.buttonWithSwitch.rx.tap
            .bind { [weak self] in
                self?.setSwitchFun()
            }.disposed(by: disposeBag)
        
        self.buttonAction.rx.tap
            .bind { [weak self] in
                self?.setAction()
            }.disposed(by: disposeBag)
        
        self.buttonChangeImg.rx.tap
            .bind { [weak self] in
                self?.setBackgoundImg()
            }.disposed(by: disposeBag)
        
        self.setSelected()
    }
    
    // MARK: helper
    func setRichTextAttribute(value: NSInteger) ->  NSMutableAttributedString {
        // %0.2d的意思是输出占2位,若位数不够则补0. 例如:输出的数是8.对应的输出的结果是 08.
        let str = String(format: "%0.2d:%0.2d:%0.1d", arguments: [(value / 600) % 600, (value % 600) / 10, value % 10])
        
        //富文本设置
        let attributeString = NSMutableAttributedString(string: str)
        //从文本0开始6个字符字体HelveticaNeue-Bold,16号
        attributeString.addAttribute(NSAttributedString.Key.font,
                                     value: UIFont(name: "HelveticaNeue-Bold", size: 40)!,
                                     range: NSMakeRange(0, 2))
        
        attributeString.addAttribute(NSAttributedString.Key.font,
                                     value: UIFont(name: "HelveticaNeue-Bold", size: 30)!,
                                     range: NSMakeRange(2, 3))
        
        attributeString.addAttribute(NSAttributedString.Key.font,
                                     value: UIFont(name: "HelveticaNeue-Bold", size: 20)!,
                                     range: NSMakeRange(5, 2))
        
        //设置字体颜色
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor,
                                     value: UIColor.white, range: NSMakeRange(0, 5))
        //设置文字背景颜色
        attributeString.addAttribute(NSAttributedString.Key.backgroundColor,
                                     value: UIColor.orange, range: NSMakeRange(0, 5))
        return attributeString
    }
    
    // MARK: Action
    
    func showMessage(name: String) {
        let alterUI = UIAlertController(title: name, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "确认", style: .cancel, handler: nil)
        alterUI.addAction(action)
        present(alterUI, animated: true, completion: nil)
    }
    
    // MARK: private
    
    func initUIView() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.buttonRichText)
        setButtonStyle(button: self.buttonRichText, title: "设置富文本", fontSize: 30)
        self.buttonRichText.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaInsets).offset(100)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(200)
        }
        
        self.view.addSubview(self.switchUI)
        self.switchUI.snp.makeConstraints { (make) in
            make.top.equalTo(self.buttonRichText.snp_bottomMargin).offset(50)
            make.left.equalTo(self.view).offset(40)
        }
        
        self.view.addSubview(self.buttonWithSwitch)
        setButtonStyle(button: self.buttonWithSwitch, title: "Switch控制", fontSize: 30)
        self.buttonWithSwitch.snp.makeConstraints { (make) in
            make.top.equalTo(self.buttonRichText.snp_bottomMargin).offset(50)
            make.left.equalTo(self.switchUI.snp_rightMargin).offset(20)
            make.height.equalTo(50)
            make.width.equalTo(300)
        }
        
        self.view.addSubview(self.buttonAction)
        setButtonStyle(button: self.buttonAction, title: "Action", fontSize: 30)
        self.buttonAction.snp.makeConstraints { (make) in
            make.top.equalTo(self.buttonWithSwitch.snp_bottomMargin).offset(50)
            make.centerX.equalTo(self.buttonRichText)
            make.height.equalTo(self.buttonRichText)
            make.width.equalTo(self.buttonRichText)
        }
        
        self.view.addSubview(self.buttonChangeImg)
        setButtonStyle(button: self.buttonChangeImg, title: "改变背景图像", fontSize: 30)
        self.buttonChangeImg.snp.makeConstraints { (make) in
            make.top.equalTo(self.buttonAction.snp_bottomMargin).offset(50)
            make.centerX.equalTo(self.buttonRichText)
            make.height.equalTo(self.buttonRichText)
            make.width.equalTo(self.buttonRichText)
        }
        
        self.view.addSubview(self.buttonSelectedOne)
        setButtonStyle(button: self.buttonSelectedOne, title: "按钮1", fontSize: 20)
        buttonSelectedOne.isSelected = true
        self.buttonSelectedOne.snp.makeConstraints { (make) in
            make.top.equalTo(self.buttonChangeImg.snp_bottomMargin).offset(50)
            let distance = self.view.frame.width / 4
            make.height.equalTo(self.buttonRichText)
            make.width.equalTo(distance)
            make.left.equalTo(self.view).offset(20)
        }
        
        self.view.addSubview(self.buttonSelectedTwo)
        setButtonStyle(button: self.buttonSelectedTwo, title: "按钮2", fontSize: 20)
        self.buttonSelectedTwo.snp.makeConstraints { (make) in
            make.top.equalTo(self.buttonChangeImg.snp_bottomMargin).offset(50)
            let distance = self.view.frame.width / 4
            make.height.equalTo(self.buttonRichText)
            make.width.equalTo(distance)
            make.left.equalTo(self.buttonSelectedOne.snp_rightMargin).offset(distance / 3)
        }
        
        self.view.addSubview(self.buttonSelectedThree)
        setButtonStyle(button: self.buttonSelectedThree, title: "按钮3", fontSize: 20)
        self.buttonSelectedThree.snp.makeConstraints { (make) in
            make.top.equalTo(self.buttonChangeImg.snp_bottomMargin).offset(50)
            let distance = self.view.frame.width / 4
            make.height.equalTo(self.buttonRichText)
            make.width.equalTo(distance)
            make.left.equalTo(self.buttonSelectedTwo.snp_rightMargin).offset(distance / 3)
        }
        
    }
}


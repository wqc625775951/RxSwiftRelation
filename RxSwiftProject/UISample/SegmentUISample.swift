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

class SegmentUISample: UIViewController {
    let disposeBag = DisposeBag()
    lazy var segment = UISegmentedControl.init(items: ["one","two"])
    lazy var imgUI = UIImageView()
    lazy var switchUI = UISwitch()
    lazy var labelUI = UILabel()
    lazy var activate = UIActivityIndicatorView(style: .large)
    lazy var slideUI = UISlider()
    lazy var stepUI = UIStepper()
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUIView()
       self.setRxSwift()
    }
    
    // MARK: RxSwift
    func setRxSwift() {
        self.switchUI.rx.value
            .map({ val in
                if val {
                    return "true"
                }
                else {
                    return "false"
                }
            })
            .bind(to: self.labelUI.rx.text)
            .disposed(by: disposeBag)
        
        self.switchUI.rx.isOn
            .bind(to: activate.rx.isAnimating)
            .disposed(by: disposeBag)
        
        let data: Observable<UIImage> = self.segment.rx.selectedSegmentIndex.asObservable()
            .map({
                let images = ["oddNum", "evenNum"]
                return UIImage(named: images[$0])!
            })
        
        data.bind(to: self.imgUI.rx.image)
            .disposed(by: disposeBag)
 
        // slideUI and stepUI
        // 问题：双向绑定 <-> 暂时不会写，后面补上
        stepUI.rx.value
            .map({ Float($0) })
            .bind(to: self.slideUI.rx.value)
            .disposed(by: disposeBag)
        
        slideUI.rx.value
            .map({ Double($0) })
            .bind(to: self.stepUI.rx.value)
            .disposed(by: disposeBag)
    }
    
    // MARK: helper
   
    // MARK: private
    func initUIView() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.segment)
        self.segment.selectedSegmentIndex = 0
        self.segment.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaInsets).offset(100)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(200)
        }
        
        self.view.addSubview(self.imgUI)
        self.imgUI.layer.borderWidth = 2
        self.imgUI.snp.makeConstraints { (make) in
            make.top.equalTo(self.segment.snp_bottomMargin).offset(50)
            make.centerX.equalTo(self.view)
            make.height.equalTo(200)
            make.width.equalTo(200)
        }
        
        self.view.addSubview(self.switchUI)
        self.switchUI.snp.makeConstraints { (make) in
            make.top.equalTo(self.imgUI.snp_bottomMargin).offset(50)
            make.centerX.equalTo(self.view)
        }
        
        self.view.addSubview(self.labelUI)
        self.labelUI.layer.borderWidth = 2
        self.labelUI.textAlignment = .center
        self.labelUI.snp.makeConstraints { (make) in
            make.top.equalTo(self.switchUI.snp_bottomMargin).offset(50)
            make.centerX.equalTo(self.view)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        
        self.view.addSubview(self.activate)
        self.activate.backgroundColor = .black
        self.activate.color = .white
        self.activate.snp.makeConstraints { (make) in
            make.top.equalTo(self.labelUI.snp_bottomMargin).offset(50)
            make.centerX.equalTo(self.view)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        
        self.view.addSubview(self.slideUI)
        self.slideUI.minimumValue = 0
        self.slideUI.maximumValue = 10
        self.slideUI.value = 0
        self.slideUI.snp.makeConstraints { (make) in
            make.top.equalTo(self.activate.snp_bottomMargin).offset(50)
            make.left.equalTo(self.view).offset(40)
            make.height.equalTo(50)
            make.right.equalTo(self.view).offset(-40)
        }
        
        self.view.addSubview(self.stepUI)
        self.stepUI.stepValue = 0.1
        self.stepUI.snp.makeConstraints { (make) in
            make.top.equalTo(self.slideUI.snp_bottomMargin).offset(50)
            make.centerX.equalTo(self.view)
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
    }
}


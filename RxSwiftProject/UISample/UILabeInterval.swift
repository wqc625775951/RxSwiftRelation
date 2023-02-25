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

class UILabelInterval: UIViewController {
    
    var labelTime = UILabel()
    let disposeBag = DisposeBag()
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUIView()
        self.setRxSwift()
    }
    
    // MARK: RxSwift
    func setRxSwift() {
        self.labelTime.backgroundColor = .lightGray
        self.labelTime.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalTo(self.view.snp_leftMargin).offset(30)
            make.right.equalTo(self.view.snp_rightMargin).offset(-30)
            make.height.equalTo(100)
        }
        
        // 定时器
        Observable<Int>.interval(RxTimeInterval.milliseconds(100), scheduler: MainScheduler.instance)
            .map(setRichTextAttribute)
            .bind(to: self.labelTime.rx.attributedText)
            .disposed(by: disposeBag)
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
    
    // MARK: private
    
    func initUIView() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.labelTime)
    }
}


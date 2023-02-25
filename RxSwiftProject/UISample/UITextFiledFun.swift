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

class UITextFieldFun: UIViewController {
    lazy var inputDrive = UITextField()
    lazy var outputDrive = UITextField()
    lazy var labelDrive = UILabel()
    lazy var buttonDrive = UIButton.init(type: .system)
    lazy var combineLabel = UILabel()
    lazy var textviewUI = UITextView()
    lazy var textviewLable = UILabel()
    let disposeBag = DisposeBag()
    
    // MARK: life cycle    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUIView()
        self.setRxSwift()
    }
    
    // MARK: RxSwift
    func setRxSwift() {
        // 将输入框和输出框的内容绑定
        let input = self.inputDrive.rx.text.orEmpty.asDriver()
        input.drive(self.outputDrive.rx.text)
            .disposed(by: disposeBag)
        
        // 将输入框中数据的个数显示在label中，
        // 问题：存在drive,那么这个序列不会产生错误事件并且一定在主线程监听。使用起来不方便和bind的使用容易混
        input.map{ "当前字数：\($0.count)" }
            .drive(self.labelDrive.rx.text)
            .disposed(by: disposeBag)
        
        // 按钮的点击事件
        self.buttonDrive.rx.tap
            // 问题：rxswift 书写的标准格式是啥？
            .subscribe({[weak self] _ in self?.buttonAction()})
            .disposed(by: disposeBag)
    
        
        // 当输入框中的数据大于5个的时候可用, 问题：如何给按钮设置点击之后的动画呢？就是给人一种点击的感觉？已经解决，设置按钮属性
        input.map{ $0.count > 2 }
            .drive(self.buttonDrive.rx.isEnabled)
            .disposed(by: disposeBag)
     
        // 合并文本
        Observable.combineLatest(self.inputDrive.rx.text.orEmpty, self.outputDrive.rx.text.orEmpty) {
            s1, s2 in
            return "合并内容：\(s1) 并 \(s2)"
        }
        .map{ $0 }
        .bind(to: self.combineLabel.rx.text)
        .disposed(by: disposeBag)
        
        /*
        （1）通过 rx.controlEvent 可以监听输入框的各种事件，且多个事件状态可以自由组合。除了各种 UI 控件都有的 touch 事件外，输入框还有如下几个独有的事件：
         editingDidBegin：开始编辑（开始输入内容）
         editingChanged：输入内容发生改变
         editingDidEnd：结束编辑
         editingDidEndOnExit：按下 return 键结束编辑
         allEditingEvents：包含前面的所有编辑相关事件
         */
        
        self.inputDrive.rx.controlEvent(.editingChanged)
            .subscribe(onNext: { (element) in
                print("开始编辑:\(element)")
                // 问题：为什么无法输出文本数据呢？
            })
            .disposed(by: disposeBag)
        
        /*
        （1）UITextView 还封装了如下几个委托回调方法：
         didBeginEditing：开始编辑
         didEndEditing：结束编辑
         didChange：编辑内容发生改变
         didChangeSelection：选中部分发生变化
         */
        self.textviewUI.rx.didBeginEditing
            .subscribe(onNext: {
                self.textviewLable.text = "开始编辑"
            })
        .disposed(by: disposeBag)
        
        self.textviewUI.rx.didEndEditing
            .subscribe(onNext: {
                self.textviewLable.text = "结束编辑"
            })
        .disposed(by: disposeBag)
        
        self.textviewUI.rx.didChange
            .subscribe(onNext: {
                self.textviewLable.text = "编辑内容发生改变"
            })
        .disposed(by: disposeBag)
        
        self.textviewUI.rx.didChangeSelection
            .subscribe(onNext: {
                self.textviewLable.text = "选中部分发生变化"
            })
        .disposed(by: disposeBag)
    }
    
    // MARK: helper
    
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
        self.view.addSubview(self.inputDrive)
        self.inputDrive.borderStyle = UITextField.BorderStyle.line
        self.inputDrive.placeholder = "输入框"
        self.inputDrive.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaInsets.bottom).offset(100)
            make.left.equalTo(self.view).offset(40)
            make.right.equalTo(self.view).offset(-40)
            make.height.equalTo(30)
        }
        
        self.view.addSubview(self.outputDrive)
        self.outputDrive.borderStyle = UITextField.BorderStyle.line
        self.outputDrive.placeholder = "输出框"
        self.outputDrive.snp.makeConstraints { (make) in
            make.top.equalTo(self.inputDrive.snp_bottomMargin).offset(50)
            make.left.equalTo(self.inputDrive)
            make.right.equalTo(self.inputDrive)
            make.height.equalTo(self.inputDrive)
        }
        
        // 问题： 如何 button-100-中线-100-label，以中线为轴的对称结构
        self.view.addSubview(self.buttonDrive)
        setButtonStyle(button: self.buttonDrive, title: "commit", fontSize: 20)
        self.buttonDrive.layer.cornerRadius = 10
        self.buttonDrive.snp.makeConstraints { (make) in
            make.top.equalTo(self.outputDrive.snp_bottomMargin).offset(50)
            make.left.equalTo(self.view).offset(100)
            make.height.equalTo(self.inputDrive)
            make.width.equalTo(100)
        }
        
        // 问题： 如何 button-100-中线-100-label
        self.view.addSubview(self.labelDrive)
        self.labelDrive.layer.borderWidth = 1
        self.labelDrive.snp.makeConstraints { (make) in
            make.top.equalTo(self.outputDrive.snp_bottomMargin).offset(50)
            make.left.equalTo(self.buttonDrive.snp_rightMargin).offset(50)
            make.height.equalTo(self.buttonDrive)
            make.width.equalTo(self.buttonDrive)
        }
        
        self.view.addSubview(self.combineLabel)
        self.combineLabel.layer.borderWidth = 1
        self.combineLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.labelDrive.snp_bottomMargin).offset(50)
            make.left.equalTo(self.outputDrive)
            make.height.equalTo(self.outputDrive)
            make.width.equalTo(self.outputDrive)
        }
        
        self.view.addSubview(self.textviewUI)
        self.textviewUI.layer.borderWidth = 1
        self.textviewUI.snp.makeConstraints { (make) in
            make.top.equalTo(self.combineLabel.snp_bottomMargin).offset(50)
            make.left.equalTo(self.outputDrive)
            // 问题： 让当前窗口的高度等于父窗口的三分之一，这样写是不是和frame差不多？
            let superViewHeightHalf = self.view.frame.height / 3
            make.height.equalTo(superViewHeightHalf)
            make.width.equalTo(self.outputDrive)
        }
        
        self.view.addSubview(self.textviewLable)
        self.textviewLable.layer.borderWidth = 1
        self.textviewLable.snp.makeConstraints { (make) in
            make.top.equalTo(self.textviewUI.snp_bottomMargin).offset(50)
            make.centerX.equalToSuperview()
            make.height.equalTo(self.labelDrive)
            make.width.equalTo(self.inputDrive)
        }
    }
    
}


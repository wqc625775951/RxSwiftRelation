//
//  DatePickerUISample.swift
//  RxSwiftProject
//
//  Created by dhzy on 2023/2/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class DatePickerUISample: UIViewController {
    let disposeBag = DisposeBag()
    lazy var datePickerUi = UIDatePicker()
    lazy var startButton = UIButton(type: .system)
    lazy var showTimeLabel = UILabel()
    lazy var showCountDownLabel = UILabel()
    
    //  默认的定时器时间, 问题: BehaviorRelay，它可以不停地监听值的变化并发送事件。
    var defaultTime = BehaviorRelay(value: TimeInterval(180))
    
    // 是否打开时间计时器
    var isOpenDatePiker = BehaviorRelay(value: true)
    
    // 规定时间格式，固定写法
    lazy var dataFormat:DateFormatter = {
       let tempTime = DateFormatter()
        tempTime.dateFormat = "yyyy年MM月dd日 HH:mm"
        return tempTime
    }()
    
    // MARK: life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUIView()
        self.setRxSwift()
    }
    
    // MARK: RxSwift
    
    func setRxSwift() {
        self.datePickerUi.rx.date
            .map({ [weak self] val in
                "当前的时间是：" + self!.dataFormat.string(from: val)
            })
            .bind(to: self.showTimeLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 问题: 主线程设置双向绑定，不知道为什么这样写
        DispatchQueue.main.async {
            // 如果使用UIDatePicker时将模式设置为CountDownTimer，即可让该控件作为倒计时器来使用
            _ = self.datePickerUi.rx.countDownDuration  <-> self.defaultTime
        }
        
        // 绑定按钮内容
        // combineLatest: 将多个Observables中最新的元素通过一个函数组合起来，然后将这个组合的结果发出来。
        Observable.combineLatest(defaultTime.asObservable(), isOpenDatePiker.asObservable()) { leftTimeValue, countValue in
            if countValue {
                return "开始"
            }else {
                return "倒计时开始，还有 \(Int(leftTimeValue)) 秒..."
            }
        }.bind(to: self.startButton.rx.title()).disposed(by: disposeBag)
        
        // 绑定button和datepicker状态（在倒计过程中，按钮和时间选择组件不可用)
        isOpenDatePiker.asDriver().drive(self.startButton.rx.isEnabled).disposed(by: disposeBag)
        isOpenDatePiker.asDriver().drive(self.datePickerUi.rx.isEnabled).disposed(by: disposeBag)
        
        self.startButton.rx.tap
            .subscribe({
                [weak self] _ in
                self?.startClicked()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: action
    //开始倒计时
    func startClicked() {
        //开始倒计时
        var isOpenDatePikerValue = self.isOpenDatePiker.value
        isOpenDatePikerValue = false
        self.isOpenDatePiker.accept(isOpenDatePikerValue)
        
        //创建一个计时器
        Observable<Int>.interval(RxTimeInterval.milliseconds(1000), scheduler: MainScheduler.instance)
            //filter 可以帮忙过滤掉假的，
            .take(until: isOpenDatePiker.asObservable().filter{ $0 }) //倒计时结束时停止计时器
            .subscribe { _ in
                //每次剩余时间减1
                var defaultTimeValue = self.defaultTime.value
                defaultTimeValue -= 1
                // 如果剩余时间小于等于0
                if(self.defaultTime.value == 0) {
                    print("倒计时结束！")
                    //结束倒计时
                    isOpenDatePikerValue = true
                    //重制时间
                    defaultTimeValue = 180
                }
                self.isOpenDatePiker.accept(isOpenDatePikerValue)
                self.defaultTime.accept(defaultTimeValue)
            }.disposed(by: disposeBag)
    }
    
    // MARK: private
    
    func initUIView() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.datePickerUi)
        self.datePickerUi.datePickerMode = UIDatePicker.Mode.countDownTimer
        self.datePickerUi.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaInsets).offset(100)
            make.centerX.equalToSuperview()
            make.height.equalTo(300)
            make.width.equalTo(300)
        }
        
        self.view.addSubview(self.startButton)
        setButtonStyle(button: self.startButton, title: "开始", fontSize: 16, color: .red)
        self.startButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.datePickerUi.snp_bottomMargin).offset(100)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(300)
        }
        
        self.view.addSubview(self.showCountDownLabel)
        self.showCountDownLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.datePickerUi.snp_bottomMargin).offset(100)
            make.centerX.equalTo(self.view.snp_centerXWithinMargins)
            make.height.equalTo(50)
            make.width.equalTo(300)
        }
        
        self.view.addSubview(self.showTimeLabel)
        showTimeLabel.textAlignment = .center
        self.showTimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.startButton.snp_bottomMargin).offset(100)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(400)
        }
    }
}



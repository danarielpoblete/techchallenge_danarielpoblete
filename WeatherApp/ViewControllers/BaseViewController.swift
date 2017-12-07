//
//  BaseViewController.swift
//  WeatherApp
//
//  Created by Dan.Poblete on 7/12/17.
//  Copyright © 2017 danarielpoblete. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import PureLayout

public class BaseViewController: UIViewController {
    
    // MARK: - Properties
    public var viewDidAppearAnimated: Driver<Bool> {
        return _viewDidAppearAnimated.asDriver(onErrorJustReturn: false)
    }
    
    private let _viewDidAppearAnimated = PublishSubject<Bool>()
    
    public var viewWillAppearAnimated: Driver<Bool> {
        return _viewWillAppearAnimated.asDriver(onErrorJustReturn: false)
    }
    
    private let _viewWillAppearAnimated = PublishSubject<Bool>()
    
    // MARK: - Overrides
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        _viewDidAppearAnimated.onNext(animated)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        _viewWillAppearAnimated.onNext(animated)
    }
}

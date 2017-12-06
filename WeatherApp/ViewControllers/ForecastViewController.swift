//
//  ForecastViewController.swift
//  WeatherApp
//
//  Created by Dan.Poblete on 7/12/17.
//  Copyright © 2017 danarielpoblete. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import PureLayout

final class ForecastViewController: UIViewController {
    
    // MARK: - Properties
    // Views
    public let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    // Helpers
    private var viewDidAppearAnimated: Driver<Bool> {
        return _viewDidAppearAnimated.asDriver(onErrorJustReturn: false)
    }
    
    private let _viewDidAppearAnimated = PublishSubject<Bool>()
    private let disposeBag = DisposeBag()
    
    // Dependencies
    private let viewModel: ForecastViewModelProtocol
    
    // MARK: - Init
    init(viewModel: ForecastViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        _viewDidAppearAnimated.onNext(animated)
    }
    
    // MARK: - Setup
    private func setup() {
        setupViews()
        setupConstraints()
        setupBindings()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        activityIndicator.hidesWhenStopped = true
    }
    
    private func setupConstraints() {
        view.addSubview(activityIndicator)
        
        activityIndicator.autoCenterInSuperview()
    }
    
    private func setupBindings() {
        viewDidAppearAnimated
            .drive(onNext: { [unowned self] _ in
                self.viewModel.fetchForecast()
            })
            .disposed(by: disposeBag)
        
        viewModel.fetchForecastStatus
            .drive(onNext: { [unowned self] status in
                switch status {
                case .busy: self.activityIndicator.startAnimating()
                case .idle: fallthrough
                case .success: fallthrough
                case .failed: self.activityIndicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
        
    }
}

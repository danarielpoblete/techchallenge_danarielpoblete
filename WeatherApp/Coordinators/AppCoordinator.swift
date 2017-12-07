//
//  AppCoordinator.swift
//  WeatherApp
//
//  Created by Dan.Poblete on 8/12/17.
//  Copyright © 2017 danarielpoblete. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

public final class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    // Helpers
    var rootViewController: UIViewController {
        return self.navigationController
    }
    
    let window: UIWindow
    
    private lazy var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        return navigationController
    }()
    
    private let disposeBag = DisposeBag()
    
    // Coordinator protocol
    public var services: Services
    public var childCoordinators: [Coordinator] = []
    
    // MARK: - Init
    public init(window: UIWindow, services: Services) {
        self.services = services
        self.window = window
        
        self.window.rootViewController = rootViewController
        self.window.makeKeyAndVisible()
    }
    
    // MARK: - Public Methods
    public func start() {
        self.showForecastViewController()
    }
    
    // MARK: - Private Methods
    private func showForecastViewController() {
        let viewModel = ForecastViewModel(weatherAPIService: services.weatherAPIService)
        let viewController = ForecastViewController(viewModel: viewModel)
        self.navigationController.viewControllers = [viewController]
        
        viewModel.action
            .subscribe(onNext: { [unowned self] action in
                switch action {
                case .fetchForecast: break
                case .showForecastData(let forecastData, let location):
                    self.showForecastDataViewController(forecastData: forecastData, location: location)
                }
            })
            .disposed(by: disposeBag)
    }

    private func showForecastDataViewController(forecastData: ForecastData, location: String) {
        let viewModel = ForecastDataViewModel(forecastData: forecastData, location: location)
        let viewController = ForecastDataViewController(viewModel: viewModel)
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

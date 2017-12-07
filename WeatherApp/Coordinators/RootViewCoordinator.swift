//
//  RootViewCoordinator.swift
//  WeatherApp
//
//  Created by Dan.Poblete on 8/12/17.
//  Copyright © 2017 danarielpoblete. All rights reserved.
//

import Foundation
import UIKit

public protocol RootViewControllerProvider: class {
    var rootViewController: UIViewController { get }
}

public typealias RootViewCoordinator = Coordinator & RootViewControllerProvider

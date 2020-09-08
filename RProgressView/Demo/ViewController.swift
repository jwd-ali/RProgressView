//
//  ViewController.swift
//  Demo
//
//  Created by Jawad Ali on 08/09/2020.
//  Copyright © 2020 Jawad Ali. All rights reserved.
//

import UIKit
import RProgressView
class ViewController: UIViewController {
    
    private lazy var progessViewMultiColour:RProgressView = {
        let progress = RProgressView()
        progress.isMultiColour = true
        progress.numberOfCircles = 4
         progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    private lazy var progessViewPlain:RProgressView = {
        let progress = RProgressView()
        progress.isMultiColour = false
        progress.numberOfCircles = 2
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    private lazy var progessViewPlainHoldingView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var progessViewMultiColourHoldingView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stack = UIStackViewFactory.createStackView(with: .vertical, alignment: .center, distribution: .fillEqually,arrangedSubviews: [progessViewMultiColourHoldingView,progessViewPlainHoldingView])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(stack)
        
        stack
            .alignAllEdgesWithSuperview()
        
        progessViewMultiColourHoldingView
            .alignEdgesWithSuperview([.left,.right])
        
        progessViewPlainHoldingView
        .alignEdgesWithSuperview([.left,.right])

    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touches begain")
        progessViewMultiColour.startAnimating(in: progessViewMultiColourHoldingView, isConstraintsSet: true)
        progessViewPlain.startAnimating(in: progessViewPlainHoldingView, isConstraintsSet: true)
        
        progessViewPlain
            .width(with: .width, ofView: view, multiplier: 0.6)
            .height(with: .width, ofView: progessViewPlain)
            .centerInSuperView()
        
        progessViewMultiColour
            .width(with: .width, ofView: view, multiplier: 0.6)
            .height(with: .width, ofView: progessViewPlain)
            .centerInSuperView()
        
        
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        progessViewMultiColour.stopAnimating()
        progessViewPlain.stopAnimating()
    }
}


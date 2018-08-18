//
//  PlayerViewController.swift
//  MusicAppTransition
//
//  Created by xxxAIRINxxx on 2018/08/03.
//  Copyright © 2018 xxxAIRINxxx. All rights reserved.
//

import UIKit
import Movin

final class PlayerViewController: UIViewController {
    
    @IBOutlet private(set) weak var nameLabel: UILabel!
    @IBOutlet private(set) weak var imageView: UIImageView!
    @IBOutlet private(set) weak var imageLayerView: UIView!
    @IBOutlet private(set) weak var backgroundView: UIView!
    @IBOutlet private(set) weak var blurView: UIVisualEffectView!
    @IBOutlet private(set) weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.layer.cornerRadius = 5
        
        self.imageLayerView.clipsToBounds = false
        self.imageLayerView.layer.masksToBounds = false
        
        self.imageLayerView.layer.shadowOpacity = 0.8
        self.imageLayerView.layer.shadowColor = UIColor.gray.cgColor
        self.imageLayerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.imageLayerView.layer.shadowRadius = 5
        self.imageLayerView.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("PlayerViewController - viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("PlayerViewController - viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("PlayerViewController - viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("PlayerViewController - viewDidDisappear")
    }
    
    @IBAction private func tapCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }
}

//
//  TopViewController.swift
//  MusicAppTransition
//
//  Created by xxxAIRINxxx on 2018/08/03.
//  Copyright © 2018 xxxAIRINxxx. All rights reserved.
//

import UIKit
import Movin

final class TopViewController: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var imageLayerView: UIView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var miniPlayerView: UIView!
    @IBOutlet private weak var miniPlayerButton : UIButton!

    internal var modalVC: UIViewController?
    private var movin: Movin?
    private var isPresented: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.layer.cornerRadius = 5
        
        self.imageLayerView.clipsToBounds = false
        self.imageLayerView.layer.masksToBounds = false
        
        self.imageLayerView.layer.shadowOpacity = 0.8
        self.imageLayerView.layer.shadowColor = UIColor.gray.cgColor
        self.imageLayerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.imageLayerView.layer.shadowRadius = 2
        self.imageLayerView.layer.cornerRadius = 5
        
        let color = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.8)
        self.miniPlayerButton.setBackgroundImage(self.generateImageWithColor(color), for: .highlighted)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if self.isPresented {
            return .lightContent
        }
        return .default
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("TopViewController - viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("TopViewController - viewDidAppear")
        self.setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("TopViewController - viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("TopViewController - viewDidDisappear")
    }
    
    private func setup() {
        if self.movin != nil { return }
        
        if #available(iOS 11.0, *) {
            self.movin = Movin(1.0, TimingCurve(curve: .easeInOut, dampingRatio: 0.8))
        } else {
            self.movin = Movin(1.0)
        }
        
        let modal = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
        modal.view.layoutIfNeeded()
        
        let miniPlayerOrigin = self.miniPlayerView.frame.origin
        let miniImageFrame = self.imageLayerView.frame
        let originImageFrame = modal.imageView.frame
        let endModalOrigin = CGPoint(x: 0, y: 55)
        
        self.movin!.addAnimations([
            self.containerView.mvn.cornerRadius.from(0.0).to(10.0),
            self.containerView.mvn.alpha.from(1.0).to(0.6),
            self.containerView.mvn.transform.from(CGAffineTransform(scaleX: 1.0, y: 1.0)).to(CGAffineTransform(scaleX: 0.9, y: 0.9)),
            self.tabBarController!.tabBar.mvn.point.to(CGPoint(x: 0.0, y: self.view.frame.size.height)),
            modal.view.mvn.cornerRadius.from(0.0).to(10.0),
            modal.imageView.mvn.frame.from(miniImageFrame).to(originImageFrame),
            modal.imageLayerView.mvn.frame.from(miniImageFrame).to(originImageFrame),
            modal.view.mvn.point.from(miniPlayerOrigin).to(endModalOrigin),
            modal.backgroundView.mvn.alpha.from(0.0).to(1.0),
            modal.nameLabel.mvn.alpha.from(1.0).to(0.0),
            modal.closeButton.mvn.alpha.from(0.0).to(1.0),
            ])
        
        let presentGesture = GestureAnimating(self.miniPlayerView, .top, self.view.frame.size)
        presentGesture.panCompletionThresholdRatio = 0.4
        let dismissGesture = GestureAnimating(modal.view, .bottom, modal.view.frame.size)
        dismissGesture.panCompletionThresholdRatio = 0.25
        dismissGesture.smoothness = 0.5
        
        let transition = Transition(self.movin!, self.tabBarController!, modal, GestureTransitioning(.present, presentGesture, dismissGesture))
        transition.customContainerViewSetupHandler = { [unowned self] type, containerView in
            if type.isPresenting {
                self.miniPlayerView.isHidden = true
                containerView.addSubview(modal.view)
                containerView.addSubview(self.tabBarController!.tabBar)
                modal.view.layoutIfNeeded()
                
                self.isPresented = true
                self.setNeedsStatusBarAppearanceUpdate()
                
                self.tabBarController?.beginAppearanceTransition(false, animated: false)
                modal.beginAppearanceTransition(true, animated: false)
            } else {
                self.tabBarController?.beginAppearanceTransition(true, animated: false)
                modal.beginAppearanceTransition(false, animated: false)
            }
        }
        transition.customContainerViewCompletionHandler = { [unowned self] type, didComplete, containerView in
            self.tabBarController?.endAppearanceTransition()
            modal.endAppearanceTransition()
            
            if type.isDismissing {
                if didComplete {
                    print("complete dismiss")
                    modal.view.removeFromSuperview()
                    self.tabBarController?.tabBar.removeFromSuperview()
                    self.tabBarController?.view.addSubview(self.tabBarController!.tabBar)
                    
                    self.miniPlayerView.isHidden = false
                    self.movin = nil
                    self.modalVC = nil
                    self.isPresented = false
                    self.setNeedsStatusBarAppearanceUpdate()
                    
                    self.setup()
                } else {
                    print("cancel dismiss")
                }
            } else {
                if didComplete {
                    print("complete present")
                } else {
                    print("cancel present")
                    modal.view.removeFromSuperview()
                    self.tabBarController?.tabBar.removeFromSuperview()
                    self.tabBarController?.view.addSubview(self.tabBarController!.tabBar)
                    
                    self.miniPlayerView.isHidden = false
                    self.isPresented = false
                    self.setNeedsStatusBarAppearanceUpdate()
                }
            }
        }
        
        self.modalVC = modal
        modal.modalPresentationStyle = .overCurrentContext
        modal.transitioningDelegate = self.movin!.configureCustomTransition(transition)
    }
    
    fileprivate func generateImageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    @IBAction private func tapMiniPlayerButton() {
        guard let m = self.modalVC else { return }
        self.present(m, animated: true, completion: nil)
    }
}

final class LineView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let topLine = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 0.2))
        UIColor.gray.setStroke()
        topLine.lineWidth = 0.2
        topLine.stroke()
    }
}

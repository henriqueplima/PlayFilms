//
//  RefreshControlCustom.swift
//  PlayFilms
//
//  Created by Henrique Pereira de Lima on 09/12/18.
//  Copyright © 2018 Henrique Pereira de Lima. All rights reserved.
//

import UIKit

class RefreshControlCustom: UICollectionReusableView {
    
    @IBOutlet weak var refreshControlIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lblDescription : UILabel!
    
    var isAnimatingFinal:Bool = false
    var currentTransform:CGAffineTransform?
    
    override func awakeFromNib() {
        self.prepareInitialAnimation()
        debugPrint("chamou awake refresh")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setTransform(inTransform:CGAffineTransform, scaleFactor:CGFloat) {
        if isAnimatingFinal {
            return
        }
        self.currentTransform = inTransform
        self.refreshControlIndicator?.transform = CGAffineTransform.init(scaleX: scaleFactor, y: scaleFactor)
    }
    
    //reset the animation
    func prepareInitialAnimation() {
        self.isAnimatingFinal = false
        self.refreshControlIndicator?.stopAnimating()
        self.refreshControlIndicator?.transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
    }
    
    func startAnimate() {
        self.isAnimatingFinal = true
        self.refreshControlIndicator?.startAnimating()
        self.lblDescription.isHidden = false
    }
    
    func stopAnimate() {
        self.isAnimatingFinal = false
        self.refreshControlIndicator?.stopAnimating()
        self.lblDescription.isHidden = true
    }
    
    //final animation to display loading
    func animateFinal() {
        if isAnimatingFinal {
            return
        }
        self.isAnimatingFinal = true
        UIView.animate(withDuration: 0.2) {
            self.refreshControlIndicator?.transform = CGAffineTransform.identity
        }
    }
        
}

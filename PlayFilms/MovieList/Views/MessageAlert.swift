//
//  MessageAlert.swift
//  PlayFilms
//
//  Created by Henrique Pereira de Lima on 10/12/18.
//  Copyright © 2018 Henrique Pereira de Lima. All rights reserved.
//

import UIKit

class MessageAlert: UIView {
    
    var heightDefault : CGFloat = 100
    
    @IBOutlet weak var lblMessage: UILabel!
    @IBAction func close(_ sender: Any) {
        self.desapearAnimate()
    }
    
    var topConst : NSLayoutConstraint?
    
    static func loadNib() -> MessageAlert{
        let bundle = Bundle(for: MessageAlert.self)
        let nibName = "MessageAlert"
        let nib = UINib(nibName: nibName, bundle: bundle)
        
        return nib.instantiate(withOwner: self, options: nil).first as! MessageAlert
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.alpha = 0
    }
    
    func config(parent:UIView){
        parent.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topConst = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: parent.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0)
        parent.addConstraint(self.topConst!)
        
        parent.addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,multiplier: 1, constant: self.heightDefault))
        parent.addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: parent, attribute: .trailing, multiplier: 1, constant: 0))
        parent.addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: parent, attribute: .leading, multiplier: 1, constant: 0))
        self.frame.size.width = parent.frame.size.width
        self.showAnimate()
    }
    
    func desapearAnimate(){
        self.topConst?.constant = 100 * -1
        UIView.animate(withDuration: 0.5, animations: {
            self.superview?.layoutIfNeeded()
            self.alpha = 0
        }) { (terminou) in
            self.removeFromSuperview()
        }
    }
    
    func showAnimate(){
        self.topConst?.constant = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.superview?.layoutIfNeeded()
            self.alpha = 1
        }) 
    }

}

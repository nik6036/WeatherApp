//
//  Animations.swift
//  WeatherApp
//
//  Created by Nikhil Sakhare on 19/11/17.
//  Copyright © 2017 Nikhil Sakhare. All rights reserved.
//

import Foundation
import UIKit
class Animations: NSObject {
    
    class func animateLabel(_ label: UILabel) -> Void {
        
        label.font = UIFont.boldSystemFont(ofSize: CGFloat(25))
        label.transform = label.transform.scaledBy(x: 0.35, y: 0.35)
        UIView.animate(withDuration: 1.0, animations: {() -> Void in
            label.transform = label.transform.scaledBy(x: 5, y: 5)
            UIView.animate(withDuration: 1.0, animations: {() -> Void in
                label.transform = label.transform.scaledBy(x: 0.35, y: 0.35)
            })
        })
        
    }
    
    class func animateLabelSeries(_ series: Array<UILabel>) {
        
        let delayTime = 100
        for label in series {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delayTime)) {
                animateLabel(label)
            }
        }
    }
    
}


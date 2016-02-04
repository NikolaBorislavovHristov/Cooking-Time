//
//  LoadingServices.swift
//  Cooking Time
//
//  Created by Nikola Hristov on 4/2/16.
//  Copyright © 2016 Nikola Hristov. All rights reserved.
//

import UIKit

@objc class LoadingServices: NSObject {
    static func show() {
        EZLoadingActivity.show("Loading...", disableUI: false);
    }
    
    static func hide() {
        EZLoadingActivity.hide();
    }
    
    static func fail() {
        EZLoadingActivity.hide(success: false, animated: true);
    }
    
    static func success() {
        EZLoadingActivity.hide(success: true, animated: true)
    }
}

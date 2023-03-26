//
//  GASuspendManager.swift
//  GASuspendViewDemo
//
//  Created by Gamin on 2023/3/26.
//  Copyright © 2023 Gamin. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import UIKit

class GASuspendManager {
    
    static let shared = GASuspendManager()
    private var suspendModel: GASuspendModel?

    lazy var suspendView: GASuspendView = {
        let view = GASuspendView(frame: .zero)
        view.tag = 88888
        view.imageLoadFinish = {
            view.isHidden = false
        }
        view.clickedBlock = { [weak self] model in
            print("tap suspendView")
        }
        view.isHidden = true
        return view
    }()
    
    func setSuspendData() {
        setSuspendData(completed: {_ in })
    }
    
    func setSuspendData(completed: @escaping ((GASuspendModel?) -> ())) {
        // request data
        let model = GASuspendModel()
        setSuspendData(model)
        completed(model)
        GASuspendManager.updateSuspendViewShow()
    }
    
    func setSuspendData(_ model: GASuspendModel) {
        suspendModel = model
        setupSuspendView(model)
    }
    
    func setupSuspendView(_ model: GASuspendModel) {
        let vProperty = GASuspendViewProperty()
        vProperty.padding = model.padding
        vProperty.width = model.width
        vProperty.height = model.height
        vProperty.corner = model.corner
        
        // 限制在一个范围内拖动
        vProperty.limitBounds = CGRectMake(vProperty.padding,
                                           navigationBarHeight() + vProperty.padding,
                                           screenWidth()-vProperty.padding*2,
                                           screenHeight() - navigationBarHeight() - tabbarHeight() - 2*vProperty.padding)
        /*
        // 限制只能挨着右侧边框上下拖动
        vProperty.limitBounds = CGRectMake(screenWidth() - vProperty.padding - vProperty.width,
                                           navigationBarHeight() + vProperty.padding,
                                           vProperty.width,
                                           screenHeight() - navigationBarHeight() - tabbarHeight() - 2*vProperty.padding)
         */
        /*
        // 限制只能挨着底部边框左右拖动
        vProperty.limitBounds = CGRectMake(vProperty.padding,
                                           screenHeight() - vProperty.padding - vProperty.height - tabbarHeight(),
                                           screenWidth() - 2*vProperty.padding,
                                           vProperty.height)
         */
                 
        vProperty.startPoint = CGPoint(x: vProperty.limitBounds.origin.x + vProperty.limitBounds.size.width - vProperty.width ,
                                       y: vProperty.limitBounds.origin.y + vProperty.limitBounds.size.height - vProperty.height)
        vProperty.corner = model.corner
        suspendView.vProperty = vProperty
        suspendView.isHidden = true
        suspendView.model = model
        GASuspendManager.appCurrentWindow()?.addSubview(suspendView)
    }
    
    /// 从window获取SuspendView
    func getSuspendViewInWindow() -> GASuspendView? {
        if let view = GASuspendManager.appCurrentWindow()?.viewWithTag(88888) as? GASuspendView {
            return view
        }
        return nil
    }
    
    /// 更新悬浮视图状态
    static func updateSuspendViewShow() {
        let limitVCArr: [String] = ["ViewController", "HomeVC"]
        if let topVC = GASuspendManager.topViewController(), limitVCArr.contains(topVC.className) {
            if GASuspendManager.shared.suspendModel == nil {
                GASuspendManager.shared.getSuspendViewInWindow()?.isHidden = true
            } else {
                GASuspendManager.shared.getSuspendViewInWindow()?.isHidden = false
                if let view = GASuspendManager.shared.getSuspendViewInWindow() {
                    GASuspendManager.appCurrentWindow()?.bringSubviewToFront(view)
                }
            }
        } else {
            GASuspendManager.shared.getSuspendViewInWindow()?.isHidden = true
        }
    }
    
}

extension GASuspendManager {
    
    static func appCurrentWindow() -> UIWindow? {
        if let window = UIApplication.shared.delegate?.window {
            return window
        } else {
            if #available(iOS 13.0, *) {
                return UIApplication.shared.windows.last
            } else {
                return UIApplication.shared.keyWindow
            }
        }
    }
    
    private func isIPhoneX() -> Bool {
        return UIApplication.shared.statusBarFrame.height == 20 ? false : true
    }
    
    private func statusBarHeight() -> CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    
    private func navigationBarHeight() -> CGFloat {
        return UIApplication.shared.statusBarFrame.height + 44
    }
    
    private func tabbarHeight() -> CGFloat {
        return isIPhoneX() ? 49 + 34 : 49
    }
    
    private func screenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }

    private func screenHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    static func topViewController() -> UIViewController? {
        var window = UIApplication.shared.keyWindow
        if window?.windowLevel.rawValue != 0 {
            let windows = UIApplication.shared.windows
            for windowTemp in windows {
                if windowTemp.windowLevel.rawValue == 0{
                    window = windowTemp
                    break
                }
            }
        }
        let vc = window?.rootViewController
        return getTopVC(withCurrentVC: vc)
    }
    
    private static func getTopVC(withCurrentVC VC:UIViewController?) -> UIViewController? {
        if VC == nil {
            return nil
        }
        if let presentVC = VC?.presentedViewController {
            return getTopVC(withCurrentVC: presentVC)
        } else if let tabVC = VC as? UITabBarController {
            if let selectVC = tabVC.selectedViewController {
                return getTopVC(withCurrentVC: selectVC)
            }
            return nil
        } else if let naiVC = VC as? UINavigationController {
            return getTopVC(withCurrentVC:naiVC.visibleViewController)
        } else {
            return VC
        }
    }
    
}

extension NSObject {
    
    public var className: String {
        return type(of: self).className
    }

    public static var className: String {
        return String(describing: self)
    }
    
}


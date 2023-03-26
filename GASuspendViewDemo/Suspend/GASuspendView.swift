//
//  GASuspendView.swift
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
import Kingfisher

class GASuspendView: UIView {
    
    lazy var thumbIV : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .clear
        iv.contentMode = .scaleAspectFill
        iv.isUserInteractionEnabled = false
        return iv
    }()
    var vProperty: GASuspendViewProperty? {
        didSet {
            guard let vo = vProperty else { return }
            self.frame = CGRectMake(vo.startPoint.x, vo.startPoint.y, vo.width, vo.height)
            self.layer.cornerRadius = vo.corner
            self.layer.masksToBounds = true
            thumbIV.frame = self.bounds
        }
    }
    var clickedBlock: ((GASuspendModel?) -> ())?
    var imageLoadFinish: (() -> ())?
    var model: GASuspendModel? {
        didSet {
            guard let vo = model else { return }
            thumbIV.kf.setImage(with: URL(string: vo.thumbPath)) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let value):
                        let _ = value.image
                        self?.imageLoadFinish?()
                        break
                    case .failure(_):
                        break
                    }
                }
            }
        }
    }
    
    deinit {
        clickedBlock = nil
        imageLoadFinish = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(thumbIV)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(gesture:)))
        self.addGestureRecognizer(tap)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction(gesture:)))
        self.addGestureRecognizer(pan)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    @objc func tapAction(gesture: UITapGestureRecognizer) {
        clickedBlock?(model)
    }
    
    @objc func panAction(gesture: UIPanGestureRecognizer) {
        guard let window = GASuspendManager.appCurrentWindow() else { return }
        window.bringSubviewToFront(self)
        let translation = gesture.translation(in: window)
        var center = CGPoint(x: self.center.x + translation.x, y: self.center.y + translation.y)
        if let limitBounds = vProperty?.limitBounds, let width = vProperty?.width, let height = vProperty?.height {
            let limitCenterRect = CGRect(x: limitBounds.origin.x + width/2.0,
                                         y: limitBounds.origin.y + height/2.0,
                                         width: limitBounds.size.width - width,
                                         height: limitBounds.size.height - height)
            if !limitCenterRect.contains(center) {
                if center.x < limitCenterRect.origin.x {
                    center.x = limitCenterRect.origin.x
                }
                if center.x > limitCenterRect.origin.x + limitCenterRect.size.width {
                    center.x = limitCenterRect.origin.x + limitCenterRect.size.width
                }
                if center.y < limitCenterRect.origin.y {
                    center.y = limitCenterRect.origin.y
                }
                if center.y > limitCenterRect.origin.y + limitCenterRect.size.height {
                    center.y = limitCenterRect.origin.y + limitCenterRect.size.height
                }
            }
        }
        self.center = center
        gesture.setTranslation(CGPoint.zero, in: window)
    }
    
}

// MARK: - 浮窗的相关配置属性
class GASuspendViewProperty: NSObject {
    
    /// 限制滑动区域
    var limitBounds: CGRect = UIScreen.main.bounds
    /// 浮窗宽度
    var width: CGFloat = 81
    /// 浮窗高度
    var height: CGFloat = 168
    /// 开始位置
    var startPoint: CGPoint = CGPoint(x: 0, y: 0)
    /// 圆角
    var corner: CGFloat = 0
    /// 边距
    var padding: CGFloat = 10

}

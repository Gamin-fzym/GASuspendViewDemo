//
//  GASuspendModel.swift
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

class GASuspendModel : NSObject {

    var id : String = ""
    /// 名称
    var name : String = ""
    /// 圆角大小
    var corner : CGFloat = 10
    /// 浮窗宽度
    var width: CGFloat = 81
    /// 浮窗高度
    var height: CGFloat = 168
    /// 边距
    var padding: CGFloat = 10
    /// 缩略图
    var thumbPath: String = "https://i0.hdslb.com/bfs/article/957e24b47e456e5950a66854a0b092b8953ef505.jpg"

}


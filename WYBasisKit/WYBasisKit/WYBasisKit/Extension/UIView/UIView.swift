//
//  UIView.swift
//  WYBasisKit
//
//  Created by 官人 on 2020/8/29.
//  Copyright © 2020 官人. All rights reserved.
//

import UIKit

/// 渐变方向
@frozen public enum WYGradientDirection: UInt {
    
    /// 从上到下
    case topToBottom = 0
    /// 从左到右
    case leftToRight = 1
    /// 左上到右下
    case leftToLowRight = 2
    /// 右上到左下
    case rightToLowLeft = 3
}

public extension UIView {
    
    /** view.width */
    var wy_width: CGFloat {
        set {
            var frame: CGRect = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
        get {
            return self.frame.size.width
        }
    }
    
    /** view.height */
    var wy_height: CGFloat {
        set {
            var frame: CGRect = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
        get {
            return self.frame.size.height
        }
    }
    
    /** view.origin.x */
    var wy_left: CGFloat {
        set {
            var frame: CGRect = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.x
        }
    }
    
    /** view.origin.x + view.width */
    var wy_right: CGFloat {
        set {
            var frame: CGRect = self.frame
            frame.origin.x = newValue - frame.size.width
            self.frame = frame
        }
        get {
            return self.frame.origin.x + self.frame.size.width
        }
    }
    
    /** view.origin.y */
    var wy_top: CGFloat {
        set {
            var frame: CGRect = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.y
        }
    }
    
    /** view.origin.y + view.height */
    var wy_bottom: CGFloat {
        set {
            var frame: CGRect = self.frame
            frame.origin.y = newValue - frame.size.height
            self.frame = frame
        }
        get {
            return self.frame.origin.y + self.frame.size.height
        }
    }
    
    /** view.center.x */
    var wy_centerx: CGFloat {
        set {
            var frame: CGRect = self.frame
            frame.origin.x = newValue - (self.frame.size.width / 2.0)
            self.frame = frame
        }
        get {
            return self.frame.origin.x + (self.frame.size.width / 2.0)
        }
    }
    
    /** view.center.y */
    var wy_centery: CGFloat {
        set {
            var frame: CGRect = self.frame
            frame.origin.y = newValue - (self.frame.size.height / 2.0)
            self.frame = frame
        }
        get {
            return self.frame.origin.y + (self.frame.size.height / 2.0)
        }
    }
    
    /** view.origin */
    var wy_origin: CGPoint {
        set {
            var frame: CGRect = self.frame
            frame.origin = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin
        }
    }
    
    /** view.size */
    var wy_size: CGSize {
        set {
            var frame: CGRect = self.frame
            frame.size = newValue
            self.frame = frame
        }
        get {
            return self.frame.size
        }
    }
    
    /**
     *  获取自定义控件所需要的换行数
     *
     *  @param total     总共有多少个自定义控件
     *
     *  @param perLine   每行显示多少个控件
     *
     */
    static func wy_numberOfLines(total: NSInteger, perLine: NSInteger) -> NSInteger {
        if CGFloat(total).truncatingRemainder(dividingBy: CGFloat(perLine)) == 0 {
            return total / perLine
        }else {
            return (total / perLine) + 1
        }
    }
    
    /// 移除所有子控件
    func wy_removeAllSubviews() {
        if subviews.isEmpty == false {
            subviews.forEach({$0.removeFromSuperview()})
        }
    }
    
    /// 移除自身及所有子控件
    func wy_removeFromSuperview() {
        wy_removeAllSubviews()
        removeFromSuperview()
    }
    
    /// 防止View在短时间内快速重复点击
    func wy_temporarilyDisable(for duration: TimeInterval) {
        self.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.isUserInteractionEnabled = true
        }
    }
    
    /// 添加手势点击事件
    @discardableResult
    func wy_addGesture(target: Any?, action: Selector?) -> UITapGestureRecognizer {
        let gestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: target, action: action)
        isUserInteractionEnabled = true
        addGestureRecognizer(gestureRecognizer)
        
        return gestureRecognizer
    }
    
    /// 添加收起键盘的手势
    @discardableResult
    func wy_gestureHidingkeyboard() -> UITapGestureRecognizer {
        let gestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(wy_keyboardHide))
        gestureRecognizer.numberOfTapsRequired = 1
        //设置成false表示当前控件响应后会传播到其他控件上，默认为true
        gestureRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(gestureRecognizer)
        
        return gestureRecognizer
    }
    
    @objc private func wy_keyboardHide() {
        endEditing(true)
    }
}

public extension UIView {
    
    /// 使用链式编程设置圆角、边框、阴影、渐变(调用方式类似SnapKit， 也可直接.语法调用，点语法时需要自己在最后一个设置后面调用wy_showVisual后设置才会生效)
    @discardableResult
    func wy_makeVisual(_ visualView: (_ make: UIView) -> Void) -> UIView {
        visualView(self)
        return wy_showVisual()
    }
    
    @discardableResult
    /// 圆角的位置， 默认4角圆角
    func wy_rectCorner(_ corner: UIRectCorner) -> UIView {
        privateRectCorner = corner
        return self
    }
    
    /// 圆角的半径 默认0.0
    @discardableResult
    func wy_cornerRadius(_ radius: CGFloat) -> UIView {
        privateConrnerRadius = radius
        return self
    }
    
    /// 边框颜色 默认透明
    @discardableResult
    func wy_borderColor(_ color: UIColor) -> UIView {
        privateBorderColor = color
        return self
    }
    
    /// 边框宽度 默认0.0
    @discardableResult
    func wy_borderWidth(_ width: CGFloat) -> UIView {
        if (privateAdjustBorderWidth != width) && (privateAdjustBorderWidth == 0) {
            privateAdjustBorderWidth = privateBorderWidth
        }
        if (privateAdjustBorderWidth > width) {
            privateAdjustBorderWidth = privateAdjustBorderWidth - width
        }
        if (privateAdjustBorderWidth == width) {
            privateAdjustBorderWidth = privateAdjustBorderWidth - (width / 2)
        }
        privateBorderWidth = width
        
        return self
    }
    
    /// 阴影颜色 默认透明
    @discardableResult
    func wy_shadowColor(_ color: UIColor) -> UIView {
        privateShadowColor = color
        return self
    }
    
    /// 阴影偏移度 默认CGSize.zero (width : 为正数时，向右偏移，为负数时，向左偏移，height : 为正数时，向下偏移，为负数时，向上偏移)
    @discardableResult
    func wy_shadowOffset(_ offset: CGSize) -> UIView {
        privateShadowOffset = offset
        return self
    }
    
    /// 阴影半径 默认0.0
    @discardableResult
    func wy_shadowRadius(_ redius: CGFloat) -> UIView {
        privateShadowRadius = redius
        return self
    }
    
    /// 阴影模糊度，默认0.5，取值范围0~1
    @discardableResult
    func wy_shadowOpacity(_ opacity: CGFloat) -> UIView {
        privateShadowOpacity = opacity
        return self
    }
    
    /// 渐变色数组(设置渐变色时不能设置背景色，会有影响)
    @discardableResult
    func wy_gradualColors(_ colors: [UIColor]) -> UIView {
        privateGradualColors = colors
        return self
    }
    
    /// 渐变色方向 默认从左到右
    @discardableResult
    func wy_gradientDirection(_ direction: WYGradientDirection) -> UIView {
        privateGradientDirection = direction
        return self
    }
    
    /// 设置圆角时，会去获取视图的Bounds属性，如果此时获取不到，则需要传入该参数，默认为 nil，如果传入该参数，会设置视图的frame为bounds
    @discardableResult
    func wy_viewBounds(_ bounds: CGRect) -> UIView {
        privateViewBounds = bounds
        return self
    }
    
    /// 贝塞尔路径 默认nil (有值时，radius属性将失效)
    @discardableResult
    func wy_bezierPath(_ path: UIBezierPath) -> UIView {
        privateBezierPath = path
        return self
    }
    
    /// 显示(更新)边框、阴影、圆角、渐变
    @discardableResult
    func wy_showVisual() -> UIView {
        
        // 强制更新布局以确保获取最新尺寸
        self.superview?.layoutIfNeeded()
        self.layoutIfNeeded()
        
        // 抗锯齿边缘
        layer.rasterizationScale = UIScreen.main.scale
        
        // 添加边框、圆角
        wy_addBorderAndRadius()
        // 添加渐变
        wy_addGradual()
        // 添加阴影
        wy_addShadow()
        
        return self
    }
    
    /// 清除边框、阴影、圆角、渐变
    @discardableResult
    func wy_clearVisual() -> UIView {
        
        // 阴影
        if shadowBackgroundView != nil {
            shadowBackgroundView?.removeFromSuperview()
            shadowBackgroundView = nil
        }
        
        // 圆角、边框、渐变
        wy_removeLayer(WYAssociatedKeys.boardLayer)
        wy_removeLayer(WYAssociatedKeys.gradientLayer)
        
        // 恢复默认设置
        privateRectCorner          = .allCorners
        privateConrnerRadius       = 0.0
        privateBorderColor         = .clear
        privateBorderWidth         = 0.0
        privateAdjustBorderWidth   = 0.0
        privateShadowOpacity       = 0.0
        privateShadowRadius        = 0.0
        privateShadowOffset        = .zero
        privateViewBounds          = .zero
        privateShadowColor         = .clear
        privateGradualColors       = nil
        privateGradientDirection   = .leftToRight
        shadowBackgroundView       = nil
        
        layer.cornerRadius   = 0.0
        layer.borderWidth    = 0.0
        layer.borderColor    = UIColor.clear.cgColor
        layer.shadowOpacity  = 0.0
        layer.shadowPath     = nil
        layer.shadowRadius   = 0.0
        layer.shadowColor    = UIColor.clear.cgColor
        layer.shadowOffset   = .zero
        layer.mask           = nil
        
        return self
    }
    
    private func wy_addShadow() {
        
        DispatchQueue.main.async {
            var shadowView = self
            
            if self.shadowBackgroundView != nil {
                self.shadowBackgroundView?.removeFromSuperview()
                self.shadowBackgroundView = nil
            }
            
            // 同时存在阴影和圆角
            if (((self.privateShadowOpacity > 0) && (self.privateConrnerRadius > 0)) || (self.privateBezierPath != nil)) {
                
                if self.superview == nil { wy_print("添加阴影和圆角时，请先将view加到父视图上") }
                
                shadowView = UIView(frame: self.frame)
                shadowView.translatesAutoresizingMaskIntoConstraints = false
                self.superview?.insertSubview(shadowView, belowSubview: self)
                self.superview?.addConstraints([
                    NSLayoutConstraint(item: shadowView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0),
                    NSLayoutConstraint(item: shadowView, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: 0),
                    NSLayoutConstraint(item: shadowView, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1.0, constant: 0),
                    NSLayoutConstraint(item: shadowView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0)])
                
                self.shadowBackgroundView = shadowView
            }
            
            // 圆角
            if ((self.privateConrnerRadius > 0) || (self.privateBezierPath != nil)) {
                let shadowPath: UIBezierPath = self.wy_sharedBezierPath()
                shadowView.layer.shadowPath = shadowPath.cgPath
            }
            
            // 阴影
            shadowView.layer.shadowOpacity = Float(self.privateShadowOpacity)
            shadowView.layer.shadowRadius  = self.privateShadowRadius
            shadowView.layer.shadowOffset  = self.privateShadowOffset
            shadowView.layer.shadowColor   = self.privateShadowColor.cgColor
        }
    }
    
    /// 添加圆角和边框
    private func wy_addBorderAndRadius() {
        DispatchQueue.main.async {
            
            // 移除旧边框图层
            self.wy_removeLayer(WYAssociatedKeys.boardLayer)
            self.layer.mask = nil;
            
            
            // 圆角或阴影或自定义曲线
            if ((self.privateConrnerRadius > 0) || (self.privateShadowOpacity > 0) || (self.privateBezierPath != nil)) {
                
                // 圆角
                if ((self.privateConrnerRadius > 0) || (self.privateBezierPath != nil)) {
                    
                    let bezierPath: UIBezierPath = self.wy_sharedBezierPath()
                    let maskLayer: CAShapeLayer = CAShapeLayer()
                    maskLayer.frame = self.wy_sharedBounds()
                    maskLayer.path = bezierPath.cgPath
                    self.layer.mask = maskLayer
                }
                
                // 边框
                if ((self.privateBorderWidth > 0) || (self.privateBezierPath != nil)) {
                    
                    let bezierPath: UIBezierPath = self.wy_sharedBezierPath()
                    let borderLayer = CAShapeLayer()
                    borderLayer.name = WYAssociatedKeys.boardLayer
                    borderLayer.frame = self.wy_sharedBounds()
                    borderLayer.path = bezierPath.cgPath
                    borderLayer.lineWidth = (self.privateConrnerRadius > 0) ? (self.privateBorderWidth * 2) : self.privateBorderWidth
                    borderLayer.strokeColor = self.privateBorderColor.cgColor
                    borderLayer.fillColor = UIColor.clear.cgColor
                    borderLayer.lineCap = .square
                    borderLayer.lineJoin = .miter
                    self.layer.addSublayer(borderLayer)
                }
                
            }else {
                
                // 只有边框
                let borderLayer = CAShapeLayer()
                borderLayer.name = WYAssociatedKeys.boardLayer
                borderLayer.path = self.wy_sharedBezierPath().cgPath
                borderLayer.fillColor = UIColor.clear.cgColor
                borderLayer.strokeColor = self.privateBorderColor.cgColor
                borderLayer.lineWidth = self.privateBorderWidth
                borderLayer.frame = self.wy_sharedBounds()
                borderLayer.lineCap = .square
                borderLayer.lineJoin = .miter
                self.layer.addSublayer(borderLayer)
            }
        }
    }
    
    /// 添加渐变色
    private func wy_addGradual() {
        DispatchQueue.main.async {
            // 渐变色数组个数必须大于1才能满足渐变要求
            guard (self.privateGradualColors?.count ?? 0) > 1 else {
                // 渐变色数组个数必须大于1才能满足渐变要求
                return
            }
            
            var CGColors: [CGColor] = NSMutableArray.init() as! [CGColor]
            for color: UIColor in self.privateGradualColors! {
                CGColors.append(color.cgColor)
            }
            
            var startPoint: CGPoint!
            var endPoint: CGPoint!
            switch self.privateGradientDirection {
            case .topToBottom:
                startPoint = CGPoint(x: 0.0, y: 0.0)
                endPoint = CGPoint(x: 0.0, y: 1.0)
                break
            case .leftToRight:
                startPoint = CGPoint(x: 0.0, y: 0.0)
                endPoint = CGPoint(x: 1.0, y: 0.0)
                break
            case .leftToLowRight:
                startPoint = CGPoint(x: 0.0, y: 0.0)
                endPoint = CGPoint(x: 1.0, y: 1.0)
                break
            case .rightToLowLeft:
                startPoint = CGPoint(x: 1.0, y: 0.0)
                endPoint = CGPoint(x: 0.0, y: 1.0)
                break
            }
            
            // 新增GradientLayer前先移除上次新增的GradientLayer
            self.wy_removeLayer(WYAssociatedKeys.gradientLayer)
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.name = WYAssociatedKeys.gradientLayer
            gradientLayer.frame = self.wy_sharedBounds()
            gradientLayer.colors = CGColors
            gradientLayer.startPoint = startPoint
            gradientLayer.endPoint = endPoint
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    /// 移除上次添加的layer
    private func wy_removeLayer(_ layerKey: String) {
        
        let layersToRemove = self.layer.sublayers?.filter {
            $0.name == layerKey
        } ?? []
        
        // 统一移除图层
        layersToRemove.forEach {
            $0.removeFromSuperlayer()
        }
    }
    
    private func wy_sharedBounds() -> CGRect {
        
        // 获取在自动布局前的视图大小
        if privateViewBounds.equalTo(.zero) == false {
            return privateViewBounds
        }else {
            if (superview != nil) {
                superview?.layoutIfNeeded()
            }
            
            if bounds.equalTo(.zero) {
                wy_print("设置圆角、边框、阴影、渐变时需要view拥有frame或约束")
            }
            return bounds
        }
    }
    
    private func wy_sharedBezierPath() -> UIBezierPath {
        if privateBezierPath != nil {
            return privateBezierPath!
            
        }else {
            let bounds = wy_sharedBounds()
            
            // 内缩量为边框宽度的一半
            let borderInset = (privateBorderWidth / 2.0)
            // 减去privateAdjustBorderWidth是因为要补全上次减去的边框宽度
            var adjustBorderWidth = privateAdjustBorderWidth
            if (adjustBorderWidth == 0) && (privateConrnerRadius > 0) {
                adjustBorderWidth = (privateBorderWidth / 2)
            }
            if (adjustBorderWidth != 0) && (privateConrnerRadius == 0) {
                adjustBorderWidth = 0
            }
            let adjustedRect = bounds.insetBy(dx: borderInset - adjustBorderWidth, dy: borderInset - adjustBorderWidth)
            // 调整圆角半径防止负值
            let adjustedRadius = max(0, privateConrnerRadius - borderInset)
            
            return UIBezierPath(
                roundedRect: adjustedRect,
                byRoundingCorners: privateRectCorner,
                cornerRadii: CGSize(width: adjustedRadius, height: adjustedRadius)
            )
        }
    }
    
    private var privateRectCorner: UIRectCorner {
        set(newValue) {
            objc_setAssociatedObject(self, WYAssociatedKeys.privateRectCorner, newValue.rawValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return UIRectCorner.init(rawValue: objc_getAssociatedObject(self, WYAssociatedKeys.privateRectCorner) as? UInt ?? UInt(UIRectCorner.allCorners.rawValue))
        }
    }
    
    private var privateConrnerRadius: CGFloat {
        set(newValue) {
            objc_setAssociatedObject(self, WYAssociatedKeys.privateConrnerRadius, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.privateConrnerRadius) as? CGFloat ?? 0.0
        }
    }
    
    private var privateBorderColor: UIColor {
        set(newValue) {
            objc_setAssociatedObject(self, WYAssociatedKeys.privateBorderColor, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.privateBorderColor) as? UIColor ?? .clear
        }
    }
    
    private var privateBorderWidth: CGFloat {
        set(newValue) {
            objc_setAssociatedObject(self, WYAssociatedKeys.privateBorderWidth, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.privateBorderWidth) as? CGFloat ?? 0.0
        }
    }
    
    private var privateAdjustBorderWidth: CGFloat {
        set(newValue) {
            objc_setAssociatedObject(self, WYAssociatedKeys.privateAdjustBorderWidth, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.privateAdjustBorderWidth) as? CGFloat ?? 0.0
        }
    }
    
    private var privateShadowColor: UIColor {
        set(newValue) {
            objc_setAssociatedObject(self, WYAssociatedKeys.privateShadowColor, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.privateShadowColor) as? UIColor ?? .clear
        }
    }
    
    private var privateShadowOffset: CGSize {
        set(newValue) {
            objc_setAssociatedObject(self, WYAssociatedKeys.privateShadowOffset, NSCoder.string(for: newValue), .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return NSCoder.cgSize(for: objc_getAssociatedObject(self, WYAssociatedKeys.privateShadowOffset) as? String ?? (NSCoder.string(for: CGSize.zero)))
        }
    }
    
    private var privateShadowRadius: CGFloat {
        set(newValue) {
            objc_setAssociatedObject(self, WYAssociatedKeys.privateShadowRadius, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.privateShadowRadius) as? CGFloat ?? 0.0
        }
    }
    
    private var privateShadowOpacity: CGFloat {
        set(newValue) {
            objc_setAssociatedObject(self, WYAssociatedKeys.privateShadowOpacity, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.privateShadowOpacity) as? CGFloat ?? 0.5
        }
    }
    
    private var privateGradientDirection: WYGradientDirection {
        set(newValue) {
            objc_setAssociatedObject(self, WYAssociatedKeys.privateGradientDirection, newValue.rawValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return WYGradientDirection.init(rawValue: objc_getAssociatedObject(self, WYAssociatedKeys.privateGradientDirection) as? UInt ?? WYGradientDirection.leftToRight.rawValue) ?? .leftToRight
        }
    }
    
    private var privateGradualColors: [UIColor]? {
        set(newValue) {
            objc_setAssociatedObject(self, WYAssociatedKeys.privateGradualColors, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.privateGradualColors) as? [UIColor]
        }
    }
    
    private var privateViewBounds: CGRect {
        set(newValue) {
            objc_setAssociatedObject(self, WYAssociatedKeys.privateViewBounds, NSCoder.string(for: newValue), .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return NSCoder.cgRect(for: objc_getAssociatedObject(self, WYAssociatedKeys.privateViewBounds) as? String ?? (NSCoder.string(for: CGRect.zero)))
        }
    }
    
    private var privateBezierPath: UIBezierPath? {
        set(newValue) {
            objc_setAssociatedObject(self, WYAssociatedKeys.privateBezierPath, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.privateBezierPath) as? UIBezierPath
        }
    }
    
    private var shadowBackgroundView: UIView? {
        set(newValue) {
            objc_setAssociatedObject(self, WYAssociatedKeys.shadowBackgroundView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, WYAssociatedKeys.shadowBackgroundView) as? UIView
        }
    }
    
    private struct WYAssociatedKeys {
        static let privateRectCorner = UnsafeRawPointer(bitPattern: "privateRectCorner".hashValue)!
        static let privateConrnerRadius = UnsafeRawPointer(bitPattern: "privateConrnerRadius".hashValue)!
        static let privateBorderColor = UnsafeRawPointer(bitPattern: "privateBorderColor".hashValue)!
        static let privateBorderWidth = UnsafeRawPointer(bitPattern: "privateBorderWidth".hashValue)!
        static let privateAdjustBorderWidth = UnsafeRawPointer(bitPattern: "privateAdjustBorderWidth".hashValue)!
        static let privateShadowColor = UnsafeRawPointer(bitPattern: "privateShadowColor".hashValue)!
        static let privateShadowOffset = UnsafeRawPointer(bitPattern: "privateShadowOffset".hashValue)!
        static let privateShadowRadius = UnsafeRawPointer(bitPattern: "privateShadowRadius".hashValue)!
        static let privateShadowOpacity = UnsafeRawPointer(bitPattern: "privateShadowOpacity".hashValue)!
        static let privateGradualColors = UnsafeRawPointer(bitPattern: "privateGradualColors".hashValue)!
        static let privateGradientDirection = UnsafeRawPointer(bitPattern: "privateGradientDirection".hashValue)!
        static let privateViewBounds = UnsafeRawPointer(bitPattern: "privateViewBounds".hashValue)!
        static let privateBezierPath = UnsafeRawPointer(bitPattern: "privateBezierPath".hashValue)!
        static let shadowBackgroundView = UnsafeRawPointer(bitPattern: "shadowBackgroundView".hashValue)!
        static let boardLayer = "\(UnsafeRawPointer(bitPattern: "boardLayer".hashValue)!)"
        static let gradientLayer = "\(UnsafeRawPointer(bitPattern: "gradientLayer".hashValue)!)"
    }
}

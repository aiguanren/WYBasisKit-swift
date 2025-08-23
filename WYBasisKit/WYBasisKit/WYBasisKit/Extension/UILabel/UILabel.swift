//
//  UILabel.swift
//  WYBasisKit
//
//  Created by 官人 on 2020/8/29.
//  Copyright © 2020 官人. All rights reserved.
//

import UIKit
import Foundation
import CoreText

public protocol WYRichTextDelegate {
    
    /**
     *  WYRichTextDelegate
     *
     *  @param richText  点击的字符串
     *  @param range   点击的字符串range
     *  @param index   点击的字符在数组中的index
     */
    func wy_didClick(richText: String, range: NSRange, index: Int)
}

public extension UILabel {
    
    /// 是否打开点击效果,默认开启
    var wy_enableClickEffect: Bool {
        
        set(newValue) {
            objc_setAssociatedObject(self, &WYAssociatedKeys.wy_enableClickEffect, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            wy_isClickEffect = newValue
        }
        get {
            return objc_getAssociatedObject(self, &WYAssociatedKeys.wy_enableClickEffect) as? Bool ?? true
        }
    }
    
    /// 点击效果颜色,默认透明
    var wy_clickEffectColor: UIColor {
        
        set(newValue) {
            objc_setAssociatedObject(self, &WYAssociatedKeys.wy_clickEffectColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &WYAssociatedKeys.wy_clickEffectColor) as? UIColor ?? .clear
        }
    }
    
    /**
     *  给文本添加Block点击事件回调
     *
     *  @param strings  需要添加点击事件的字符串数组
     *  @param handler  点击事件回调
     *
     */
    func wy_addRichText(strings: [String], handler:((_ string: String, _ range: NSRange, _ index: Int) -> Void)? = nil) {
        
        DispatchQueue.main.async {
            self.superview?.layoutIfNeeded()
            self.wy_richTextRanges(strings: strings)
            self.wy_clickBlock = handler
        }
    }
    
    /**
     *  给文本添加点击事件delegate回调
     *
     *  @param strings  需要添加点击事件的字符串数组
     *  @param delegate 富文本代理
     *
     */
    func wy_addRichText(strings: [String], delegate: WYRichTextDelegate) {
        
        DispatchQueue.main.async {
            self.superview?.layoutIfNeeded()
            self.wy_richTextRanges(strings: strings)
            self.wy_richTextDelegate = delegate
        }
    }
}

extension UILabel {
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard wy_isClickAction, let _ = attributedText else {
            return
        }
        wy_isClickEffect = wy_enableClickEffect
        let touch = touches.first
        let point: CGPoint = touch?.location(in: self) ?? .zero
        wy_richTextFrame(touchPoint: point) {[weak self] (string, range, index) in
            
            if let block = self?.wy_clickBlock {
                block(string, range, index)
            }
            
            if let delegate = self?.wy_richTextDelegate {
                delegate.wy_didClick(richText: string, range: range, index: index)
            }
            
            if self?.wy_isClickEffect == true {
                self?.wy_saveEffectDic(range: range)
                self?.wy_clickEffect(true)
            }
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if wy_isClickEffect {
            performSelector(onMainThread: #selector(wy_clickEffect(_:)), with: nil, waitUntilDone: false)
        }
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if wy_isClickEffect {
            performSelector(onMainThread: #selector(wy_clickEffect(_:)), with: nil, waitUntilDone: false)
        }
    }
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        guard wy_isClickAction, attributedText != nil else {
            return super.hitTest(point, with: event)
        }
        
        if wy_richTextFrame(touchPoint: point) {
            return self
        }
        return super.hitTest(point, with: event)
    }
    
    @discardableResult
    private func wy_richTextFrame(touchPoint: CGPoint, handler:((_ string: String, _ range: NSRange, _ index: Int) -> Void)? = nil) -> Bool {
        
        guard let attributedText = attributedText else { return false }
        
        let framesetter = CTFramesetterCreateWithAttributedString(attributedText)
        
        var path = CGMutablePath()
        
        path.addRect(bounds, transform: .identity)
        
        var frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        
        let range = CTFrameGetVisibleStringRange(frame)
        
        if attributedText.length > range.length {
            
            var m_font: UIFont = font ?? UIFont.systemFont(ofSize: 17)
            if let u_font = attributedText.attribute(.font, at: 0, effectiveRange: nil) as? UIFont {
                m_font = u_font
            }
            
            var lineSpace: CGFloat = 0.0
            if let paragraphStyleObj = attributedText.attribute(.paragraphStyle, at: 0, effectiveRange: nil) as? NSParagraphStyle {
                lineSpace = paragraphStyleObj.lineSpacing
            }
            
            path = CGMutablePath()
            path.addRect(CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height + m_font.lineHeight - lineSpace), transform: .identity)
            frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        }
        
        let lines = CTFrameGetLines(frame)
        let count = CFArrayGetCount(lines)
        guard count > 0 else {
            return false
        }
        
        var origins = [CGPoint](repeating: .zero, count: count)
        
        CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), &origins)
        
        let transform = CGAffineTransform(translationX: 0, y: bounds.size.height).scaledBy(x: 1.0, y: -1.0)
        let verticalOffset = 0.0
        
        for i in 0..<count {
            
            let linePoint = origins[i]
            let line = unsafeBitCast(CFArrayGetValueAtIndex(lines, i), to: CTLine.self)
            let flippedRect = wy_sharedBounds(line: line, point: linePoint)
            var rect = flippedRect.applying(transform)
            rect = rect.insetBy(dx: 0, dy: 0)
            rect = rect.offsetBy(dx: 0, dy: CGFloat(verticalOffset))
            
            var lineSpace: CGFloat = 0.0
            if let style = attributedText.attribute(.paragraphStyle, at: 0, effectiveRange: nil) as? NSParagraphStyle {
                lineSpace = style.lineSpacing
            }
            
            let lineOutSpace = (CGFloat(bounds.size.height) - CGFloat(lineSpace) * CGFloat(count - 1) - CGFloat(rect.size.height) * CGFloat(count)) / 2
            
            rect.origin.y = lineOutSpace + rect.size.height * CGFloat(i) + lineSpace * CGFloat(i)
            
            if rect.contains(touchPoint) {
                
                let relativePoint = CGPoint(x: touchPoint.x - rect.minX, y: touchPoint.y - rect.minY)
                var index = CTLineGetStringIndexForPosition(line, relativePoint)
                var offset: CGFloat = 0.0
                CTLineGetOffsetForStringIndex(line, index, &offset)
                if offset > relativePoint.x {
                    index = index - 1
                }
                
                for (j, model) in wy_attributeStrings.enumerated() {
                    
                    let link_range = model.wy_range
                    
                    if NSLocationInRange(index, link_range) {
                        
                        handler?(model.wy_richText, model.wy_range, j)
                        return true
                    }
                }
            }
        }
        return false
    }
    
    private func wy_sharedBounds(line: CTLine, point: CGPoint) -> CGRect {
        
        var ascent: CGFloat = 0.0
        var descent: CGFloat = 0.0
        var leading: CGFloat = 0.0
        
        let width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading)
        let height = ascent + abs(descent) + leading
        
        return CGRect(x: point.x, y: point.y, width: CGFloat(width), height: height)
    }
    
    @objc private func wy_clickEffect(_ status: Bool) {
        
        guard wy_isClickEffect, let effectDic = wy_effectDic, !effectDic.isEmpty, let attributedText = attributedText else {
            return
        }
        
        let attStr = NSMutableAttributedString(attributedString: attributedText)
        let subAtt = NSMutableAttributedString(attributedString: effectDic.values.first!)
        let range = NSRangeFromString(effectDic.keys.first!)
        
        if status {
            subAtt.addAttribute(.backgroundColor, value: wy_clickEffectColor, range: NSRange(location: 0, length: subAtt.length))
        }
        attStr.replaceCharacters(in: range, with: subAtt)
        self.attributedText = attStr
    }
    
    private func wy_saveEffectDic(range: NSRange) {
        
        wy_effectDic = [:]
        
        guard let subAttribute = attributedText?.attributedSubstring(from: range) else { return }
        
        wy_effectDic?[NSStringFromRange(range)] = subAttribute
    }
    
    private func wy_richTextRanges(strings: [String]) {
        
        wy_isClickAction = (attributedText != nil)
        guard let attributedString = attributedText else { return }
        
        wy_isClickEffect = true
        isUserInteractionEnabled = true
        
        var totalString = attributedString.string
        wy_attributeStrings = []
        
        for str in strings {
            let text = attributedString.string
            if let swiftRange = text.range(of: str) {
                let nsrange = NSRange(swiftRange, in: text)
                
                // 用占位字符替换已匹配字符串
                totalString = totalString.replacingCharacters(in: swiftRange, with: wy_sharedString(count: str.count))
                
                var model = WYRichTextModel()
                model.wy_range = nsrange
                model.wy_richText = str
                
                wy_attributeStrings.append(model)
            }
        }
    }
    
    private func wy_sharedString(count: Int) -> String {
        
        return String(repeating: " ", count: count)
    }
    
    private var wy_clickBlock: ((_ richText: String, _ range: NSRange, _ index: Int) -> Void)? {
        
        set(newValue) {
            objc_setAssociatedObject(self, &WYAssociatedKeys.wy_clickBlock, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &WYAssociatedKeys.wy_clickBlock) as? (String, NSRange, Int) -> Void
        }
    }
    
    private var wy_richTextDelegate: WYRichTextDelegate? {
        
        set(newValue) {
            objc_setAssociatedObject(self, &WYAssociatedKeys.wy_richTextDelegate, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return objc_getAssociatedObject(self, &WYAssociatedKeys.wy_richTextDelegate) as? WYRichTextDelegate
        }
    }
    
    private var wy_isClickEffect: Bool {
        
        set(newValue) {
            objc_setAssociatedObject(self, &WYAssociatedKeys.wy_isClickEffect, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &WYAssociatedKeys.wy_isClickEffect) as? Bool ?? true
        }
    }
    
    private var wy_isClickAction: Bool {
        
        set(newValue) {
            objc_setAssociatedObject(self, &WYAssociatedKeys.wy_isClickAction, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &WYAssociatedKeys.wy_isClickAction) as? Bool ?? false
        }
    }
    
    private var wy_attributeStrings: [WYRichTextModel] {
        
        set(newValue) {
            objc_setAssociatedObject(self, &WYAssociatedKeys.wy_attributeStrings, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &WYAssociatedKeys.wy_attributeStrings) as? [WYRichTextModel] ?? []
        }
    }
    
    private var wy_effectDic: [String: NSAttributedString]? {
        
        set(newValue) {
            objc_setAssociatedObject(self, &WYAssociatedKeys.wy_effectDic, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &WYAssociatedKeys.wy_effectDic) as? [String: NSAttributedString]
        }
    }
    
    private struct WYAssociatedKeys {
        static var wy_richTextDelegate: UInt8 = 0
        static var wy_enableClickEffect: UInt8 = 0
        static var wy_isClickEffect: UInt8 = 0
        static var wy_isClickAction: UInt8 = 0
        static var wy_clickEffectColor: UInt8 = 0
        static var wy_attributeStrings: UInt8 = 0
        static var wy_effectDic: UInt8 = 0
        static var wy_clickBlock: UInt8 = 0
        static var wy_transformForCoreText: UInt8 = 0
    }
}

private struct WYRichTextModel {
    var wy_richText: String = ""
    var wy_range: NSRange = NSRange()
}

private extension String {
    
    func nsRange(from range: Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }
    
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
        else { return nil }
        return from ..< to
    }
}

public extension WYRichTextDelegate {
    
    /**
     *  WYRichTextDelegate
     *
     *  @param richText  点击的字符串
     *  @param range   点击的字符串range
     *  @param index   点击的字符在数组中的index
     */
    func wy_didClick(richText: String, range: NSRange, index: Int) {}
}

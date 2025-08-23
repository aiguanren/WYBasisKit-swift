//
//  AttributedString.swift
//  WYBasisKit
//
//  Created by 官人 on 2020/8/29.
//  Copyright © 2020 官人. All rights reserved.
//

import Foundation
import UIKit

public extension NSMutableAttributedString {
    
    /**
     
     *  需要修改的字符颜色数组及量程，由字典组成  key = 颜色   value = 量程或需要修改的字符串
     *  例：Array *colorsOfRanges = @[@{color:@[@"0",@"1"]},@{color:@[@"1",@"2"]}]
     *  或：Array *colorsOfRanges = @[@{color:str},@{color:str}]
     */
    @discardableResult
    func wy_colorsOfRanges(colorsOfRanges: Array<Dictionary<UIColor, Any>>) -> NSMutableAttributedString {
        return wy_applyAttribute(.foregroundColor, valuesOfRanges: colorsOfRanges)
    }
    
    /**
     
     *  需要修改的字符字体数组及量程，由字典组成  key = 颜色   value = 量程或需要修改的字符串
     *  例：Array *fontsOfRanges = @[@{font:@[@"0",@"1"]},@{font:@[@"1",@"2"]}]
     *  或：Array *fontsOfRanges = @[@{font:str},@{font:str}]
     */
    @discardableResult
    func wy_fontsOfRanges(fontsOfRanges: Array<Dictionary<UIFont, Any>>) -> NSMutableAttributedString {
        return wy_applyAttribute(.font, valuesOfRanges: fontsOfRanges)
    }
    
    /// 设置行间距
    @discardableResult
    func wy_lineSpacing(lineSpacing: CGFloat, string: String? = nil, alignment: NSTextAlignment = .left) -> NSMutableAttributedString {
        
        // 确定目标范围（整个文本或指定子串）
        let targetRange: NSRange
        if let substring = string, let range = self.string.range(of: substring) {
            targetRange = NSRange(range, in: self.string)
        } else {
            targetRange = NSRange(location: 0, length: self.length)
        }
        
        guard targetRange.location < self.length else {
            return self
        }
        
        // 获取或创建段落样式
        let paragraphStyle: NSMutableParagraphStyle
        if let existingStyle = self.attribute(.paragraphStyle, at: targetRange.location, effectiveRange: nil) as? NSParagraphStyle,
           let mutableStyle = existingStyle.mutableCopy() as? NSMutableParagraphStyle {
            paragraphStyle = mutableStyle
        } else {
            paragraphStyle = NSMutableParagraphStyle()
        }
        
        // 设置新属性
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment
        
        // 应用更新到目标范围
        self.addAttribute(.paragraphStyle, value: paragraphStyle, range: targetRange)
        
        return self
    }
    
    /// 设置不同段落间的行间距
    @discardableResult
    func wy_lineSpacing(lineSpacing: CGFloat, beforeString: String, afterString: String, alignment: NSTextAlignment = .left) -> NSMutableAttributedString {
        
        guard lineSpacing > 0,
              !beforeString.isEmpty,
              !afterString.isEmpty,
              self.length > 0 else {
            return self
        }
        
        let fullText = self.string
        
        // 查找 beforeString 的位置
        guard let beforeRange = fullText.range(of: beforeString) else {
            return self
        }
        
        // 在 beforeString 之后查找 afterString
        let afterSearchStartIndex = beforeRange.upperBound
        let afterSearchRange = afterSearchStartIndex..<fullText.endIndex
        
        guard let afterRange = fullText.range(of: afterString, options: [], range: afterSearchRange) else {
            return self
        }
        
        // 获取 beforeString 所在段落范围
        let paragraphRange = fullText.paragraphRange(for: beforeRange)
        
        // 创建并配置段落样式
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = lineSpacing
        paragraphStyle.alignment = alignment
        
        let nsParagraphRange = NSRange(paragraphRange, in: fullText)
        
        // 应用段落样式
        self.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: nsParagraphRange
        )
        return self
    }
    
    /// 设置字间距
    @discardableResult
    func wy_wordsSpacing(wordsSpacing: CGFloat, string: String? = nil) -> NSMutableAttributedString {
        
        let targetString = string ?? self.string
        guard let range = self.string.range(of: targetString) else { return self }
        let nsRange = NSRange(range, in: self.string)
        
        addAttributes([.kern: NSNumber(value: Double(wordsSpacing))], range: nsRange)
        
        return self
    }
    
    /// 文本添加下滑线
    @discardableResult
    func wy_underline(color: UIColor, string: String? = nil) -> NSMutableAttributedString {
        
        let targetString = string ?? self.string
        guard let range = self.string.range(of: targetString) else { return self }
        let nsRange = NSRange(range, in: self.string)
        
        addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: nsRange)
        addAttribute(.underlineColor, value: color, range: nsRange)
        
        return self
    }
    
    /// 文本添加删除线
    @discardableResult
    func wy_strikethrough(color: UIColor, string: String? = nil) -> NSMutableAttributedString {
        
        let targetString = string ?? self.string
        guard let range = self.string.range(of: targetString) else { return self }
        let nsRange = NSRange(range, in: self.string)
        
        addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: nsRange)
        addAttribute(.strikethroughColor, value: color, range: nsRange)
        
        return self
    }
    
    /**
     *  文本添加内边距
     *  @param string  要添加内边距的字符串，不传则代码所有字符串
     *  @param firstLineHeadIndent  首行左边距
     *  @param headIndent  第二行及以后的左边距(换行符\n除外)
     *  @param tailIndent  尾部右边距
     */
    @discardableResult
    func wy_innerMargin(string: String? = nil, firstLineHeadIndent: CGFloat = 0, headIndent: CGFloat = 0, tailIndent: CGFloat = 0, alignment: NSTextAlignment = .justified) -> NSMutableAttributedString {
        
        // 确定目标范围（整个文本或指定子串）
        let targetRange: NSRange
        if let substring = string, let range = self.string.range(of: substring) {
            targetRange = NSRange(range, in: self.string)
        } else {
            targetRange = NSRange(location: 0, length: self.length)
        }
        
        // 获取或创建段落样式
        let paragraphStyle: NSMutableParagraphStyle
        
        // 安全地获取并复制现有段落样式
        if let existingStyle = self.attribute(.paragraphStyle, at: targetRange.location, effectiveRange: nil) as? NSParagraphStyle,
           let mutableStyle = existingStyle.mutableCopy() as? NSMutableParagraphStyle {
            paragraphStyle = mutableStyle
        } else {
            paragraphStyle = NSMutableParagraphStyle()
        }
        
        // 设置内边距属性
        paragraphStyle.alignment = alignment
        paragraphStyle.firstLineHeadIndent = firstLineHeadIndent
        paragraphStyle.headIndent = headIndent
        paragraphStyle.tailIndent = tailIndent
        
        // 应用更新到目标范围
        self.addAttribute(.paragraphStyle, value: paragraphStyle, range: targetRange)
        
        return self
    }
    
    /**
     向富文本中插入图片（支持图文混排，自动处理位置和对齐方式）
     
     - Parameter attachments: 富文本图片插入配置数组，每个元素定义了图片、位置、尺寸、对齐方式和间距
     - Returns: 当前 NSMutableAttributedString 对象本身（链式返回）
     
     使用说明：
     1. position 支持插入到指定文本前/后或指定字符下标处；
     2. alignment 支持图片在字体行内的垂直对齐方式；
     3. spacingBefore / spacingAfter 可用于设置插入图片前后的间距；
     */
    @discardableResult
    func wy_insertImage(_ attachments: [WYImageAttachmentOption]) -> NSMutableAttributedString {
        
        if string.isEmpty || attachments.isEmpty {
            return self
        }
        
        let fullText = self.string
        
        // 将插入项统一转换为 (index, attr) 类型，便于排序和插入
        var insertionItems: [(index: Int, attr: NSAttributedString)] = []
        
        for option in attachments {
            
            // 计算插入位置 index
            let insertIndex: Int
            switch option.position {
            case .index(let value):
                insertIndex = max(0, min(self.length, value))
                
            case .before(let target):
                if let range = fullText.range(of: target) {
                    let nsRange = NSRange(range, in: fullText)
                    insertIndex = nsRange.location
                } else {
                    insertIndex = self.length
                }
                
            case .after(let target):
                if let range = fullText.range(of: target) {
                    let nsRange = NSRange(range, in: fullText)
                    insertIndex = nsRange.location + nsRange.length
                } else {
                    insertIndex = self.length
                }
            }
            
            // 构建图片 attachment
            let attachment = NSTextAttachment()
            attachment.image = option.image
            
            // 获取当前索引处的字体
            let lineFont = self.attribute(.font, at: min(insertIndex, self.length - 1), effectiveRange: nil) as? UIFont ?? UIFont.systemFont(ofSize: 15)
            
            // 计算图片(Y)偏移量（文字对齐用）
            let yOffset: CGFloat
            switch option.alignment {
            case .center:
                yOffset = lineFont.ascender - (option.size.height * 0.5)
            case .top:
                yOffset = lineFont.ascender - option.size.height
            case .bottom:
                yOffset = lineFont.descender
            case .custom(let offset):
                yOffset = -offset
            }
            
            attachment.bounds = CGRect(x: 0, y: yOffset, width: option.size.width, height: option.size.height)
            
            let imageAttr = NSAttributedString(attachment: attachment)
            
            // 构建前后间距（使用透明附件）
            let beforeSpace: NSAttributedString
            if option.spacingBefore > 0 {
                let spaceAttachment = NSTextAttachment()
                spaceAttachment.bounds = CGRect(x: 0, y: 0, width: option.spacingBefore, height: 0.01)
                beforeSpace = NSAttributedString(attachment: spaceAttachment)
            } else {
                beforeSpace = NSAttributedString()
            }
            
            let afterSpace: NSAttributedString
            if option.spacingAfter > 0 {
                let spaceAttachment = NSTextAttachment()
                spaceAttachment.bounds = CGRect(x: 0, y: 0, width: option.spacingAfter, height: 0.01)
                afterSpace = NSAttributedString(attachment: spaceAttachment)
            } else {
                afterSpace = NSAttributedString()
            }
            
            // 拼接完整插入内容：前间距 + 图片 + 后间距
            let fullInsert = NSMutableAttributedString()
            fullInsert.append(beforeSpace)
            fullInsert.append(imageAttr)
            fullInsert.append(afterSpace)
            
            // 保存待插入数据
            insertionItems.append((index: insertIndex, attr: fullInsert))
        }
        
        // 倒序插入，避免偏移
        for item in insertionItems.sorted(by: { $0.index > $1.index }) {
            insert(item.attr, at: item.index)
        }
        
        return self
    }
    
    /**
     *  根据传入的表情字符串生成富文本，例如字符串 "哈哈[哈哈]" 会生成 "哈哈😄"
     *  @param emojiString   待转换的表情字符串
     *  @param textColor     富文本的字体颜色
     *  @param textFont      富文本的字体
     *  @param emojiTable    表情解析对照表，如 ["哈哈](哈哈表情对应的图片名)", [嘿嘿(嘿嘿表情对应的图片名)]]
     *  @param bundle        从哪个bundle文件内查找图片资源，如果为空，则直接在本地路径下查找
     *  @param pattern       正则匹配规则, 默认匹配1到3位, 如 [哈] [哈哈] [哈哈哈] 这种
     */
    class func wy_convertEmojiAttributed(emojiString: String, textColor: UIColor, textFont: UIFont, emojiTable: [String], sourceBundle: WYSourceBundle? = nil, pattern: String = "\\[.{1,3}\\]") -> NSMutableAttributedString {
        
        // 字体、颜色
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: textFont,
            .foregroundColor: textColor
        ]
        
        // 获取字体的行高，作为表情的高度
        let attachmentHeight = textFont.lineHeight
        
        // 通过 emojiString 获得 NSMutableAttributedString
        let attributedString = NSMutableAttributedString(string: emojiString, attributes: textAttributes)
        
        // 使用正则
        let regex: NSRegularExpression?
        do {
            regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
        } catch let error {
            WYLogManager.output(error.localizedDescription)
            regex = nil
        }
        
        // 获取到匹配正则的数据
        if let matches = regex?.matches(in: emojiString, options: [], range: NSRange(emojiString.startIndex..., in: emojiString)), !matches.isEmpty {
            // 遍历符合的数据进行解析（倒序替换）
            for result in matches.reversed() {
                // 将 NSRange 转换为 String.Index 范围
                if let range = Range(result.range, in: emojiString) {
                    let emojiStr = String(emojiString[range])
                    
                    // 符合的数据是否为表情
                    if emojiTable.contains(emojiStr) {
                        
                        // 获取表情对应的图片名
                        let image: UIImage = UIImage.wy_find(emojiStr, inBundle: sourceBundle)
                        
                        // 创建一个NSTextAttachment
                        let attachment = WYTextAttachment()
                        attachment.image  = image
                        attachment.imageName = emojiStr
                        attachment.imageRange = result.range
                        
                        let attachmentWidth = attachmentHeight * (image.size.width / image.size.height)
                        
                        attachment.bounds = CGRect(x: 0, y: (textFont.capHeight - textFont.lineHeight)/2, width: attachmentWidth, height: attachmentHeight)
                        
                        // 通过NSTextAttachment生成一个AttributedString
                        let replace = NSAttributedString(attachment: attachment)
                        
                        // 替换表情字符串
                        attributedString.replaceCharacters(in: result.range, with: replace)
                    }
                }
            }
        }
        
        return attributedString
    }
    
    /**
     *  将表情富文本生成对应的富文本字符串，例如表情富文本 "哈哈😄" 会生成 "哈哈[哈哈]"
     *  @param textColor     富文本的字体颜色
     *  @param textFont      富文本的字体
     *  @param replace       未知图片(表情)的标识替换符，默认：[未知]
     */
    func wy_convertEmojiAttributedString(textColor: UIColor, textFont: UIFont, replace: String = "[未知]") -> NSMutableAttributedString {
        
        // 复制原始富文本内容
        let mutableAttributed = NSMutableAttributedString(attributedString: self)
        
        // 枚举附件属性，替换成对应的文字标识
        mutableAttributed.enumerateAttribute(.attachment,
                                             in: NSRange(location: 0, length: mutableAttributed.length),
                                             options: [.reverse]) { value, range, _ in
            
            if let attachment = value as? WYTextAttachment {
                // // 拿到文本附件，自定义表情替换成 imageName
                mutableAttributed.replaceCharacters(in: range, with: attachment.imageName)
            } else if value is NSTextAttachment {
                // 未知附件替换成 replace
                mutableAttributed.replaceCharacters(in: range, with: replace)
            }
        }
        
        // 设置字体和颜色
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: textFont,
            .foregroundColor: textColor
        ]
        mutableAttributed.addAttributes(textAttributes, range: NSRange(location: 0, length: mutableAttributed.length))
        
        return mutableAttributed
    }
}

public extension NSAttributedString {
    
    /// 获取某段文字的frame
    func wy_calculateFrame(range: NSRange, controlSize: CGSize, numberOfLines: Int = 0, lineBreakMode: NSLineBreakMode = .byWordWrapping) -> CGRect {
        
        let textStorage: NSTextStorage = NSTextStorage(attributedString: self)
        let layoutManager: NSLayoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer: NSTextContainer = NSTextContainer(size: controlSize)
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = lineBreakMode
        textContainer.maximumNumberOfLines = numberOfLines
        layoutManager.addTextContainer(textContainer)
        
        var glyphRange: NSRange = NSRange()
        layoutManager.characterRange(forGlyphRange: range, actualGlyphRange: &glyphRange)
        return layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
    }
    
    /// 获取某段文字的frame
    func wy_calculateFrame(subString: String, controlSize: CGSize, numberOfLines: Int = 0, lineBreakMode: NSLineBreakMode = .byWordWrapping) -> CGRect {
        
        guard subString.isEmpty == false else {
            return CGRect.zero
        }
        
        let textStorage = NSTextStorage(attributedString: self)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: controlSize)
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = lineBreakMode
        textContainer.maximumNumberOfLines = numberOfLines
        layoutManager.addTextContainer(textContainer)
        
        guard let range = string.range(of: subString) else {
            return .zero
        }
        let nsRange = NSRange(range, in: string)
        
        var glyphRange = NSRange()
        layoutManager.characterRange(forGlyphRange: nsRange, actualGlyphRange: &glyphRange)
        
        return layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
    }
    
    /// 计算富文本宽度
    func wy_calculateWidth(controlHeight: CGFloat) -> CGFloat {
        return wy_calculateSize(controlSize: CGSize(width: .greatestFiniteMagnitude, height: controlHeight)).width
    }
    
    /// 计算富文本高度
    func wy_calculateHeight(controlWidth: CGFloat) -> CGFloat {
        return wy_calculateSize(controlSize: CGSize(width: controlWidth, height: .greatestFiniteMagnitude)).height
    }
    
    /// 计算富文本宽高
    func wy_calculateSize(controlSize: CGSize) -> CGSize {
        let attributedSize = boundingRect(with: controlSize, options: [.truncatesLastVisibleLine, .usesLineFragmentOrigin, .usesFontLeading], context: nil)
        
        return CGSize(width: ceil(attributedSize.width), height: ceil(attributedSize.height))
    }
    
    /// 获取每行显示的字符串(为了计算准确，尽量将使用到的属性如字间距、缩进、换行模式、字体等设置到调用本方法的attributedString对象中来, 没有用到的直接忽略)
    func wy_stringPerLine(controlWidth: CGFloat) -> [String] {
        
        if (self.string.utf16.count <= 0) {
            return []
        }
        
        let frameSetter: CTFramesetter = CTFramesetterCreateWithAttributedString(self)
        
        let path: CGMutablePath = CGMutablePath()
        
        path.addRect(CGRect(x: 0, y: 0, width: controlWidth, height: CGFloat.greatestFiniteMagnitude))
        
        let frame: CTFrame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil)
        
        var strings = [String]()
        
        if let lines = CTFrameGetLines(frame) as? [CTLine] {
            lines.forEach({
                let linerange = CTLineGetStringRange($0)
                let range = NSMakeRange(linerange.location, linerange.length)
                let subAttributed = NSMutableAttributedString(attributedString: attributedSubstring(from: range))
                let string = subAttributed.wy_convertEmojiAttributedString(textColor: .white, textFont: .systemFont(ofSize: 10)).string
                strings.append(string)
            })
        }
        return strings
    }
    
    /// 判断字符串显示完毕需要几行(为了计算准确，尽量将使用到的属性如字间距、缩进、换行模式、字体等设置到调用本方法的attributedString对象中来, 没有用到的直接忽略)
    func wy_numberOfRows(controlWidth: CGFloat) -> Int {
        return wy_stringPerLine(controlWidth: controlWidth).count
    }
}

public class WYTextAttachment: NSTextAttachment {
    public var imageName: String = ""
    public var imageRange: NSRange = NSMakeRange(0, 0)
}

/// 富文本图片插入配置
public struct WYImageAttachmentOption {
    
    /// 图片插入位置
    public enum Position {
        /// 插入到文本前面
        case before(text: String)
        /// 插入到文本后面
        case after(text: String)
        /// 根据文本下标插入到指定为止
        case index(Int)
    }
    
    /// 图片对齐方式
    public enum Alignment {
        /// 与文本居中对齐
        case center
        /// 与文本顶部对齐
        case top
        /// 与文本底部对齐
        case bottom
        /// 相对文本底部(Y轴)自定义偏移量对齐(负向上，正向下)
        case custom(offset: CGFloat)
    }
    
    /// 要插入的图片
    public let image: UIImage
    
    /// 图片尺寸
    public let size: CGSize
    
    /// 图片插入位置
    public let position: Position
    
    /// 图片对齐方式
    public let alignment: Alignment
    
    /// 图片与前面文本的间距（单位：pt）
    public let spacingBefore: CGFloat
    
    /// 图片与后面文本的间距（单位：pt）
    public let spacingAfter: CGFloat
    
    public init(image: UIImage,
                size: CGSize,
                position: Position,
                alignment: Alignment = .center,
                spacingBefore: CGFloat = 0,
                spacingAfter: CGFloat = 0) {
        self.image = image
        self.size = size
        self.position = position
        self.alignment = alignment
        self.spacingBefore = spacingBefore
        self.spacingAfter = spacingAfter
    }
}

private extension NSMutableAttributedString {
    
    /// 通用方法，根据指定属性和范围数组修改富文本
    @discardableResult
    private func wy_applyAttribute<T>(_ key: NSAttributedString.Key, valuesOfRanges: [[T: Any]] ) -> NSMutableAttributedString {
        
        for dic in valuesOfRanges {
            guard let value = dic.keys.first, let rangeValue = dic.values.first else { continue }
            
            if let rangeStr = rangeValue as? String {
                // 根据字符串查找范围并修改属性
                if let range = self.string.range(of: rangeStr) {
                    let nsRange = NSRange(range, in: self.string)
                    addAttribute(key, value: value, range: nsRange)
                }
            } else if let rangeAry = rangeValue as? [Any],
                      let firstRangeStr = rangeAry.first as? String,
                      let lastRangeStr = rangeAry.last as? String,
                      let location = Int(firstRangeStr),
                      let length = Int(lastRangeStr) {
                
                let safeLength = max(length - location, 0)
                addAttribute(key, value: value, range: NSRange(location: location, length: safeLength))
            }
        }
        return self
    }
}

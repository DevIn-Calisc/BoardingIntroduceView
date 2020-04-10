//
//  BoardingItemModel.swift
//  BoardingIntroduce
//
//  Created by Hung Cao on 4/9/20.
//  Copyright © 2020 Hung Cao. All rights reserved.
//

import UIKit

public struct BoardingItemModel {
    public let informationImage: UIImage
    public let title: String
    public let description: String
    public let pageIcon: UIImage?
    public let color: UIColor?
    public let titleColor: UIColor
    public let descriptionColor: UIColor
    public let titleFont: UIFont
    public let descriptionFont: UIFont
    public let descriptionLabelPadding: CGFloat
    public let titleLabelPadding: CGFloat
    
    public init(informationImage: UIImage, title: String, desc: String, pageIcon: UIImage?, color: UIColor, titleColor: UIColor, descColor: UIColor, titleFont: UIFont, descFont: UIFont, descPadding: CGFloat, titlePadding: CGFloat) {
        self.informationImage = informationImage
        self.title = title
        self.description = desc
        self.pageIcon = pageIcon
        self.color = color
        self.titleColor = titleColor
        self.descriptionColor = descColor
        self.titleFont = titleFont
        self.descriptionFont = descFont
        self.descriptionLabelPadding = descPadding
        self.titleLabelPadding = titlePadding
    }
}

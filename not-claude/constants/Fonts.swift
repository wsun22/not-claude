//
//  Fonts.swift
//  not-claude
//
//  Created by William Sun on 11/4/25.
//

import SwiftUI

extension Font {
    // mainly for code it seems
    static func firaCode() -> Font {
        return Font.custom("FiraCode-regular", size: 16)
    }
    
    // claude's words?
    static func tienne(fontStyle: Font.TextStyle = .body, fontWeight: Weight = .regular) -> Font {
        return Font.custom(CustomFont(weight: fontWeight).rawValue, size: fontStyle.size)
    }
    
    // user text/chat names
    static func styreneB(fontStyle: Font.TextStyle = .body) -> Font {
        return Font.custom("StyreneB-regular", size: fontStyle.size)
    }
}

extension Font.TextStyle {
    var size: CGFloat {
        switch self {
        case .largeTitle: return 34
        case .title: return 30
        case .title2: return 22
        case .title3: return 20
        case .headline: return 18
        case .body: return 16
        case .callout: return 15
        case .subheadline: return 14
        case .footnote: return 13
        case .caption: return 12
        case .caption2: return 11
        @unknown default: return 8
        }
    }
}

enum CustomFont: String {
    case regular = "Tienne-regular"
    case bold = "Tienne-bold"
    
    init(weight: Font.Weight) {
        switch weight {
        case .regular:
            self = .regular
        case .bold:
            self = .bold
        default:
            self = .regular
        }
    }
}

//
//  DataDetectorTextView.swift
//  Plain Notes
//
//  Created by Md Abir Hossain on 14/2/23.
//

import Foundation
import SwiftUI


struct DataDetectorTextView: UIViewRepresentable {
    let text: String
    
    func makeUIView(context _: Context) -> UITextView {
        let view = UITextView()
        
        view.text = text
        view.autocapitalizationType = .sentences
        view.font = UIFont.preferredFont(forTextStyle: .body)
        view.font = view.font?.withSize(16)
//        view.font = fontWeight(.light) as? UIFont
        
        view.dataDetectorTypes = [.phoneNumber, .link]
        view.isEditable = false
        view.isSelectable = true
        
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.isScrollEnabled = true
        view.textContainer.lineFragmentPadding = 0
        view.linkTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.systemBlue,
//            NSAttributedString.Key.font: UIFont(name: "Roboto", size: 16)!
        ]
        
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context _: Context) {
        
        uiView.text = text
        uiView.sizeToFit()
        uiView.backgroundColor = UIColor(white: 1, alpha: 0)
        
    }
}

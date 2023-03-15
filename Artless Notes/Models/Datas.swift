//
//  Data.swift
//  Plain Notes
//
//  Created by Md Abir Hossain on 30/1/23.
//

import Foundation
import SwiftUI

struct Tags {
    var tagName: String?
}


struct Datas {
    var tagName: String?
    var title: String?
    var description: String?
    var addDate: String?
    var editDate: String?
}


struct DataTextView: UIViewRepresentable {
 
    var text: NSAttributedString
    var dataDetectorTypes: UIDataDetectorTypes
    var fontName: String = "Roboto-Bold"
    var fontSize: CGFloat = 16
 
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
 
        textView.attributedText = text
        textView.autocapitalizationType = .sentences
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.textColor = UIColor(.gray)
        textView.font = UIFont(name: fontName, size: fontSize)
        textView.dataDetectorTypes = dataDetectorTypes
        textView.linkTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.systemBlue,
//            NSAttributedString.Key.font: UIFont(name: "Roboto", size: 16)!
        ]
 
        return textView
    }
 
    func updateUIView(_ uiView: UITextView, context: Context) {
    }
}

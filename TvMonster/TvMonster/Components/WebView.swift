//
//  WebView.swift
//  TvMonster
//
//  Created by Obed Garcia on 5/6/22.
//

import SwiftUI
import SafariServices

struct WebView: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        
    }
    
    let url: String
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: URL(string: url)!)
    }
}

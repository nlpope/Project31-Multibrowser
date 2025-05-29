//  File: HomeVC.swift
//  Project: Project31-Multibrowser
//  Created by: Noah Pope on 5/28/25.

import UIKit
import AVKit
import AVFoundation
import WebKit

class HomeVC: UIViewController, WKNavigationDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate
{
    @IBOutlet var addressBar: UITextField!
    @IBOutlet var hStackView: UIStackView!
    var logoLauncher: MBLogoLauncher!
    var player = AVPlayer()
    weak var activeWebView: WKWebView?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        addWebView()
        setDefaultTitle()
        configNavigation()
    }
    
    
    deinit { logoLauncher.removeAllAVPlayerLayers() }
    
    //-------------------------------------//
    // MARK: - NAVIGATION SETUP
    
    func setDefaultTitle() { title = "Multibrowser" }
    
    
    func configNavigation()
    {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWebView))
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteWebView))
        navigationItem.rightBarButtonItems = [delete, add]
    }
    
    //-------------------------------------//
    // MARK: - WEBVIEW ADDITION / SUBTRACTION
    
    @objc func addWebView()
    {
        let webView = WKWebView()
        webView.navigationDelegate = self
        
        hStackView.addArrangedSubview(webView)
        let url = URL(string: "https://www.github.com/nlpope")!
        webView.load(URLRequest(url: url))
        
        webView.layer.borderColor = UIColor.blue.cgColor
        selectWebView(webView)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(webViewTapped))
        recognizer.delegate = self
        webView.addGestureRecognizer(recognizer)
    }
    
    
    @objc func deleteWebView()
    {
        guard let webView = activeWebView else { return }
        guard let index = hStackView.arrangedSubviews.firstIndex(of: webView) else { return }
        
        webView.removeFromSuperview()
        if hStackView.arrangedSubviews.count == 0 { setDefaultTitle() }
        else {
            var currentIndex = Int(index)
            if currentIndex == hStackView.arrangedSubviews.count {
                currentIndex = hStackView.arrangedSubviews.count - 1
            }
            if let newSelectedWebView = hStackView.arrangedSubviews[currentIndex] as? WKWebView {
                selectWebView(newSelectedWebView)
            }
        }
    }
    
    //-------------------------------------//
    // MARK: - WEBVIEW SELECTION
    
    // don't understand how this is accessed || why it's here
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
        return true
    }
    
    
    @objc func webViewTapped(_ recognizer: UITapGestureRecognizer)
    {
        if let selectedWebView = recognizer.view as? WKWebView {
            selectWebView(selectedWebView)
        }
    }
    
    
    func selectWebView(_ webView: WKWebView)
    {
        for view in hStackView.arrangedSubviews { view.layer.borderWidth = 0 }
        activeWebView = webView
        webView.layer.borderWidth = 3
    }
    
    //-------------------------------------//
    // MARK: - TEXTFIELD DELEGATE METHODS
    
    // don't understand how this is accessed || why it's here
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if let webView = activeWebView, let address = addressBar.text {
            if let url = URL(string: address) { webView.load(URLRequest(url: url)) }
        }
        
        textField.resignFirstResponder()
        return true
    }
}
